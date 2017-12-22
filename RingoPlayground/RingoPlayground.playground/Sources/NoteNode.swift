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
    case Whole = 1
    case Half = 2
    case Quarter = 4
    case Eighth = 8
    case Sixteenth = 16
    case ThirtySecond = 32
}

public enum NoteStyle: Int {
    case Default
    case HiHat
}

public struct Note {
    public init(pitch: NotePitch, value: NoteValue, style: NoteStyle = .Default) {
        self.pitch = pitch
        self.value = value
        self.style = style
    } // For Playground only

    public var pitch: NotePitch // A, B, C, D, E..
    public var value: NoteValue // Quarter, Eighth, Sixteenth, etc
    public var style: NoteStyle // Normal, HiHat, etc

    var tick: Int? // The tick that the note is assigned to, only to be set programmatically
}

public struct Rest {
    public init() {} // For Playground only
    public var value: Int?
}

public class NoteNode: SKShapeNode {

    var note: Note?
    private(set) var reverse: Bool = false

    public convenience init(
        withNote myNote: Note,
        at myPosition: CGPoint,
        stemHeight: CGFloat? = nil,
        reverse: Bool = false) {
        switch myNote.style
        {
        case .HiHat:
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

        note = myNote
        self.reverse = reverse
        position = myPosition
        lineWidth = 2
        strokeColor = SKColor.black
        fillColor = SKColor.black

        drawStem(stemHeight: stemHeight)
    }

    func drawStem(stemHeight: CGFloat? = nil) {
        let path = CGMutablePath()

        if let note = self.note {
            switch note.style {
            case .HiHat:
                let y = noteHeadRadius * (reverse ? -1 : 1)
                path.move(to: CGPoint(x: noteHeadRadius + 1, y: y))
            case .Default:
                path.move(to: CGPoint(x: noteHeadRadius + 1, y: 0))
            }
        }

        let myStemHeight = stemHeight ?? noteHeadRadius * 6
        path.addLine(
            to: CGPoint(
                x: noteHeadRadius + 1,
                y: myStemHeight * (reverse ? -1.0 : 1.0)
            )
        )

        let stem = SKShapeNode()
        stem.path = path
        stem.strokeColor = SKColor.black
        stem.lineWidth = 1

        addChild(stem)
    }
}
