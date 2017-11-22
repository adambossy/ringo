import PlaygroundSupport
import SpriteKit

let sceneWidth : CGFloat = 800
let sceneHeight : CGFloat = 600

let staffHeight : CGFloat = 100

let numBars : Int = 2
let barWidth : CGFloat = 2
var barX : CGFloat = barWidth / 2

let barDistance = (sceneWidth - (CGFloat(numBars) * barWidth)) / CGFloat(numBars)

let numHLines : Int = 5
let hLineHeight : CGFloat = 1
var hLineY : CGFloat = hLineHeight / 2

let hLineDistance = (staffHeight - (CGFloat(numHLines) * (hLineHeight - 1))) / CGFloat(numHLines - 1)

// Every Good Boy Deserves Fudge
let lineOffset = hLineHeight / 2
let E4 = lineOffset
let F4 = lineOffset + (hLineDistance / 2)
let G4 = lineOffset + hLineDistance
let A4 = lineOffset + hLineDistance + (hLineDistance / 2)
let B5 = lineOffset + (hLineDistance * 2)
let C5 = lineOffset + (hLineDistance * 2) + (hLineDistance / 2)
let D5 = lineOffset + (hLineDistance * 3)
let E5 = lineOffset + (hLineDistance * 3) + (hLineDistance / 2)
let F5 = lineOffset + (hLineDistance * 4)
let G5 = lineOffset + (hLineDistance * 4) + (hLineDistance / 2)

let HiHatY = G5
let SnareY = C5
let KickY = F4

let noteHeadRadius : CGFloat = (hLineDistance / 2) - hLineHeight - 2 // - 2 for lineWidth (e.g., stroke width)


let staffXPadding : CGFloat = barDistance / 16 / 4 // Trailing "/ 4" is fudge factor
let sixteenthNoteDistance = (barDistance - (staffXPadding * 2)) / 16




let sceneView = SKView(frame: CGRect(x:0 , y:0, width: sceneWidth, height: sceneHeight))

let scene = SKScene(size: CGSize(width: sceneWidth, height: sceneHeight))
scene.backgroundColor = SKColor.white
sceneView.showsFPS = true
sceneView.presentScene(scene)
PlaygroundSupport.PlaygroundPage.current.liveView = sceneView


// Staff Canvas
let staff = SKShapeNode(rect: CGRect(x: 0, y:0, width: sceneWidth, height: sceneHeight / 2))
staff.fillColor = SKColor.lightGray
scene.addChild(staff)


for _ in 0 ..< numBars + 1 {
    let path = CGMutablePath.init()
    let line = SKShapeNode()
    path.move(to: CGPoint(x: barX, y: 0))
    path.addLine(to: CGPoint(x: barX, y: staffHeight))
    line.path = path
    line.strokeColor = SKColor.black
    line.lineWidth = barWidth
    scene.addChild(line)
    
    barX += barDistance
}


for _ in 0 ..< numHLines {
    let path = CGMutablePath.init()
    let line = SKShapeNode()
    path.move(to: CGPoint(x: 0, y: hLineY))
    path.addLine(to: CGPoint(x: staff.frame.size.width, y: hLineY))
    line.path = path
    line.strokeColor = SKColor.black
    line.lineWidth = barWidth
    scene.addChild(line)
    
    hLineY += hLineDistance
}


var xPositions : [CGFloat] = [CGFloat]()
var xPos = staffXPadding + sixteenthNoteDistance / 2
for _ in 0 ..< 16 {
    xPositions.append(xPos)
    xPos += sixteenthNoteDistance
}

print(xPositions)



var eighthNoteG4 = Note()
eighthNoteG4.pitch = NotePitch.G4
eighthNoteG4.value = 8

var eighthNoteG5 = Note()
eighthNoteG5.pitch = NotePitch.G5
eighthNoteG5.value = 8

var beamedNotes = BeamedNotes(withNotes: [true, false, false, false], at: CGPoint(x: xPositions[0], y: G5))

scene.addChild(beamedNotes)


beamedNotes = BeamedNotes(withNotes: [true, false, true, false], at: CGPoint(x: xPositions[4], y: G5))

scene.addChild(beamedNotes)


beamedNotes = BeamedNotes(withNotes: [true, false, true, true], at: CGPoint(x: xPositions[8], y: G5))

scene.addChild(beamedNotes)



beamedNotes = BeamedNotes(withNotes: [true, true, true, false], at: CGPoint(x: xPositions[12], y: G5))

scene.addChild(beamedNotes)
