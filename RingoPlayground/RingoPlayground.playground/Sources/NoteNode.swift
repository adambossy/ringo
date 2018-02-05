import Foundation
import SpriteKit

public enum NotePitch: Int {
    case E4 = 1
    case F4
    case G4
    case A5
    case B5
    case C5
    case D5
    case E5
    case F5
    case G5
    case A6
}

public let CrashPitch = NotePitch.A6
public let HiHatPitch = NotePitch.G5
public let SnarePitch = NotePitch.C5
public let KickPitch = NotePitch.F4

// FIXME: Make a Meter class to calculate the tick values of all these
public enum NoteValue: Int {
    case Whole = 16
    case DottedHalf = 12
    case Half = 8
    case DottedQuarter = 6
    case Quarter = 4
    case DottedEighth = 3
    case Eighth = 2
    case Sixteenth = 1
}

public enum RestValue: Int {
    case Whole = 16
    case Half = 8
    case Quarter = 4
    case Eighth = 2
    case Sixteenth = 1
}

public enum NoteStyle: Int {
    case Default
    case HiHat
    case OpenHiHat
    case Crash
}

public struct Note {
    public init(tick: Int, pitch: NotePitch, style: NoteStyle = .Default) {
        self.tick = tick
        self.pitch = pitch
        self.style = style
    } // For Playground only

    public var pitch: NotePitch // A, B, C, D, E..
    public var value: NoteValue? // Quarter, Eighth, Sixteenth, etc
    public var style: NoteStyle // Normal, HiHat, etc

    // FIXME: This is currently being doubly-used at separate times during the program's control flow
    public var tick: Int // The tick that the note is assigned to, only to be set programmatically
}

public struct Rest {
    public init() {} // For Playground only
    public var value: Int?
}

public class NoteNode: SKShapeNode {

    var note: Note?
    var reverse: Bool = false
    public var showFlag : Bool = false {
        didSet {
            if let note = note {
                if (note.value == .Eighth || note.value == .DottedEighth) {
                    drawPrimaryFlag()
                } else if (note.value == .Sixteenth) {
                    drawPrimaryFlag()
                    drawSecondaryFlag()
                }
            }
        }
    }
    var stemHeight: CGFloat = 0

    public convenience init(
        withNote myNote: Note,
        at myPosition: CGPoint,
        stemHeight: CGFloat? = nil,
        reverse: Bool = false) {
        switch myNote.style
        {
        case .HiHat, .OpenHiHat, .Crash:
            let path = CGMutablePath()

            path.move(to: CGPoint(x: -noteHeadRadius, y: -noteHeadRadius))
            path.addLine(
                to: CGPoint(
                    x: noteHeadRadius,
                    y: noteHeadRadius
                )
            )

            path.move(to: CGPoint(x: -noteHeadRadius, y: noteHeadRadius))
            path.addLine(
                to: CGPoint(
                    x: noteHeadRadius,
                    y: -noteHeadRadius
                )
            )

            self.init(path: path)
        case .Default:
            self.init(circleOfRadius: noteHeadRadius)
        }

        self.note = myNote
        self.reverse = reverse
        self.stemHeight = stemHeight ?? noteHeadRadius * 6

        position = myPosition
        lineWidth = 2
        strokeColor = SKColor.black
        fillColor = SKColor.black

        drawStem()

        if (myNote.value == .DottedEighth || myNote.value == .DottedQuarter || myNote.value == .DottedHalf) {
            drawDot()
        }

        if myNote.style == .OpenHiHat {
            drawOpenHihatIndicator()
        } else if myNote.style == .Crash {
            drawCrashStrikethrough()
        }
    }

    func drawPrimaryFlag() {
        drawFlag(yOffset: 0.0)
    }

    func drawSecondaryFlag() {
        drawFlag(yOffset: stemHeight * 0.375)
    }

    func drawFlag(yOffset: CGFloat) {
        let path = NSBezierPath()

        let startX = noteHeadRadius + 1
        let startY = stemHeight
        path.move(to: CGPoint(x: startX, y: startY + (20 * 0.75) - yOffset))
        path.curve(
            to: CGPoint(x: startX + (20 * 0.75), y: stemHeight * 0.2 - yOffset),
            controlPoint1: CGPoint(x: startX + (6 * 0.75), y: startY - (12 * 0.75) - yOffset),
            controlPoint2: CGPoint(x: startX + (40 * 0.75), y: (stemHeight * 0.8) * 0.75 - yOffset)
        )
        path.curve(
            to: CGPoint(x: startX, y: stemHeight * 0.96 - yOffset),
            controlPoint1: CGPoint(x: startX + (32 * 0.875), y: stemHeight * (0.8 * 0.875) - yOffset),
            controlPoint2: CGPoint(x: startX, y: stemHeight * (0.8 * 0.875) - yOffset)
        )
        path.close()

        let flag = SKShapeNode()
        flag.path = path.CGPath
        flag.lineJoin = CGLineJoin.miter
        flag.strokeColor = SKColor.black
        flag.fillColor = SKColor.black
        flag.lineWidth = 1
        
        addChild(flag)
    }
    
    func drawStem() {
        let path = CGMutablePath()

        if let note = self.note {
            switch note.style {
            case .HiHat, .OpenHiHat, .Crash:
                // Render from top-right of note head
                let y = noteHeadRadius * (reverse ? -1 : 1)
                path.move(to: CGPoint(x: noteHeadRadius + 1, y: y))
            case .Default:
                // Render from middle-right of note head (for now)
                path.move(to: CGPoint(x: noteHeadRadius + 1, y: 0))
            }
        }

        path.addLine(
            to: CGPoint(
                x: noteHeadRadius + 1,
                y: stemHeight * (reverse ? -1.0 : 1.0)
            )
        )

        let stem = SKShapeNode()
        stem.path = path
        stem.strokeColor = SKColor.black
        stem.lineWidth = 1

        addChild(stem)
    }

    func drawDot() {
        let dotRadius = noteHeadRadius / 2.5
        let dot = SKShapeNode(circleOfRadius: dotRadius)
        dot.fillColor = SKColor.black
        dot.position = CGPoint(x: noteHeadRadius * 2, y: noteHeadRadius / 2 - dotRadius)
        addChild(dot)
    }

    func drawOpenHihatIndicator() {
        let indicator = SKShapeNode(circleOfRadius: noteHeadRadius * 0.75)
        indicator.position = CGPoint(x: noteHeadRadius * 0.5, y: stemHeight * 1.25)
        indicator.strokeColor = SKColor.black
        indicator.lineWidth = 1
        addChild(indicator)
    }

    func drawCrashStrikethrough() {
        let path = CGMutablePath()
        
        let fudgeFactor: CGFloat = 1.5
        path.move(to: CGPoint(x: -noteHeadRadius * fudgeFactor, y: -0.5))
        path.addLine(
            to: CGPoint(
                x: noteHeadRadius * fudgeFactor,
                y: -0.5
            )
        )
        
        let strikethrough = SKShapeNode()
        strikethrough.path = path
        strikethrough.strokeColor = SKColor.black
        strikethrough.lineWidth = 2
        addChild(strikethrough)
    }
}
