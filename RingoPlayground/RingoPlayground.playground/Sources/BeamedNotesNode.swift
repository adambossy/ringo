import Foundation
import SpriteKit

let beamWidth : CGFloat = 12

enum BeamRank {
    case Primary // Eight notes
    case Secondary // Sixteenth notes
    case Tertiary // Thirty-second notes
}

enum BeamHalf {
    case Whole
    case FirstHalf
    case SecondHalf
}

// This operates on quarter note-level (in 4/4 time) groupings of notes
public class BeamedNotesNode: SKShapeNode {

    var notes : [Note]!

    func yOffset(forNotePitch notePitch: NotePitch) -> CGFloat {
        // Subtract 1 from rawValue, since the NotePitch enum starts at E4 and we have to adjust by (hLineDistance / 2). If we add more pitches in the 4th octave, we should adjust by more.
        return lineOffset + (hLineDistance / 2) * CGFloat(notePitch.rawValue - 1)
    }
    
    func yOffset(forBeamRank beamRank: BeamRank) -> CGFloat {
        switch beamRank {
        case .Primary:
            return noteHeadRadius * 8
        case .Secondary:
            return noteHeadRadius * 2
        case .Tertiary:
            return noteHeadRadius * 2
        }
    }

    func notePosition(_ note: Note) -> CGPoint {
        return CGPoint(
            x: noteHeadRadius + (sixteenthNoteDistance * CGFloat(note.tick!)) + 1,
            y: self.yOffset(forNotePitch: note.pitch)
        )
    }

    func noteEndpoints(fromNote: Note, toNote: Note) -> (CGPoint, CGPoint) {
        return (notePosition(fromNote), notePosition(toNote))
    }

    func beamYPos(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.y - to.y) / 1.3
    }

    func interpolatedNoteEndpoints(fromNote: Note, toNote: Note) -> (CGPoint, CGPoint) {
        let (left, right) = noteEndpoints(fromNote: fromNote, toNote: toNote)

        if left.y == right.y {
            return (left, right)
        }

        var myLeft = left
        var myRight = right

        if myLeft.y > myRight.y {
            myRight.y += self.beamYPos(from: left, to: right)
        } else if myRight.y > myLeft.y {
            myLeft.y -= self.beamYPos(from: left, to: right)
        }

        return (myLeft, myRight)
    }
    
    // FIXME This function might be useless for secondary and tertiary beams
    func beamEndpoints(fromNote: Note, toNote: Note, rank: BeamRank) -> (CGPoint, CGPoint) {
        let (left, right) = interpolatedNoteEndpoints(fromNote: fromNote, toNote: toNote)

        var myLeft = left
        var myRight = right

        myLeft.y += self.yOffset(forBeamRank: rank)
        myRight.y += self.yOffset(forBeamRank: rank)

        return (myLeft, myRight)
    }

    func beamFragmentEndpoints(
        beamLeft: CGPoint,
        beamRight: CGPoint,
        fragmentLeftX: CGFloat,
        fragmentRightX: CGFloat,
        whichHalf beamHalf: BeamHalf = .Whole) -> (CGPoint, CGPoint)
    {
        var myFragmentLeftX = fragmentLeftX
        var myFragmentRightX = fragmentRightX
        
        // Maybe factor the `half` logic into its own function
        if beamHalf == .FirstHalf {
            myFragmentRightX = myFragmentLeftX + (sixteenthNoteDistance / 2)
        } else if beamHalf == .SecondHalf {
            myFragmentLeftX = myFragmentRightX - (sixteenthNoteDistance / 2)
        }
        
        let slope = (beamRight.y - beamLeft.y) / (beamRight.x - beamLeft.x)
        
        let leftXDelta = myFragmentLeftX - beamLeft.x
        let yAtLeftX = beamLeft.y + (slope * leftXDelta)

        let rightXDelta = myFragmentRightX - beamLeft.x
        let yAtRightX = beamLeft.y + (slope * rightXDelta)

        return (
            CGPoint(x: myFragmentLeftX, y: yAtLeftX),
            CGPoint(x: myFragmentRightX, y: yAtRightX)
        )
    }
    
    func secondaryBeamEndpoints(
        beamLeft: CGPoint,
        beamRight: CGPoint,
        fromNote: Note,
        toNote: Note,
        rank: BeamRank,
        whichHalf beamHalf: BeamHalf = .Whole) -> (CGPoint, CGPoint)
    {
        let (left, right) = self.beamFragmentEndpoints(
            beamLeft: beamLeft,
            beamRight: beamRight,
            fragmentLeftX: self.notePosition(fromNote).x,
            fragmentRightX: self.notePosition(toNote).x,
            whichHalf: beamHalf)
        
        var myLeft = left
        var myRight = right
        
        myLeft.y -= self.yOffset(forBeamRank: rank)
        myRight.y -= self.yOffset(forBeamRank: rank)
        
        return (myLeft, myRight)
    }
    
    func drawSecondaryBeams(
        beamLeft: CGPoint,
        beamRight: CGPoint,
        fromIndex: Int,
        toIndex: Int,
        whichHalf beamHalf: BeamHalf = .Whole)
    {
        // TODO Validate fromIndex and toIndex
        if let notes = self.notes {
            let (left, right) = self.secondaryBeamEndpoints(
                beamLeft: beamLeft,
                beamRight: beamRight,
                fromNote: notes[fromIndex],
                toNote: notes[toIndex],
                rank: BeamRank.Secondary,
                whichHalf: beamHalf)
            self.drawBeam(from: left, to: right)
        }
    }

    func drawBeam(fromNote: Note, toNote: Note, rank: BeamRank) -> (CGPoint, CGPoint) {
        let (left, right) = beamEndpoints(fromNote: fromNote, toNote: toNote, rank: rank)

        self.drawBeam(from: left, to: right)

        return (left, right)
    }
    
    func drawBeam(from: CGPoint, to: CGPoint) {
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

    /* Compute at which tick each note lands.  Compute this once and use it over and over.
 
     Don't burden the user with being responsible for this, and don't create a hard validation problem for this class.
     */
    func annotateTicks(forNotes: [Note]) {
        if notes.count == 0 {
            return
        }

        var tick : Int = 0
        // Use enumerated() so we can mutate note in the for loop
        for (index, _) in notes.enumerated() {
            notes[index].tick = tick
            tick += 16 / notes[index].value.rawValue // FIXME Meter class
        }
    }

    convenience public init(withTicks notes: [Note]) {
        self.init(rect: CGRect(x: 0, y: 0, width: 1, height: 1))

        self.notes = notes
        self.annotateTicks(forNotes: notes)
        
        self.draw()
    }

    func tickMask(forNotes notes: [Note]) -> Int {
        var tickMask : Int = 0
        for note in notes {
            tickMask <<= 1
            tickMask |= 1
            // FIXME Meter class
            tickMask <<= (16 / note.value.rawValue) - 1
        }
        return tickMask
    }

    func stemHeight(notePosition: CGPoint, beamLeft: CGPoint, beamRight: CGPoint) -> CGFloat {
        let slope = (beamRight.y - beamLeft.y) / (beamRight.x - beamLeft.x)
        let xDelta = notePosition.x - beamLeft.x
        let yAtNoteX = slope * xDelta
        return yAtNoteX + (beamLeft.y - notePosition.y)
    }
    
    func drawNotes(beamLeft: CGPoint, beamRight: CGPoint) {
        for note in self.notes {
            let position = self.notePosition(note)
            let stemHeight = self.stemHeight(notePosition: position, beamLeft: beamLeft, beamRight: beamRight)
            let node = NoteNode(withNote: note, at: position, stemHeight: stemHeight)
            self.addChild(node)
        }
    }
    
    func drawPrimaryBeams() -> (CGPoint, CGPoint)? {
        /* Draw the primary (eighth note) beam connecting the first note to the last note in the set */
        if notes.count > 1 {
            let firstNote = notes[0]
            let lastNote = notes[notes.count - 1]
            return self.drawBeam(fromNote: firstNote, toNote: lastNote, rank: BeamRank.Primary)
        }

        return nil
    }

    func drawSecondaryBeams(beamLeft: CGPoint, beamRight: CGPoint) {
        // Draw the sixteenth note beams based on beaming rules which I can't find generalized rules for, hence the switch case
        let tickMask = self.tickMask(forNotes: self.notes)
        switch tickMask {
        case 0b1011:
            self.drawSecondaryBeams(
                beamLeft: beamLeft,
                beamRight: beamRight,
                fromIndex: 1,
                toIndex: 2)
//        case 0b1100:
//            self.drawBeam(fromTick: 0, toTick: 1, rank: BeamRank.Secondary)
        case 0b1110:
            self.drawSecondaryBeams(
                beamLeft: beamLeft,
                beamRight: beamRight,
                fromIndex: 0,
                toIndex: 1)
        case 0b1101:
            self.drawSecondaryBeams(
                beamLeft: beamLeft,
                beamRight: beamRight,
                fromIndex: 0,
                toIndex: 1,
                whichHalf: .FirstHalf)
            self.drawSecondaryBeams(
                beamLeft: beamLeft,
                beamRight: beamRight,
                fromIndex: 1,
                toIndex: 2,
                whichHalf: .SecondHalf)
        default:
            break
        }
    }
    
    func draw() {
        self.fillColor = SKColor.clear // Make invisible
        self.strokeColor = SKColor.clear

        if let (left, right) = self.drawPrimaryBeams() {
            self.drawSecondaryBeams(beamLeft: left, beamRight: right)
            self.drawNotes(beamLeft: left, beamRight: right)
        }
    }
}
