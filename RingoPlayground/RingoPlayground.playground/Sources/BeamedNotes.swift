import Foundation
import SpriteKit


// This operates on quarter note-level (in 4/4 time) groupings of notes
public class BeamedNotes : SKShapeNode {

    var notes : [Bool]!
    var offsetX : CGFloat!
    var offsetY : CGFloat!

    func drawBeam(fromTick: Int, toTick: Int) {
        let stem = SKShapeNode()
        let path = CGMutablePath.init()
        
        let leftBound : CGFloat = self.offsetX + noteHeadRadius + (sixteenthNoteDistance * CGFloat(fromTick))
        let rightBound : CGFloat = self.offsetX + noteHeadRadius + (sixteenthNoteDistance * CGFloat(toTick)) + 2
        path.move(to: CGPoint(x: leftBound, y: self.offsetY + (noteHeadRadius * 6)))
        path.addLine(to: CGPoint(x: rightBound, y: self.offsetY + (noteHeadRadius * 6)))
        stem.path = path
        stem.strokeColor = SKColor.black
        stem.lineWidth = 12
        self.addChild(stem)
    }
    
    convenience public init(
        withNotes notes: [Bool],
        at position: CGPoint) {
        self.init(rect: CGRect(x: position.x, y: position.y, width: 1, height: 1))

        self.notes = notes
        self.offsetX = position.x
        self.offsetY = position.y
        self.draw()
    }

    func draw() {
        self.fillColor = SKColor.clear // Make invisible
        self.strokeColor = SKColor.clear

        var i = 0
        var minNote: Int? = nil // Rename minTick
        var maxNote: Int? = nil // Rename maxTick
        for note in self.notes {
            switch note {
            case true:
                self.addChild(
                    NoteNode(at: CGPoint(x: self.offsetX + (sixteenthNoteDistance * CGFloat(i)), y: self.offsetY))
                )
                minNote = minNote == nil ? i : min(minNote!, i)
                maxNote = maxNote == nil ? i : max(maxNote!, i)
            case false:
                break;
//                self.addChild(
//                    NoteNode(at: CGPoint(x: position.x + (sixteenthNoteDistance * i), y: offsetY), noteHeadRadius: noteHeadRadius)
//                )
            }
            i += 1;
        }

        if let minNote = minNote, let maxNote = maxNote {
            if (maxNote > minNote) {
                self.drawBeam(fromTick: minNote, toTick: maxNote)
            }
        }
/*
        let note1 = NoteNode(at: CGPoint(x: offsetX, y: offsetY), noteHeadRadius: noteHeadRadius)
        let note2 = NoteNode(at: CGPoint(x: offsetX + sixteenthNoteDistance, y: offsetY), noteHeadRadius: noteHeadRadius)
        let note3 = NoteNode(at: CGPoint(x: offsetX + (sixteenthNoteDistance * 2), y: offsetY), noteHeadRadius: noteHeadRadius)
        let note4 = NoteNode(at: CGPoint(x: offsetX + (sixteenthNoteDistance * 3), y: offsetY), noteHeadRadius: noteHeadRadius)
 
        self.addChild(note1)
        self.addChild(note2)
        self.addChild(note3)
        self.addChild(note4)
*/
//        // THIS CODE BLOCK TRIGGERS THIS CRYPTIC MESSAGE:
//        //  Context leak detected, msgtracer returned -1
//        let stem = SKShapeNode()
//        let path = CGMutablePath.init()
//        path.move(to: CGPoint(x: offsetX + noteHeadnoteHeadRadius, y: offsetY + (noteHeadnoteHeadRadius * 6)))
//        path.addLine(to: CGPoint(x: offsetX + noteHeadnoteHeadRadius + (sixteenthNoteDistance * 3) + 2, y: offsetY + (noteHeadnoteHeadRadius * 6)))
//        stem.path = path
//        stem.strokeColor = SKColor.black
//        stem.lineWidth = 12
//        beamedQuadruplet.addChild(stem)
//        
//        let stem2 = SKShapeNode()
//        let path2 = CGMutablePath.init()
//        path2.move(to: CGPoint(x: offsetX + noteHeadnoteHeadRadius, y: offsetY + (noteHeadnoteHeadRadius * 4)))
//        path2.addLine(to: CGPoint(x: offsetX + noteHeadnoteHeadRadius + (sixteenthNoteDistance * 3) + 2, y: offsetY + (noteHeadnoteHeadRadius * 4)))
//        stem2.path = path2
//        stem2.strokeColor = SKColor.black
//        stem2.lineWidth = 12
//        beamedQuadruplet.addChild(stem2)
    }

}
