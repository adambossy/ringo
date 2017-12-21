import Foundation
import SpriteKit

enum BeamRank {
    case Primary // Eight notes
    case Secondary // Sixteenth notes
    case Tertiary // Thirty-second notes
}

class BeamNode : SKShapeNode {

    private(set) var notes : [Note] = [Note]()
    private(set) var reverse : Bool = false
//    private(set) var rank : BeamRank = .Primary

    var left : CGPoint = CGPoint(x: 0, y: 0)
    var right : CGPoint = CGPoint(x: 0, y: 0)

    convenience public init(
        withNotes notes: [Note],
//        rank: BeamRank = BeamRank.Primary,
        reverse: Bool = false)
    {
        self.init(rect: CGRect(x: 0, y: 0, width: 1, height: 1))

        // Pre-condition: notes.count >= 2, in order to have two endpoints
        assert(notes.count >= 2)
        self.notes = notes
        self.reverse = reverse
//        self.rank = rank

        self.endpoints()
        self.draw(from: self.left, to: self.right)
    }

    // FIXME This function might be useless for secondary and tertiary beams
    func endpoints() {
        self.left = self.notePosition(notes[0])
        self.right = self.notePosition(notes[self.notes.count - 1])

        self.massageEndpoints()
        self.setYOffset()
        self.fixStemHeights()
    }

    func massageEndpoints() {
        if left.y == right.y {
            return
        }
        
        if self.left.y > self.right.y && !reverse {
            self.right.y += self.beamYPos(from: left, to: right)
        } else if self.left.y < self.right.y && reverse {
            self.right.y -= self.beamYPos(from: left, to: right)
        } else if self.right.y > self.left.y && !reverse {
            self.left.y -= self.beamYPos(from: left, to: right)
        } else if self.right.y < self.left.y && reverse {
            self.left.y += self.beamYPos(from: left, to: right)
        }
    }

    func beamYPos(from: CGPoint, to: CGPoint) -> CGFloat {
        // FIXME Make magic 1.3 constant named `slopeDampeningFactor` or something to that effect
        return ((from.y - to.y) / 1.3) * (self.reverse ? -1 : 1)
    }

    // FIXME: Duplicated, don't change one without the other
    func notePosition(_ note: Note) -> CGPoint {
        return CGPoint(
            x: noteHeadRadius + (sixteenthNoteDistance * CGFloat(note.tick!)) + 1,
            y: position.y + self.yOffset(forNotePitch: note.pitch)
        )
    }

    // FIXME: Duplicated, don't change one without the other
    func yOffset(forNotePitch notePitch: NotePitch) -> CGFloat {
        // Subtract 1 from rawValue, since the NotePitch enum starts at E4 and we have to adjust by (hLineDistance / 2). If we add more pitches in the 4th octave, we should adjust by more.
        // FIXME Codify magic constants
        return lineOffset + (hLineDistance / 2) * CGFloat(notePitch.rawValue - 1)
    }
    
    func setYOffset() {
        self.left.y += self.yOffset(forBeamRank: .Primary)
        self.right.y += self.yOffset(forBeamRank: .Primary)
    }

    func yOffset(forBeamRank beamRank: BeamRank) -> CGFloat {
        var y : CGFloat = noteHeadRadius
        
        switch beamRank {
        case .Primary:
            y *= 8
        case .Secondary:
            y *= 2
        case .Tertiary:
            y *= 2
        }
        
        y *= (self.reverse ? -1 : 1)
        
        return y
    }

    func fixStemHeights() {
        let minStemHeight = noteHeadRadius * 4
        var newYOffset : CGFloat = 0
        
        for note in notes {
            let notePosition = self.notePosition(note)
            let stemHeight = BeamedNotesNode.stemHeight(
                notePosition: notePosition,
                beamLeft: self.left,
                beamRight: self.right
            )
            if stemHeight < minStemHeight {
                newYOffset = max(newYOffset, minStemHeight - stemHeight)
            }
        }
        
        self.left.y += newYOffset * (self.reverse ? -1 : 1)
        self.right.y += newYOffset * (self.reverse ? -1 : 1)
    }

    func draw(from: CGPoint, to: CGPoint) {
        //FIXME Validate that .tick is set on each note
        let path = NSBezierPath()
        path.move(to: CGPoint(x: from.x + noteHeadRadius + 1, y: from.y - (beamWidth / 2)))
        path.line(to: CGPoint(x: from.x + noteHeadRadius + 1, y: from.y + (beamWidth / 2)))
        path.line(to: CGPoint(x: to.x + noteHeadRadius + 1, y: to.y + (beamWidth / 2)))
        path.line(to: CGPoint(x: to.x + noteHeadRadius + 1, y: to.y - (beamWidth / 2)))
        path.close()
        
        let beam = SKShapeNode()
        beam.path = path.CGPath
        beam.lineJoin = CGLineJoin.miter
        beam.strokeColor = SKColor.black
        beam.fillColor = SKColor.black
        self.addChild(beam)
    }
}