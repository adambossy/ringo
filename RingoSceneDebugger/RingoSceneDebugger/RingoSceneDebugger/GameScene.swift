//
//  GameScene.swift
//  RingoSceneDebugger
//
//  Created by Adam Bossy-Mendoza on 8/17/17.
//  Copyright © 2017 Patreon. All rights reserved.
//

import GameplayKit
import SpriteKit

class GameScene: SKScene {

    private var label: SKLabelNode?
    private var spinnyNode: SKShapeNode?

    override func didMove(to _: SKView) {

        // Get label node from scene and store it for use later
        label = childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }

        // Create shape node to use during mouse interaction
        let w = (size.width + size.height) * 0.05
        spinnyNode = SKShapeNode(rectOf: CGSize(width: w, height: w), cornerRadius: w * 0.3)

        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5

            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([
                SKAction.wait(forDuration: 0.5),
                SKAction.fadeOut(withDuration: 0.5),
                SKAction.removeFromParent(),
            ]))
        }
    }

    func touchDown(atPoint pos: CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            addChild(n)
        }
    }

    func touchMoved(toPoint pos: CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            addChild(n)
        }
    }

    func touchUp(atPoint pos: CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            addChild(n)
        }
    }

    override func mouseDown(with event: NSEvent) {
        touchDown(atPoint: event.location(in: self))
    }

    override func mouseDragged(with event: NSEvent) {
        touchMoved(toPoint: event.location(in: self))
    }

    override func mouseUp(with event: NSEvent) {
        touchUp(atPoint: event.location(in: self))
    }

    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 0x31:
            if let label = self.label {
                label.run(SKAction(named: "Pulse")!, withKey: "fadeInOut")
            }
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }

    override func update(_: TimeInterval) {
        // Called before each frame is rendered
    }
}
