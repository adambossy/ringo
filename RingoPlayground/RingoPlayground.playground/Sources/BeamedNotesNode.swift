import Foundation
import SpriteKit

let beamWidth : CGFloat = 12

enum BeamRank {
    case Primary // Eight notes
    case Secondary // Sixteenth notes
    case Tertiary // Thirty-second notes
}

// This operates on quarter note-level (in 4/4 time) groupings of notes
public class BeamedNotesNode: SKShapeNode {

    var notes : [Note]!

    func yOffset(forNotePitch notePitch: NotePitch) -> CGFloat {
        return lineOffset + (hLineDistance / 2) * CGFloat(notePitch.rawValue)
    }
    
    func yOffset(forBeamRank beamRank: BeamRank) -> CGFloat {
        switch beamRank {
        case .Primary:
            return noteHeadRadius * 6
        case .Secondary:
            return noteHeadRadius * 4
        case .Tertiary:
            return noteHeadRadius * 2
        }
    }

    func drawBeam(fromNote: Note, toNote: Note, rank: BeamRank) {
        //FIXME Validate that .tick is set on each note

        let leftX : CGFloat = noteHeadRadius + (sixteenthNoteDistance * CGFloat(fromNote.tick!)) + 1
        let rightX : CGFloat = noteHeadRadius + (sixteenthNoteDistance * CGFloat(toNote.tick!)) + 1
        let leftY : CGFloat = self.yOffset(forNotePitch: fromNote.pitch) + self.yOffset(forBeamRank:rank)
        let rightY : CGFloat = self.yOffset(forNotePitch: toNote.pitch) + self.yOffset(forBeamRank:rank)
        
        let path = NSBezierPath()
        path.move(to: CGPoint(x: leftX, y: leftY - (beamWidth / 2)))
        path.line(to: CGPoint(x: leftX, y: leftY + (beamWidth / 2)))
        path.line(to: CGPoint(x: rightX, y: rightY + (beamWidth / 2)))
        path.line(to: CGPoint(x: rightX, y: rightY - (beamWidth / 2)))
        path.close()

//        let path = UIBezierPath()
//        path.move(to: CGPoint(x: leftX, y: leftY - (beamWidth / 2)))
//        path.addLine(to: CGPoint(x: leftX, y: leftY + (beamWidth / 2)))
//        path.addLine(to: CGPoint(x: rightX, y: rightY + (beamWidth / 2)))
//        path.addLine(to: CGPoint(x: rightX, y: rightY - (beamWidth / 2)))
//        path.close()
        
        let beam = SKShapeNode()
        beam.path = path.CGPath
        beam.lineJoin = CGLineJoin.miter
        beam.strokeColor = SKColor.black
        beam.fillColor = SKColor.black
//        beam.lineWidth = beamWidth
        
        self.addChild(beam)
    }

    func drawBeam(fromTick: CGFloat, toTick: CGFloat, rank: BeamRank) {
        self.drawBeam(fromTick: fromTick, toTick: toTick, rank: rank, pitchOffset: 0)
    }
    
    func drawBeam(fromTick: CGFloat, toTick: CGFloat, rank: BeamRank, pitchOffset: CGFloat) {
        let path = CGMutablePath.init()
        
        let leftX : CGFloat = noteHeadRadius + (sixteenthNoteDistance * CGFloat(fromTick))
        let rightX : CGFloat = noteHeadRadius + (sixteenthNoteDistance * CGFloat(toTick)) + 2

        path.move(to: CGPoint(x: leftX, y: self.yOffset(forBeamRank:rank)))
        path.addLine(to: CGPoint(x: rightX, y: (pitchOffset * hLineDistance) + self.yOffset(forBeamRank:rank)))

        let stem = SKShapeNode()
        stem.path = path
        stem.strokeColor = SKColor.black
        stem.lineWidth = 12

        self.addChild(stem)
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
            tickMask <<= 16 / note.value.rawValue // FIXME Meter class
        }
        return tickMask
    }

    func draw() {
        self.fillColor = SKColor.clear // Make invisible
        self.strokeColor = SKColor.clear

        for note in self.notes {
            let noteX = sixteenthNoteDistance * CGFloat(note.tick!)
            let noteY = self.yOffset(forNotePitch: note.pitch)
            print(noteY)
            let position = CGPoint(x: noteX, y: noteY)
            let node = NoteNode(withNote: note, at: position)
            self.addChild(node)
        }
        
        // Draw the primary (eighth note) beam connecting the first note to the last note in the set
        if notes.count > 1 {
            let firstNote = notes[0]
            let lastNote = notes[notes.count - 1]
            self.drawBeam(fromNote: firstNote, toNote: lastNote, rank: BeamRank.Primary)
        }
        
        // Draw the sixteenth note beams based on beaming rules which I can't find generalized rules for
        let tickMask = self.tickMask(forNotes: self.notes)
        switch tickMask {
        case 0b1011:
            self.drawBeam(fromTick: 2, toTick: 3, rank: BeamRank.Secondary) // FIXME Make ticks symbolic
        case 0b1100:
            self.drawBeam(fromTick: 0, toTick: 1, rank: BeamRank.Secondary)
        case 0b1110:
            self.drawBeam(fromTick: 0, toTick: 1, rank: BeamRank.Secondary)
        case 0b1101:
            self.drawBeam(fromTick: 0, toTick: 0.5, rank: BeamRank.Secondary)
            self.drawBeam(fromTick: 2.5, toTick: 3, rank: BeamRank.Secondary)
        default:
            break
        }
    }
}
