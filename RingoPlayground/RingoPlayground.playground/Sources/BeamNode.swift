import Foundation
import SpriteKit

let noteHeadRadius: CGFloat = (hLineDistance / 2) - hLineHeight - 2 // - 2 for lineWidth (e.g., stroke width)

enum BeamRank {
    case Primary // Eight notes
    case Secondary // Sixteenth notes
    case Tertiary // Thirty-second notes
}

class BeamNode: SKShapeNode {

    private(set) var notes: [Note] = [Note]()
    private(set) var reverse: Bool = false

    var left: CGPoint = CGPoint(x: 0, y: 0)
    var right: CGPoint = CGPoint(x: 0, y: 0)
    
    weak var owner : BeamedNotesNode?

    public convenience init(
        owner: BeamedNotesNode?,
        withNotes notes: [Note],
        reverse: Bool = false) {
        self.init(rect: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.owner = owner
        
        // Pre-condition: notes.count >= 2, in order to have two endpoints
        assert(notes.count >= 2)
        self.notes = notes
        self.reverse = reverse

        endpoints()
        draw(from: left, to: right)
    }

    func noteWithHighestPitch(atIndex index: Int) -> Note {
        // This function assumes notes are in order, sorted by the .tick attribute
        let minTick = notes[index].tick
        var highestNote : Note = notes[index]
        for note in notes {
            if note.tick != minTick {
                break
            }
            if note.pitch.rawValue > highestNote.pitch.rawValue {
                highestNote = note
            }
        }
        return highestNote
    }

    // FIXME: This function might be useless for secondary and tertiary beams
    func endpoints() {
        let leftHighest = noteWithHighestPitch(atIndex: 0)
        left = owner!.notePosition(leftHighest)

        let rightHighest = noteWithHighestPitch(atIndex: self.notes.count - 1)
        right = owner!.notePosition(rightHighest)

        massageEndpoints()
        setYOffset()
        fixStemHeights()
    }

    func massageEndpoints() {
        if left.y == right.y {
            return
        }

        if left.y > right.y && !reverse {
            right.y += beamYPos(from: left, to: right)
        } else if left.y < right.y && reverse {
            right.y -= beamYPos(from: left, to: right)
        } else if right.y > left.y && !reverse {
            left.y -= beamYPos(from: left, to: right)
        } else if right.y < left.y && reverse {
            left.y += beamYPos(from: left, to: right)
        }
    }

    func beamYPos(from: CGPoint, to: CGPoint) -> CGFloat {
        // FIXME: Make magic 1.3 constant named `slopeDampeningFactor` or something to that effect
        return ((from.y - to.y) / 1.3) * (reverse ? -1 : 1)
    }

    func setYOffset() {
        left.y += yOffset(forBeamRank: .Primary)
        right.y += yOffset(forBeamRank: .Primary)
    }

    func yOffset(forBeamRank beamRank: BeamRank) -> CGFloat {
        var y: CGFloat = noteHeadRadius

        switch beamRank {
        case .Primary:
            y *= 8
        case .Secondary:
            y *= 2
        case .Tertiary:
            y *= 2
        }

        y *= (reverse ? -1 : 1)

        return y
    }

    func fixStemHeights() {
        let minStemHeight = noteHeadRadius * 4
        var newYOffset: CGFloat = 0

        for note in notes {
            let notePosition = owner!.notePosition(note)
            let stemHeight = BeamedNotesNode.stemHeight(
                notePosition: notePosition,
                beamLeft: left,
                beamRight: right
            )
            if stemHeight < minStemHeight {
                newYOffset = max(newYOffset, minStemHeight - stemHeight)
            }
        }

        left.y += newYOffset * (reverse ? -1 : 1)
        right.y += newYOffset * (reverse ? -1 : 1)
    }

    func draw(from: CGPoint, to: CGPoint) {
        // FIXME: Validate that .tick is set on each note
        let path = NSBezierPath()
        path.move(to: CGPoint(x: from.x + noteHeadRadius + 0.5, y: from.y - (beamWidth / 2)))
        path.line(to: CGPoint(x: from.x + noteHeadRadius + 0.5, y: from.y + (beamWidth / 2)))
        path.line(to: CGPoint(x: to.x + noteHeadRadius + 1.5, y: to.y + (beamWidth / 2)))
        path.line(to: CGPoint(x: to.x + noteHeadRadius + 1.5, y: to.y - (beamWidth / 2)))
        path.close()

        let beam = SKShapeNode()
        beam.path = path.CGPath
        beam.lineJoin = CGLineJoin.miter
        beam.strokeColor = SKColor.black
        beam.fillColor = SKColor.black
        addChild(beam)
    }
}
