import Foundation

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
