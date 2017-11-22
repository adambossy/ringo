import Foundation
import SpriteKit


public enum NotePitch {
    case E4
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

public struct Note {
    public init() {}
    public var pitch : NotePitch? // A, B, C, D, E..
    public var value : Int? // Duration of note in tick counts where 1 tick = 16th note
}

public struct Rest {
    public init() {}
    public var value : Int?
}


public class NoteNode : SKShapeNode {
    
    convenience public init(at _position: CGPoint) {
        
        // This horribleness, courtesy of: https://stackoverflow.com/questions/24373142/adding-convenience-initializers-in-swift-subclass/24536826#24536826
        // And yes, it looks *morally wrong.*
//        self.init()
        self.init(circleOfRadius: noteHeadRadius)

        position = _position
        lineWidth = 2
        strokeColor = SKColor.black
        fillColor = SKColor.black
        
        // THIS CODE BLOCK TRIGGERS THIS CRYPTIC MESSAGE:
        //  Context leak detected, msgtracer returned -1
        let stem = SKShapeNode()
        let path = CGMutablePath.init()
        path.move(to: CGPoint(x: noteHeadRadius + 1, y: 0))
        path.addLine(to: CGPoint(x: noteHeadRadius + 1, y: noteHeadRadius * 6))
        stem.path = path
        stem.strokeColor = SKColor.black
        stem.lineWidth = 1

        addChild(stem)
    }
}
