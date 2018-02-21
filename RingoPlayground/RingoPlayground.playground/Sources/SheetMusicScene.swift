import AVFoundation
import Foundation
import SpriteKit

let kSheetMusicPaddingX: CGFloat = 25.0
let kSheetMusicPaddingY: CGFloat = 10.0

let staffsPerLine : Int = 2

var player: AVAudioPlayer?
var camera: SKCameraNode?

public struct Song {
    public init(measures: [Measure]) {
        self.measures = measures
    }
    var measures: [Measure]
}

public class SheetMusicScene : SKScene {

    var numStaffs : Int = 0
    var song : Song?
    var staffs = [StaffNode]()
    
    public convenience init(song: Song, size: CGSize) {
        self.init(size: size)

        self.anchorPoint = CGPoint(x: 0, y: 1)
        self.scaleMode = SKSceneScaleMode.aspectFill
        self.backgroundColor = SKColor.white

        self.song = song
        numStaffs = song.measures.count
    }

    public override func didMove(to view: SKView) {
        super.didMove(to: view)

        let strongCameraRef = SKCameraNode()
        strongCameraRef.position = CGPoint(x: NSMidX(self.frame), y: 0)

        self.camera = strongCameraRef
        self.addChild(strongCameraRef)

        parseSong()
        playSong()
    }

    // MARK Layout functions

    func parseSong() {
        for (index, measure) in song!.measures.enumerated() {
            add(index: index, measure: measure)
        }
    }

    public func add(index: Int, measure: Measure) {
        let position = self.nextPosition(index: index)
        let rect = CGRect(
            x: position.x,
            y: position.y,
            width: self.staffWidth(index: index),
            height: staffHeight
        )
        let staff = StaffNode(measure: measure, rect: rect)
        staffs.append(staff)
        addChild(staff)
    }
    
    func nextPosition(index: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(index % staffsPerLine) * staffWidth(index: index) + kSheetMusicPaddingX,
            y: -CGFloat((index / staffsPerLine) + 1) * (staffHeight * 2.5)
        )
    }

    func staffsOnLine(forIndex index: Int) -> Int {
        let threshold = (numStaffs / staffsPerLine * staffsPerLine)
        if index >= threshold {
            return numStaffs - threshold
        } else {
            return staffsPerLine
        }
    }
    
    func staffWidth(index: Int) -> CGFloat {
        let staffsOnLine = self.staffsOnLine(forIndex: index)
        return (self.size.width - (kSheetMusicPaddingX * 2)) / CGFloat(staffsOnLine)
    }

    // MARK Music playback
    
    func playSong() {
        if let asset = NSDataAsset(name:NSDataAsset.Name(rawValue: "Rush_TomSawyer")) {
            do {
                player = try AVAudioPlayer(data:asset.data, fileTypeHint:"mp3")
                player?.play()
                
                Timer.scheduledTimer(
                    timeInterval: 0.4,
                    target: self,
                    selector: #selector(SheetMusicScene.startMetronome),
                    userInfo: nil,
                    repeats: false) // Hardcoding Tom Sawyer start delay as 0.4
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }

    @objc
    func startMetronome() {
//        Timer.scheduledTimer(timeInterval: tickDuration() * 16, target: self, selector: #selector(SheetMusicScene.nextStaff), userInfo: nil, repeats: true) //
//        Timer.scheduledTimer(timeInterval: tickDuration(), target: self, selector: #selector(SheetMusicScene.printTick), userInfo: nil, repeats: true) //
    }

    @objc
    func printTick() {
        let tick = currentTick()
        print("tick", tick)
        if tick.truncatingRemainder(dividingBy: 16) < 1 {
//            nextStaff()
        }
    }

    func activeStaffIndex() -> Int {
        return Int(currentTick() / 16.0)
    }

    func activeStaffNode() -> StaffNode? {
        let staffIndex = activeStaffIndex()
        if staffIndex < staffs.count {
            return staffs[staffIndex]
        }
        return nil
    }
    
    @objc
    func nextStaff() {
        for staff in staffs {
            staff.active = false
        }

        let staffIndex = activeStaffIndex()
//        print("staffIndex", staffIndex, " % on line", staffIndex % staffsOnLine(forIndex: staffIndex))
        
        if staffIndex % staffsOnLine(forIndex: staffIndex) == 0 {
            let moveUp_ = SKAction.move(by: CGVector(dx: 0, dy: staffHeight * 2.5), duration: 0.5)
            for staffNode in staffs {
                staffNode.run(moveUp_)
            }
        }
        
        staffs[staffIndex].active = true
    }
    
    func beatDuration() -> Double { // Move to metronome class?
        return 60.0 / 87.7 // song.bpm // Hardcoding Tom Sawyer BPM for now
    }
    
    func tickDuration() -> Double {
        return beatDuration() / 4.0
    }

    // MARK Render user playback

    func currentTick() -> Double { // TODO Maybe this should return an Int, not sure yet
        if let currentTime = player?.currentTime {
            let startDelay = 1.0 // Hardcoding startDelay for Tom Sawyer
            let numTick = (currentTime - startDelay) / tickDuration()
            return numTick
        }
        return 0
    }
    
    override public func keyDown(with event: NSEvent) {
        if let staffNode = activeStaffNode() {
            let staffIndex = activeStaffIndex()
            let tick = currentTick() - (Double(staffIndex) * 16)
            
            switch UInt16(event.keyCode) {
            case Keycode.d:
                staffNode.userPlayed(atTick: tick, withPitch: KickPitch)
            case Keycode.f:
                staffNode.userPlayed(atTick: tick, withPitch: SnarePitch)
            case Keycode.j:
                staffNode.userPlayed(atTick: tick, withPitch: HiHatPitch)
            case Keycode.k:
                staffNode.userPlayed(atTick: tick, withPitch: CrashPitch)
            case Keycode.upArrow:
                camera?.run(SKAction.move(by: CGVector(dx: 0, dy: 100), duration: 0.5))
            case Keycode.downArrow:
                camera?.run(SKAction.move(by: CGVector(dx: 0, dy: -100), duration: 0.5))
            default:
                break
            }
        }
    }
}
