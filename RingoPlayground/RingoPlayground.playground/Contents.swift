import PlaygroundSupport
import SpriteKit

var measures = [
    Measure(
        notes: [
            Note(tick: 7, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 10, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 14, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 15, pitch: HiHatPitch, style: .HiHat),
            ]
    ),
    Measure(
        notes: [
            Note(tick: 1, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 5, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 7, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 9, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 10, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 13, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 14, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 15, pitch: HiHatPitch, style: .HiHat),
        ]
    ),
    Measure(
        notes: [
            Note(tick: 0, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 4, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 7, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 8, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 10, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 12, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 14, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 15, pitch: HiHatPitch, style: .HiHat),
        ]
    ),
    Measure(
        notes: [
            Note(tick: 0, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 1, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 4, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 5, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 7, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 8, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 9, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 10, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 12, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 13, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 14, pitch: HiHatPitch, style: .HiHat),
            Note(tick: 15, pitch: HiHatPitch, style: .HiHat),
        ]
    ),
    Measure(
        notes: [
        ]
    ),
    Measure(
        notes: [
        ]
    ),
    Measure(
        notes: [
        ]
    )
]
let song = Song(measures: measures)

let sceneWidth: CGFloat = 800
let sceneHeight: CGFloat = 1200
let scene = SheetMusicScene(song: song, size: CGSize(width: sceneWidth, height: sceneHeight))

// Playground sturf
let sceneView = SKView(frame: CGRect(x: 0, y: 0, width: sceneWidth, height: sceneHeight))
sceneView.showsFPS = true
sceneView.presentScene(scene)
PlaygroundSupport.PlaygroundPage.current.liveView = sceneView


//let path = NSBezierPath()
//
//let stemHeight = 10.5 * 6
//let startX = 10.5 + 1
//let startY = stemHeight
//path.move(to: CGPoint(x: startX, y: startY))
//path.curve(
//    to: CGPoint(x: startX + 20, y: 0),
//    controlPoint1: CGPoint(x: startX + 10, y: stemHeight / 2),
//    controlPoint2: CGPoint(x: startX + 20, y: stemHeight / 2))
//path.close()
//
//let flag = SKShapeNode()
//flag.path = path.CGPath
//flag.lineJoin = CGLineJoin.miter
//flag.strokeColor = SKColor.black
//flag.lineWidth = 2
//
//scene.addChild(flag)
