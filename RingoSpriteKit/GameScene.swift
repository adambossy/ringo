//
//  GameScene.swift
//  RingoSpriteKit
//
//  Created by Adam Bossy-Mendoza on 8/16/17.
//  Copyright © 2017 Patreon. All rights reserved.
//

import SpriteKit
import GameplayKit

/*
enum InstrumentYPosition: CGFloat {
    case HiHat = 70
    case Snare = 60
    case Tom1 = 50
    case Tom2 = 40
    case Tom3 = 30
    case Tom4 = 20
    case Kick = 10
}
*/

class GameScene: SKScene {
    
    private var tick = 0

    private var staff : SKShapeNode?
//    private var blankStaff = SKSpriteNode(imageNamed: "BlankStaff")

    override func didMove(to view: SKView) {

        // Render blank staff as background
//        self.backgroundColor = SKColor.clear
//        blankStaff.position = CGPoint.zero
//        addChild(blankStaff)

        print("Loading...")

        // NOTE Unwrapping annoyances. Fix!
//        let staffSize = CGSize(width: size.width * 0.8, height: size.height * 0.8)
//        staff = SKShapeNode(rectOf: staffSize)
//        staff?.fillColor = SKColor.blue
//        staff?.position = CGPoint.zero
//        addChild(staff!)

        anchorPoint = CGPoint(x: 0, y: 1)
        self.backgroundColor = SKColor.lightGray

        if let song = SongReader().read("RushTomSawyer") {

            let staffWidth = size.width * 0.8
            let centerStaffAtX = (size.width - staffWidth) / 2
            let staffHeight = size.width * (3.0 / 8.0) * 0.8
            let staffNode = StaffNode(rect: CGRect(x: centerStaffAtX, y: -staffHeight - 50, width: staffWidth, height: staffHeight))

            staffNode.fillColor = SKColor.white
            staffNode.renderBars(forSong: song, count: 4, start: 0)
            addChild(staffNode)
        }
    }

    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
