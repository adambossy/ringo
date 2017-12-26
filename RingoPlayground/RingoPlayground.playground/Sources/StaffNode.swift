import Foundation
import SpriteKit

let staffHeight: CGFloat = 100
let numHLines: Int = 5
let hLineHeight: CGFloat = 1
var hLineY: CGFloat = hLineHeight / 2
let hLineDistance = (staffHeight - (CGFloat(numHLines) * (hLineHeight - 1))) / CGFloat(numHLines - 1)
let lineOffset = hLineHeight / 2

// Time signature (4/4)
let beatsPerMeasure = 4
let oneBeatValue = 4

public struct Measure {
    public init(notes: [Note], tick: Int) {
        self.notes = notes
        self.tick = tick
    }

    public var notes: [Note]
    public var tick: Int
    // public var timeSignature // One day!
}

public class StaffNode: SKShapeNode {
    
    var measure: Measure?

    public convenience init(measure: Measure, rect: CGRect) {
        self.init(rect: rect)

        // TODO: Figure out why it's necessary to set the position alongside the rect
        position = CGPoint(x: rect.origin.x, y: rect.origin.y)
        fillColor = SKColor.white

        drawHorizontalLines()
        drawVerticalLine(atX: 0)
        drawVerticalLine(atX: frame.size.width)
        
        self.measure = measure
        parseMeasure()
    }

    func drawHorizontalLines() {
        var localHLineY = hLineY
        for _ in 0 ..< numHLines {
            let path = CGMutablePath()
            let line = SKShapeNode()
            path.move(to: CGPoint(x: 0, y: localHLineY))
            path.addLine(to: CGPoint(x: frame.size.width, y: localHLineY))
            line.path = path
            line.strokeColor = SKColor.black
            line.lineWidth = barWidth
            addChild(line)
            
            localHLineY -= hLineDistance
        }
    }

    func drawVerticalLine(atX x: CGFloat) {
        let path = CGMutablePath()
        let line = SKShapeNode()
        path.move(to: CGPoint(x: x, y: 0))
        path.addLine(to: CGPoint(x: x, y: -staffHeight))
        line.path = path
        line.strokeColor = SKColor.black
        line.lineWidth = hLineHeight
        addChild(line)
    }

    func parseMeasure() {
        // 12/4: 0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44 (48)
        // 6/4: 0, 4, 8, 12, 16, 20 (24)
        // 5/4: 0, 4, 8, 12, 16 (20)
        // 4/4: 0, 4, 8, 12 (16)
        // 3/4: 0, 4, 8 (12)
        // 2/4: 0, 4 (8)
        // 12/8: 0, 3, 6, 9 (12)
        // 9/8: 0, 3, 6 (9)
        // 6/8: 0, 3 (6)
        var tickGroup : Int = 0
        var noteGroup = [Note]()
        for note in measure!.notes {
            if note.tick >= tickGroup + ticksPerGroup() {
                add(notes: noteGroup, tick: tickGroup)
                tickGroup += ticksPerGroup()
                noteGroup = [Note]()
            }

            noteGroup.append(note)
        }
        
        // Add the last group, which is likely unaccounted for
        if noteGroup.count > 0 {
            add(notes: noteGroup, tick: tickGroup)
        }
    }

    func ticksPerGroup() -> Int {
        switch oneBeatValue {
        case 4:
            return 4
        case 8:
            return 3
        default:
            return 4
        }
    }

    /* TODO: May want to make this accept an abstract superclass of BeamedNotesNode, and allow things like rests to also subclass from
     that superclass
     */
    func add(notes: [Note], tick: Int) {
        let rect = CGRect(
            x: staffXPadding() + tickGroupWidth() * CGFloat(tick / 4),
            y: 0,
            width: tickGroupWidth(),
            height: staffHeight
        )
        let beamedNotes = BeamedNotesNode(notes: notes, rect: rect)
        addChild(beamedNotes)
    }

    func staffXPadding() -> CGFloat {
        return (frame.size.width / CGFloat(beatsPerMeasure * oneBeatValue)) / 4.0 // Trailing "/ 4" is fudge factor
    }

    func tickGroupWidth() -> CGFloat {
        return (frame.size.width - (staffXPadding() * 2)) / CGFloat(oneBeatValue)
    }
}
