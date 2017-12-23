import Foundation
import SpriteKit

let kSheetMusicPaddingX: CGFloat = 100.0
let kSheetMusicPaddingY: CGFloat = 100.0

public class SheetMusicScene : SKScene {
 
    let staffsPerLine : Int = 3
    var numStaffs : Int = 0
    
    public override init(size: CGSize) {
        super.init(size: size)
        self.anchorPoint = CGPoint(x: 0, y: 1)
        self.backgroundColor = SKColor.white
    }
    
    // Declare the number of staffs to render on each line instead of a pixel width (and then size to fit parent)
//    public convenience init(numStaffs: Int = 3) {
//
//    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func nextPosition() -> CGPoint {
        return CGPoint(
            x: CGFloat(numStaffs % staffsPerLine) * barDistance + kSheetMusicPaddingX,
            y: -CGFloat((numStaffs / staffsPerLine) + 1) * (staffHeight * 2)
        )
    }
    
    public func add(staff: StaffNode) {
        staff.position = self.nextPosition()
        addChild(staff)
        
        numStaffs += 1
        print(staff.position)
    }
}
