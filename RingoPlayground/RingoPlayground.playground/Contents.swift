import PlaygroundSupport
import SpriteKit

let sceneWidth : CGFloat = 400
let sceneHeight : CGFloat = 300

let staffHeight : CGFloat = 100

let numBars : Int = 1
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
let staff = StaffNode(at: CGPoint(x: 0, y: 0))
scene.addChild(staff)


var xPositions : [CGFloat] = [CGFloat]()
var xPos = staffXPadding + sixteenthNoteDistance / 2
for _ in 0 ..< 16 {
    xPositions.append(xPos)
    xPos += sixteenthNoteDistance
}

// 1 2 3 4
// 1e 2e 3e 4e
// 1& 2& 3& 4&
// 1a 2a 3a 4a

var notes : [Note]
var beamedNotes : BeamedNotesNode?

notes = [
    Note(pitch: SnarePitch, value: .Eighth),
    Note(pitch: KickPitch, value: .Eighth),
]

beamedNotes = BeamedNotesNode(withTicks: notes)
staff.addNotes(beamedNotes!, atTick: 0, atPitch: 0)

notes = [
    Note(pitch: SnarePitch, value: .Eighth),
    Note(pitch: KickPitch, value: .Sixteenth),
    Note(pitch: KickPitch, value: .Sixteenth),
]

beamedNotes = BeamedNotesNode(withTicks: notes)
staff.addNotes(beamedNotes!, atTick: 4, atPitch: 0)



//beamedNotes = BeamedNotesNode(withTicks: [true, true, false, false])
//staff.addNotes(beamedNotes, atTick: 4, atPitch: HiHatY)
//
//beamedNotes = BeamedNotesNode(withTicks: [true, false, true, true])
//staff.addNotes(beamedNotes, atTick: 8, atPitch: HiHatY)
//
//beamedNotes = BeamedNotesNode(withTicks: [true, true, true, false])
//staff.addNotes(beamedNotes, atTick: 12, atPitch: HiHatY)

