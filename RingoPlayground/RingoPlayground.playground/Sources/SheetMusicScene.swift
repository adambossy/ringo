import AVFoundation
import Foundation
import SpriteKit

let kSheetMusicPaddingX: CGFloat = 25.0
let kSheetMusicPaddingY: CGFloat = 10.0

let staffsPerLine : Int = 2

var player: AVAudioPlayer?

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
        self.scaleMode = SKSceneScaleMode.aspectFill
        self.backgroundColor = SKColor.white

        self.song = song
        numStaffs = song.measures.count
        parseSong()
        playSong()
    }

    func playSong() {
        if let asset = NSDataAsset(name:NSDataAsset.Name(rawValue: "Rush_TomSawyer")) {
            do {
                player = try AVAudioPlayer(data:asset.data, fileTypeHint:"mp3")
                player?.play()

                Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(SheetMusicScene.printTime), userInfo: nil, repeats: true)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }

    @objc
    func printTime() {
        print("currentTime ", player?.currentTime as Any)
    }
    
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

    override public func keyDown(with event: NSEvent) {
        print("keycode", event.keyCode)
        switch UInt16(event.keyCode) {
        case Keycode.d:
            print("d")
        case Keycode.f:
            print("f")
        case Keycode.j:
            print("j")
        case Keycode.k:
            print("k")
        default:
            break
        }
    }
}
