//: A Cocoa based Playground to present user interface

import AppKit
import PlaygroundSupport

let nibFile = NSNib.Name(rawValue:"MyView")
var topLevelObjects : NSArray?

Bundle.main.loadNibNamed(nibFile, owner:nil, topLevelObjects: &topLevelObjects)
let views = (topLevelObjects as! Array<Any>).filter { $0 is NSView }
let mainView = views[0] as! NSView

// Present the view in Playground
PlaygroundPage.current.liveView = mainView

let circleRect = CGRect(x: mainView.frame.size.width / 2, y: mainView.frame.size.height / 2, width: 100, height: 100)
let circle = NSBezierPath(ovalIn: circleRect)
circle.strokeColor = NSColor.black
circle.fillColor = NSColor.black
circle.close()
mainView.addSubview(circle)
