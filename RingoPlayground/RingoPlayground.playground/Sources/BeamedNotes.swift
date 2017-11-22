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
            }
            i += 1;
        }

        if let minNote = minNote, let maxNote = maxNote {
            if (maxNote > minNote) {
                self.drawBeam(fromTick: minNote, toTick: maxNote)
            }
        }
    }
}
