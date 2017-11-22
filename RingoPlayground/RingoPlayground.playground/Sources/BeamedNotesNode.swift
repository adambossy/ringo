import Foundation
import SpriteKit


// This operates on quarter note-level (in 4/4 time) groupings of notes
public class BeamedNotesNode: SKShapeNode {

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
        withNotes notes: [Bool]) {
        self.init(rect: CGRect(x: 0, y: 0, width: 1, height: 1))

        self.notes = notes
        self.offsetX = position.x
        self.offsetY = position.y
        self.draw()
    }

    func draw() {
        self.fillColor = SKColor.clear // Make invisible
        self.strokeColor = SKColor.clear

        var i = 0
        var minTick: Int? = nil // Rename minTick
        var maxTick: Int? = nil // Rename maxTick
        for note in self.notes {
            switch note {
            case true:
                self.addChild(
                    NoteNode(at: CGPoint(x: self.offsetX + (sixteenthNoteDistance * CGFloat(i)), y: self.offsetY))
                )
                minTick = minTick == nil ? i : min(minTick!, i)
                maxTick = maxTick == nil ? i : max(maxTick!, i)
            case false:
                break;
            }
            i += 1;
        }

        if let minTick = minTick, let maxTick = maxTick {
            if (maxTick > minTick) {
                self.drawBeam(fromTick: minTick, toTick: maxTick)
            }
        }
    }
}
