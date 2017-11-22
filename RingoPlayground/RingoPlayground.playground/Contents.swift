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

func makeTwoEighthNotes(at position: CGPoint) -> SKNode {
    let beamedPair = SKShapeNode(rect: CGRect(x: position.x, y: position.y, width: 1, height: 1))
    beamedPair.fillColor = SKColor.clear // Make invisible
    beamedPair.strokeColor = SKColor.clear

    let offsetX = position.x
    let offsetY = position.y
    
    let pairDistanceX = sixteenthNoteDistance * 2
    
    let note1 = NoteNode(at: CGPoint(x: offsetX, y: offsetY))
    let note2 = NoteNode(at: CGPoint(x: offsetX + pairDistanceX, y: offsetY))
    
    beamedPair.addChild(note1)
    beamedPair.addChild(note2)

    // THIS CODE BLOCK TRIGGERS THIS CRYPTIC MESSAGE:
    //  Context leak detected, msgtracer returned -1
    let stem = SKShapeNode()
    let path = CGMutablePath.init()
    path.move(to: CGPoint(x: offsetX + noteHeadRadius, y: offsetY + (noteHeadRadius * 6)))
    path.addLine(to: CGPoint(x: offsetX + noteHeadRadius + pairDistanceX + 2, y: offsetY + (noteHeadRadius * 6)))
    stem.path = path
    stem.strokeColor = SKColor.black
    stem.lineWidth = 12
    beamedPair.addChild(stem)

    return beamedPair
}

func makeFourSixteenthNotes(at position: CGPoint) -> SKNode {
    let beamedQuadruplet = SKShapeNode(rect: CGRect(x: position.x, y: position.y, width: 1, height: 1))
    beamedQuadruplet.fillColor = SKColor.clear // Make invisible
    beamedQuadruplet.strokeColor = SKColor.clear
    
    let offsetX = position.x
    let offsetY = position.y
    
    let note1 = NoteNode(at: CGPoint(x: offsetX, y: offsetY))
    let note2 = NoteNode(at: CGPoint(x: offsetX + sixteenthNoteDistance, y: offsetY))
    let note3 = NoteNode(at: CGPoint(x: offsetX + (sixteenthNoteDistance * 2), y: offsetY))
    let note4 = NoteNode(at: CGPoint(x: offsetX + (sixteenthNoteDistance * 3), y: offsetY))
    
    beamedQuadruplet.addChild(note1)
    beamedQuadruplet.addChild(note2)
    beamedQuadruplet.addChild(note3)
    beamedQuadruplet.addChild(note4)
    
    // THIS CODE BLOCK TRIGGERS THIS CRYPTIC MESSAGE:
    //  Context leak detected, msgtracer returned -1
    let stem = SKShapeNode()
    let path = CGMutablePath.init()
    path.move(to: CGPoint(x: offsetX + noteHeadRadius, y: offsetY + (noteHeadRadius * 6)))
    path.addLine(to: CGPoint(x: offsetX + noteHeadRadius + (sixteenthNoteDistance * 3) + 2, y: offsetY + (noteHeadRadius * 6)))
    stem.path = path
    stem.strokeColor = SKColor.black
    stem.lineWidth = 12
    beamedQuadruplet.addChild(stem)

    let stem2 = SKShapeNode()
    let path2 = CGMutablePath.init()
    path2.move(to: CGPoint(x: offsetX + noteHeadRadius, y: offsetY + (noteHeadRadius * 4)))
    path2.addLine(to: CGPoint(x: offsetX + noteHeadRadius + (sixteenthNoteDistance * 3) + 2, y: offsetY + (noteHeadRadius * 4)))
    stem2.path = path2
    stem2.strokeColor = SKColor.black
    stem2.lineWidth = 12
    beamedQuadruplet.addChild(stem2)
    
    return beamedQuadruplet
}

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
