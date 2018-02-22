import AVFoundation
import Foundation
import SpriteKit

let kSheetMusicPaddingX: CGFloat = 25.0
let kSheetMusicPaddingY: CGFloat = 10.0

let staffsPerLine : Int = 2
let countdownStaffs : Int = 2 // Two measures
let startDelay = 1.0 // Hardcoding startDelay for Tom Sawyer

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
    var staffs = [StaffNode]()
    var activeStaff : StaffNode?

    var song : Song?
    var songStarted : Bool = false

    var beepTimer : Timer?
    var beepPlayer : AVAudioPlayer?
    var beepsStartedInterval : TimeInterval?
    var countdownBeeps : Int = 0

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

        layoutSong()
        start()
    }

    // MARK Layout functions

    func layoutSong() {
        layoutCountdownStaffs()
        layoutMeasures()
    }

    func layoutCountdownStaffs() {
        for index in 0..<countdownStaffs {
            add(index: index, measure: Measure(notes: [Note]()))
        }
    }

    func layoutMeasures() {
        for (index, measure) in song!.measures.enumerated() {
            add(index: index + countdownStaffs, measure: measure)
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
        let threshold = (numStaffs + countdownStaffs) / staffsPerLine * staffsPerLine
        // Threshold is a terrible variable name. This if check determines whether the staff at
        // index `index` is on the last line and whether we should stretch it as a result
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

    // MARK Game mechanics

    func start() {
        // Put ALL schedulerTimer calls in this function instead of chaining them, as would be cleaner or more logical perhaps, to help mitigate clock drift

        // Initiate countdown
        loadBeep()
        playBeep()
        startBeeps()

        // Start song
        let countdownDoneInterval = beatDuration() * Double(countdownStaffs) * 4.0
        Timer.scheduledTimer(
            timeInterval: countdownDoneInterval - startDelay,
            target: self,
            selector: #selector(SheetMusicScene.playSong),
            userInfo: nil,
            repeats: false
        )
        Timer.scheduledTimer(
            timeInterval: countdownDoneInterval,
            target: self,
            selector: #selector(SheetMusicScene.songDidStart),
            userInfo: nil,
            repeats: false)

        // Staff highlighting
        activeStaff = staffs[0]
        nextStaff()
        Timer.scheduledTimer(
            timeInterval: 0.01, // Inexplicable why this should be 0.01
            target: self,
            selector: #selector(SheetMusicScene.startWithDelay),
            userInfo: nil,
            repeats: false)

        // Move camera
        // May want to adjust speed based on staffs per current line each time we hit a new line
        // once we support odd time signatures and the time signature changes up mid-song
        let panDuration = beatDuration() * Double(4 * staffsPerLine)
        let move = SKAction.move(by: CGVector(dx: 0, dy: -staffHeight * 2.5), duration: panDuration)
        camera?.run(SKAction.repeatForever(move))
    }

    @objc
    func startWithDelay() {
        Timer.scheduledTimer(
            timeInterval: beatDuration() * 4,
            target: self,
            selector: #selector(SheetMusicScene.nextStaff),
            userInfo: nil,
            repeats: true)
    }

    func startBeeps() {
        beepTimer = Timer.scheduledTimer(
            timeInterval: beatDuration(),
            target: self,
            selector: #selector(SheetMusicScene.playBeep),
            userInfo: nil,
            repeats: true
        )
    }

    func loadBeep() {
        if let asset = NSDataAsset(name:NSDataAsset.Name(rawValue: "beep-7")) {
            do {
                beepPlayer = try AVAudioPlayer(data:asset.data, fileTypeHint:"mp3")
                beepPlayer?.prepareToPlay()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK Music playback

    @objc
    func playBeep() {
        if beepsStartedInterval == nil {
            beepsStartedInterval = beepPlayer?.deviceCurrentTime
        }

        if countdownBeeps < countdownStaffs * 4 {
            beepPlayer?.play()

            let staffIndex = countdownBeeps / 4
            let staffNode = staffs[staffIndex]
            let tick = Double(countdownBeeps * 4).truncatingRemainder(dividingBy: 16)
            staffNode.userPlayed(atTick: tick, withPitch: SnarePitch)

            countdownBeeps += 1
        } else {
            beepTimer?.invalidate()
        }
    }

    @objc
    func playSong() {
        if let asset = NSDataAsset(name:NSDataAsset.Name(rawValue: "Rush_TomSawyer")) {
            do {
                player = try AVAudioPlayer(data:asset.data, fileTypeHint:"mp3")
                player?.play()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }

    @objc
    func songDidStart() {
        songStarted = true
    }

    func activeStaffIndex() -> Int {
        let x = Int(currentTick() / 16.0)
        print("!!!!! currentTick", currentTick())
        return x
    }

    func activeStaffNode() -> StaffNode? {
        let staffIndex = activeStaffIndex()
        print("!!!!!!! activeStaffIndex", activeStaffIndex())
        if staffIndex < staffs.count {
            return staffs[staffIndex]
        }
        return nil
    }
    
    @objc
    func nextStaff() {
        print("nextStaff")
        activeStaff?.active = false
        activeStaff = activeStaffNode()
        activeStaff?.active = true
    }
    
    func beatDuration() -> Double { // Move to metronome class?
        return 60.0 / 87.7 // song.bpm // Hardcoding Tom Sawyer BPM for now
    }
    
    func tickDuration() -> Double {
        return beatDuration() / 4.0
    }

    // MARK Render user playback

    func currentTick() -> Double { // TODO Maybe this should return an Int, not sure yet
        if !songStarted {
            if let deviceCurrentTime = beepPlayer?.deviceCurrentTime, let beepsStartedInterval = self.beepsStartedInterval {
                print("deviceCurrentTime", deviceCurrentTime)
                return (deviceCurrentTime - beepsStartedInterval) / tickDuration()
            }
        } else {
            if let currentTime = player?.currentTime {
                let countdownOffset = Double(countdownStaffs * 16)
                return (currentTime - startDelay) / tickDuration() + countdownOffset
            }
        }
        return 0
    }
    
    func currentTickInMeasure() -> Double {
        let staffIndex = activeStaffIndex()
        let tick = currentTick() - (Double(staffIndex) * 16)
        print("staffIndex", staffIndex, "tick", tick, "currentTick", currentTick())
        return tick
    }
    
    override public func keyDown(with event: NSEvent) {
        if let staffNode = activeStaffNode() {
            let tick = currentTickInMeasure()
            
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
            case Keycode.leftArrow:
                camera?.run(SKAction.move(by: CGVector(dx: -100, dy: 0), duration: 0.5))
            case Keycode.rightArrow:
                camera?.run(SKAction.move(by: CGVector(dx: 100, dy: 0), duration: 0.5))
            default:
                break
            }
        }
    }
}
