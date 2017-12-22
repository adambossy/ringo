import Foundation
import SpriteKit

let beamWidth: CGFloat = 12

// This operates on quarter note-level (in 4/4 time) groupings of notes
public class BeamedNotesNode: SKShapeNode {

    var noteNodes: [NoteNode]?
    var beam: BeamNode?
//    var childBeams : [BeamNode]?

    private(set) var notes: [Note] = [Note]()
    private(set) var reverse: Bool = false

    public convenience init(withTicks notes: [Note], reverse: Bool = false) {
        self.init(rect: CGRect(x: 0, y: 0, width: 1, height: 1))

        self.notes = notes
        annotateTicks(forNotes: notes)
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

    /* Compute at which tick each note lands.  Compute this once and use it over and over.

     Don't burden the user with being responsible for this, and don't create a hard validation problem for this class.
     */
    func annotateTicks(forNotes _: [Note]) {
        if notes.count == 0 {
            return
        }

        var tick: Int = 0
        // Use enumerated() so we can mutate note in the for loop
        for (index, _) in notes.enumerated() {
            notes[index].tick = tick
            tick += 16 / notes[index].value.rawValue // FIXME: Meter class
        }
    }

    func tickMask(forNotes notes: [Note]) -> Int {
        var tickMask: Int = 0
        for note in notes {
            tickMask <<= 1
            tickMask |= 1
            // FIXME: Meter class
            tickMask <<= (16 / note.value.rawValue) - 1
        }
        return tickMask
    }

    // FIXME: Duplicated, don't change one without the others
    func yOffset(forNotePitch notePitch: NotePitch) -> CGFloat {
        // Subtract 1 from rawValue, since the NotePitch enum starts at E4 and we have to adjust by (hLineDistance / 2). If we add more pitches in the 4th octave, we should adjust by more.
        // FIXME: Codify magic constants
        return lineOffset + (hLineDistance / 2) * CGFloat(notePitch.rawValue - 1)
    }

    // FIXME: Duplicated, don't change one without the others
    func notePosition(_ note: Note) -> CGPoint {
        return CGPoint(
            x: noteHeadRadius + (sixteenthNoteDistance * CGFloat(note.tick!)) + 1,
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
            addChild(node)
        }
    }

    func drawPrimaryBeams() {
        /* Draw the primary (eighth note) beam connecting the first note to the last note in the set */
        if notes.count > 1 {
            beam = BeamNode(
                withNotes: notes,
//                rank: .Primary,
                reverse: reverse
            )
        }
    }

    func drawSecondaryBeams() {
        // Draw the sixteenth note beams based on beaming rules which I can't find generalized rules for, hence the switch case
        let tickMask = self.tickMask(forNotes: notes)
        switch tickMask {
        case 0b1011:
            drawSecondaryBeams(
                fromIndex: 1,
                toIndex: 2)
        //        case 0b1100:
        //            self.drawBeam(fromTick: 0, toTick: 1, rank: BeamRank.Secondary)
        case 0b1110:
            drawSecondaryBeams(
                fromIndex: 0,
                toIndex: 1)
        case 0b1101:
            drawSecondaryBeams(
                fromIndex: 0,
                toIndex: 1,
                whichHalf: .FirstHalf)
            drawSecondaryBeams(
                fromIndex: 1,
                toIndex: 2,
                whichHalf: .SecondHalf)
        case 0b1111:
            drawSecondaryBeams(
                fromIndex: 0,
                toIndex: 3)
        default:
            break
        }
    }

    func drawSecondaryBeams(
        fromIndex: Int,
        toIndex: Int,
        whichHalf beamHalf: BeamHalf = .Whole) {
        if let beam = self.beam {
            let secondaryBeam = BeamFragmentNode(
                notes: notes,
                parentBeam: beam,
                fromIndex: fromIndex,
                toIndex: toIndex,
                rank: BeamRank.Secondary,
                whichHalf: beamHalf,
                reverse: reverse)
            addChild(secondaryBeam)
        }
    }

    func draw() {
        fillColor = SKColor.clear // Make invisible
        strokeColor = SKColor.clear

        drawPrimaryBeams()
        drawSecondaryBeams()
        drawNotes()
    }
}
