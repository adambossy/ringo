import Foundation
import SpriteKit

let beamWidth: CGFloat = 12

// This operates on quarter note-level (in 4/4 time) groupings of notes
public class BeamedNotesNode: SKShapeNode {

    var beam: BeamNode?
//    var childBeams : [BeamNode]?

    var notes: [Note] = [Note]()
    var noteNodes: [NoteNode] = [NoteNode]()
    var reverse: Bool = false

    public convenience init(notes: [Note], rect: CGRect, reverse: Bool = false) {
        assert(rect.size.width > 0 && rect.size.height > 0)

        self.init(rect: rect)

        // TODO: Figure out why it's necessary to set the position alongside the rect
        position = CGPoint(x: rect.origin.x, y: rect.origin.y)

        self.notes = notes
        self.reverse = reverse

        draw()
    }

    static func stemHeight(
        notePosition: CGPoint,
        beamLeft: CGPoint,
        beamRight: CGPoint) -> CGFloat {
        let slope = (beamRight.y - beamLeft.y) / (beamRight.x - beamLeft.x)
        let xDelta = notePosition.x - beamLeft.x
        let yAtNoteX = slope * xDelta
        return abs(yAtNoteX + (beamLeft.y - notePosition.y))
    }

    func tickMask() -> Int {
        if notes.count == 0 {
            return 0
        }

        let lowerBound = (notes[0].tick / 4) * 4
        let upperBound = ((notes[0].tick / 4) + 1) * 4

        var tickMask = 0
        var lastTick = lowerBound
        for note in notes {
            tickMask <<= note.tick - lastTick
            tickMask |= 1
            lastTick = note.tick
        }
        tickMask <<= upperBound - lastTick - 1
        return tickMask
    }

    func yOffset(forNotePitch notePitch: NotePitch) -> CGFloat {
        // Subtract 1 from rawValue, since the NotePitch enum starts at E4 and we have to adjust by (hLineDistance / 2). If we add more pitches in the 4th octave, we should adjust by more.
        // FIXME: Codify magic constants
        return lineOffset + (hLineDistance / 2) * CGFloat(notePitch.rawValue - 1) - staffHeight
    }

    func xAtTick(tick: Int) -> CGFloat {
        return noteHeadRadius + (sixteenthNoteDistance() * CGFloat(tick)) + 1
    }

    func restPosition(tick: Int) -> CGPoint {
        let mainTick = tick / 4 * 4
        return CGPoint(
            x: xAtTick(tick: tick - mainTick),
            y: position.y + yOffset(forNotePitch: .B5)
        )
    }

    func notePosition(_ note: Note) -> CGPoint {
        let mainTick = note.tick / 4 * 4
        return CGPoint(
            x: xAtTick(tick: note.tick - mainTick),
            y: position.y + yOffset(forNotePitch: note.pitch)
        )
    }

    func drawNotes() {
        for note in notes {
            let position = notePosition(note)
            var stemHeight : CGFloat?
            if let beam = self.beam {
                stemHeight = BeamedNotesNode.stemHeight(
                    notePosition: position,
                    beamLeft: beam.left,
                    beamRight: beam.right)
            }
            let node = NoteNode(
                withNote: note,
                at: position,
                stemHeight: stemHeight,
                reverse: reverse
            )
            add(noteNode: node)
        }
    }

    func add(noteNode: NoteNode) {
        addChild(noteNode)
        noteNodes.append(noteNode)
    }
    
    func drawPrimaryBeams() {
        /* Draw the primary (eighth note) beam connecting the first note to the last note in the set */
        if notes.count > 1 && notes[0].tick != notes[notes.count - 1].tick {
            beam = BeamNode(
                owner: self,
                withNotes: notes,
//                rank: .Primary,
                reverse: reverse
            )
            if let beam = beam {
                addChild(beam)
            }
        }
    }

    func drawSecondaryBeams() {
        // Draw the sixteenth note beams based on beaming rules which I can't find generalized rules for, hence the switch case
        let tickMask = self.tickMask()
        switch tickMask {
        case 0b0000: // 0
            drawRest(atTick: 0, value: .Quarter)
        case 0b0001: // 1
            drawRest(atTick: 0, value: .DottedEighth)
            noteNodes[0].showFlag = true
        case 0b0010: // 2
            drawRest(atTick: 0, value: .Eighth)
            noteNodes[0].showFlag = true
        case 0b0011: // 3
            drawRest(atTick: 0, value: .Eighth)
            drawSecondaryBeams(
                fromTick: 2,
                toTick: 3)
        case 0b0100: // 4
            drawRest(atTick: 0, value: .Sixteenth)
            noteNodes[0].showFlag = true
        case 0b0101: // 5
            drawRest(atTick: 0, value: .Sixteenth)
            drawSecondaryBeams(
                fromTick: 2,
                toTick: 3,
                whichHalf: .SecondHalf)
        case 0b0110: // 6
            drawRest(atTick: 0, value: .Sixteenth)
            drawSecondaryBeams(
                fromTick: 1,
                toTick: 2,
                whichHalf: .FirstHalf)
        case 0b0111: // 7
            drawRest(atTick: 0, value: .Sixteenth)
            drawSecondaryBeams(
                fromTick: 1,
                toTick: 3)
        case 0b1000: // 8
            break
        case 0b1001: // 9
            drawSecondaryBeams(
                fromTick: 2,
                toTick: 3,
                whichHalf: .SecondHalf)
        case 0b1010: // 10
            break // TODO: May want to draw primary beam here instead of separately
        case 0b1011: // 11
            drawSecondaryBeams(
                fromTick: 2,
                toTick: 3)
        case 0b1100: // 12
            drawSecondaryBeams(
                fromTick: 0,
                toTick: 1,
                whichHalf: .FirstHalf)
        case 0b1101: // 13
            drawSecondaryBeams(
                fromTick: 0,
                toTick: 1,
                whichHalf: .FirstHalf)
            drawSecondaryBeams(
                fromTick: 2,
                toTick: 3,
                whichHalf: .SecondHalf)
        case 0b1110: // 14
            drawSecondaryBeams(
                fromTick: 0,
                toTick: 1)
        case 0b1111: // 15
            drawSecondaryBeams(
                fromTick: 0,
                toTick: 3)
        default:
            break
        }
    }

    func drawSecondaryBeams(
        fromTick: Int,
        toTick: Int,
        whichHalf beamHalf: BeamHalf = .Whole) {
        if let beam = self.beam {
            let secondaryBeam = BeamFragmentNode(
                owner: self,
                notes: notes,
                parentBeam: beam,
                fromTick: fromTick,
                toTick: toTick,
                rank: BeamRank.Secondary,
                whichHalf: beamHalf,
                reverse: reverse)
            addChild(secondaryBeam)
        }
    }

    func drawRest(atTick tick: Int, value: RestValue) {
        var imageName : String

        switch value {
        case .Whole:
            imageName = "WholeRest"
        case .Half:
            imageName = "HalfRest"
        case .Quarter:
            imageName = "QuarterRest"
        case .DottedEighth:
            fallthrough
        case .Eighth:
            imageName = "8thRest"
        case .Sixteenth:
            imageName = "16thRest"
        }

        let rest = SKSpriteNode(imageNamed: imageName)
        rest.position = restPosition(tick: tick)
        rest.setScale(0.2) // Fudge factor given my image sizes

        if (value == .DottedEighth) {
            drawDot(forRest: rest)
        }

        addChild(rest)
    }

    func drawDot(forRest rest: SKSpriteNode) {
        // Copied from NoteNode
        let dotRadius = noteHeadRadius / 2.5
        let dot = SKShapeNode(circleOfRadius: dotRadius)
        dot.fillColor = SKColor.black
        dot.position = CGPoint(x: noteHeadRadius * 10, y: noteHeadRadius * 5 - dotRadius)
        dot.setScale(5)
        rest.addChild(dot)
    }

    func draw() {
        fillColor = SKColor.clear // Make invisible
        strokeColor = SKColor.clear

        // This order may seem funky but it's important. The beam determines how tall the height that each note's stem should be. The notes create noteNodes, and drawSecondaryBeams adds secondary beams along with additional styling
        drawPrimaryBeams()
        drawNotes()
        drawSecondaryBeams()
    }
    
    // TODO: func tripletDistance...
    func sixteenthNoteDistance() -> CGFloat {
        return frame.size.width / 4 // FIXME: Hardcoded 4/4
    }
}
