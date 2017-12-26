import Foundation
import SpriteKit

let kSheetMusicPaddingX: CGFloat = 100.0
let kSheetMusicPaddingY: CGFloat = 100.0

let staffsPerLine : Int = 3

public struct Song {
    public init(measures: [Measure]) {
        self.measures = measures
    }
    var measures: [Measure]
}

public class SheetMusicScene : SKScene {

    var numStaffs : Int = 0
    var song : Song?
    
    public convenience init(song: Song, size: CGSize) {
        self.init(size: size)
        self.anchorPoint = CGPoint(x: 0, y: 1)
        self.backgroundColor = SKColor.white

        self.song = song
        parseSong()
    }
    
    // Declare the number of staffs to render on each line instead of a pixel width (and then size to fit parent)
//    public convenience init(numStaffs: Int = 3) {
//
//    }

//    public required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
    
    func parseSong() {
        for measure in song!.measures {
            add(measure: measure)
        }
    }

    public func add(measure: Measure) {
        let position = self.nextPosition()
        let rect = CGRect(
            x: position.x,
            y: position.y,
            width: self.staffWidth(),
            height: staffHeight
        )
        let staff = StaffNode(measure: measure, rect: rect)
        addChild(staff)
        
        numStaffs += 1
    }
    
    func nextPosition() -> CGPoint {
        return CGPoint(
            x: CGFloat(numStaffs % staffsPerLine) * staffWidth() + kSheetMusicPaddingX,
            y: -CGFloat((numStaffs / staffsPerLine) + 1) * (staffHeight * 2)
        )
    }
    
    func staffWidth() -> CGFloat {
        return self.size.width / CGFloat(numStaffs + 1) - (kSheetMusicPaddingX * 2)
    }
}
