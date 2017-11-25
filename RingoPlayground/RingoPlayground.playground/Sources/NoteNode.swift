import Foundation
import SpriteKit


public enum NotePitch : Int {
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
}

// FIXME Make a Meter class to calculate the tick values of all these
public enum NoteValue : Int {
    case Whole = 1
    case Half = 2
    case Quarter = 4
    case Eighth = 8
    case Sixteenth = 16
    case ThirtySecond = 32
}

public let HitHatPitch = NotePitch.G4
public let SnarePitch = NotePitch.B5
public let KickPitch = NotePitch.G5

public struct Note {
    public init(pitch: NotePitch, value: NoteValue) {
        self.pitch = pitch
        self.value = value
    } // For Playground only

    public var pitch : NotePitch // A, B, C, D, E..
    public var value : NoteValue // Quarter, Eighth, Sixteenth, etc

    var tick : Int? // The tick that the note is assigned to, only to be set programmatically
}

public struct Rest {
    public init() {} // For Playground only
    public var value : Int?
}


public class NoteNode : SKShapeNode {

    var note : Note?

    convenience public init(withNote myNote: Note, at myPosition: CGPoint) {
        self.init(withNote: myNote, at: myPosition, stemHeight: noteHeadRadius * 6)
    }

    convenience public init(withNote myNote: Note, at myPosition: CGPoint, stemHeight: CGFloat) {
        self.init(circleOfRadius: noteHeadRadius)

        note = myNote
        position = myPosition
        lineWidth = 2
        strokeColor = SKColor.black
        fillColor = SKColor.black

        let path = CGMutablePath.init()
        path.move(to: CGPoint(x: noteHeadRadius + 1, y: 0))
        path.addLine(to: CGPoint(x: noteHeadRadius + 1, y: stemHeight))

        let stem = SKShapeNode()
        stem.path = path
        stem.strokeColor = SKColor.black
        stem.lineWidth = 1

        addChild(stem)
    }
}
