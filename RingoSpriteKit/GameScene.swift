//
//  GameScene.swift
//  RingoSpriteKit
//
//  Created by Adam Bossy-Mendoza on 8/16/17.
//  Copyright © 2017 Patreon. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var bpm = 60

    private var blankStaff = SKSpriteNode(imageNamed: "BlankStaff")

    override func didMove(to view: SKView) {

        // Render blank staff as background
//        self.backgroundColor = SKColor.clear
//        blankStaff.position = CGPoint.zero
//        addChild(blankStaff)

        print("Loading...")
        print(SongReader().read("SporkTestSong"))
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addQuarterNote),
                SKAction.wait(forDuration: TimeInterval(60/bpm)) // 1 sec = quarter notes at 60bpm
            ])
        ))
    }

    
    func addQuarterNote() {

        let noteY = CGFloat(97)
        let noteDistanceX = CGFloat(200) // Desired distance between quarter notes

        let note = SKSpriteNode(imageNamed: "QuarterNoteUpright")

        // Crudely cut in quarter
        note.size = CGSize(width: note.size.width / 2, height: note.size.height / 2)
        // Position notes on the right edge of the screen to begin with
        note.position = CGPoint(x: size.width - note.size.width, y: noteY)

        addChild(note)

        let moveNoteLeft = SKAction.move(to: CGPoint(x: -size.width / 2, y: noteY), duration: TimeInterval(size.width / noteDistanceX))
        // Garbage collect notes when they move off-screen
        let moveNoteLeftDone = SKAction.removeFromParent()
        note.run(SKAction.sequence([moveNoteLeft, moveNoteLeftDone]))
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
