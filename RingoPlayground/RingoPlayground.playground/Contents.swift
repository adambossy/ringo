import PlaygroundSupport
import SpriteKit

var measures = [
    Measure(
        notes: [
            Note(tick: 0, pitch: CrashPitch, style: .Crash),
            Note(tick: 0, pitch: KickPitch),
            Note(tick: 4, pitch: SnarePitch),
            Note(tick: 4, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 5, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 6, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 7, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 8, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 9, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 10, pitch: KickPitch),
            Note(tick: 10, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 11, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 12, pitch: SnarePitch),
            Note(tick: 12, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 13, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 14, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 15, pitch: HiHatPitch, style: .HiHat),
        ]
    ),
    Measure(
        notes: [
            Note(tick: 0, pitch: KickPitch),
            Note(tick: 0, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 1, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 2, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 3, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 4, pitch: SnarePitch),
            Note(tick: 4, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 5, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 6, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 7, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 8, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 9, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 10, pitch: KickPitch),
            Note(tick: 10, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 11, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 12, pitch: SnarePitch),
            Note(tick: 12, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 13, pitch: KickPitch),
            Note(tick: 13, pitch: HiHatPitch, style: .OpenHiHat),
            Note(tick: 14, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 15, pitch: HiHatPitch, style: .HiHat),
        ]
    ),
    Measure(
        notes: [
            Note(tick: 0, pitch: KickPitch),
            Note(tick: 0, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 1, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 2, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 3, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 4, pitch: SnarePitch),
            Note(tick: 4, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 5, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 6, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 7, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 8, pitch: KickPitch),
            Note(tick: 8, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 9, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 10, pitch: KickPitch),
            Note(tick: 10, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 11, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 12, pitch: SnarePitch),
            Note(tick: 12, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 13, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 14, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 15, pitch: HiHatPitch, style: .HiHat),
        ]
    ),
    Measure(
        notes: [
            Note(tick: 0, pitch: KickPitch),
            Note(tick: 0, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 1, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 2, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 3, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 4, pitch: SnarePitch),
            Note(tick: 4, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 5, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 6, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 7, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 8, pitch: KickPitch),
            Note(tick: 8, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 9, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 10, pitch: KickPitch),
            Note(tick: 10, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 11, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 12, pitch: SnarePitch),
            Note(tick: 12, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 13, pitch: KickPitch),
            Note(tick: 13, pitch: HiHatPitch, style: .OpenHiHat),
            Note(tick: 14, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 15, pitch: HiHatPitch, style: .HiHat),
        ]
    ),
    Measure(
        notes: [
            Note(tick: 0, pitch: KickPitch),
            Note(tick: 0, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 1, pitch: KickPitch),
            Note(tick: 1, pitch: HiHatPitch, style: .OpenHiHat),
            Note(tick: 2, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 3, pitch: KickPitch),
            Note(tick: 3, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 4, pitch: SnarePitch),
            Note(tick: 4, pitch: CrashPitch, style: .HiHat),
            Note(tick: 5, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 6, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 7, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 8, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 9, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 10, pitch: KickPitch),
            Note(tick: 10, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 11, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 12, pitch: SnarePitch),
            Note(tick: 12, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 13, pitch: KickPitch),
            Note(tick: 13, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 14, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 15, pitch: HiHatPitch, style: .HiHat),
        ]
    ),
    Measure(
        notes: [
            Note(tick: 0, pitch: KickPitch),
            Note(tick: 0, pitch: CrashPitch, style: .Crash),
            Note(tick: 2, pitch: SnarePitch),
            Note(tick: 3, pitch: KickPitch),
            Note(tick: 3, pitch: CrashPitch, style: .Crash),
            Note(tick: 6, pitch: KickPitch),
            Note(tick: 6, pitch: CrashPitch, style: .Crash),
            Note(tick: 8, pitch: SnarePitch),
            Note(tick: 9, pitch: KickPitch),
            Note(tick: 9, pitch: CrashPitch, style: .Crash),
            Note(tick: 11, pitch: SnarePitch),
            Note(tick: 12, pitch: KickPitch),
            Note(tick: 12, pitch: CrashPitch, style: .Crash),
            Note(tick: 13, pitch: KickPitch),
            Note(tick: 14, pitch: SnarePitch),
            Note(tick: 15 , pitch: SnarePitch),
        ]
    )
]
let song = Song(measures: measures)

let sceneWidth: CGFloat = 800
let sceneHeight: CGFloat = 600
let scene = SheetMusicScene(song: song, size: CGSize(width: sceneWidth, height: sceneHeight))

// Playground sturf
let sceneView = SKView(frame: CGRect(x: 0, y: 0, width: sceneWidth, height: sceneHeight))
sceneView.showsFPS = true
sceneView.presentScene(scene)
PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
