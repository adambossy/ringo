import Foundation
import SpriteKit

let staffHeight: CGFloat = 100
let numHLines: Int = 5

public class StaffNode: SKShapeNode {

    public convenience init(at _position: CGPoint) {
        self.init(rect: CGRect(x: _position.x, y: _position.y, width: barDistance, height: sceneHeight / 2))
        position = _position

        fillColor = SKColor.white

        drawHorizontalLine(atX: 0)
        drawHorizontalLine(atX: barDistance)

        var localHLineY = hLineY
        for _ in 0 ..< numHLines {
            let path = CGMutablePath()
            let line = SKShapeNode()
            path.move(to: CGPoint(x: 0, y: localHLineY))
            path.addLine(to: CGPoint(x: barDistance, y: localHLineY))
            line.path = path
            line.strokeColor = SKColor.black
            line.lineWidth = barWidth
            addChild(line)

            localHLineY -= hLineDistance
        }
    }

    func drawHorizontalLine(atX x: CGFloat) {
        let path = CGMutablePath()
        let line = SKShapeNode()
        path.move(to: CGPoint(x: x, y: 0))
        path.addLine(to: CGPoint(x: x, y: -staffHeight))
        line.path = path
        line.strokeColor = SKColor.black
        line.lineWidth = hLineHeight
        addChild(line)
    }

    func xPos(atTick tick: Int) -> CGFloat {
        let noteOffset = sixteenthNoteDistance / 2 // FIXME: Do away with this
        return staffXPadding + noteOffset + (sixteenthNoteDistance * CGFloat(tick))
    }

    /* FIXME: May want to make this accept an abstract superclass of BeamedNotesNode, and allow things like rests to also subclass from
     that superclass
     */
    public func addNotes(
        _ notesNode: BeamedNotesNode,
        atTick tick: Int) {
        notesNode.position = CGPoint(x: xPos(atTick: tick), y: -staffHeight)
        addChild(notesNode)
    }
}
