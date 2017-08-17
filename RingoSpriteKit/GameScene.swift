//
//  GameScene.swift
//  RingoSpriteKit
//
//  Created by Adam Bossy-Mendoza on 8/16/17.
//  Copyright © 2017 Patreon. All rights reserved.
//

import SpriteKit
import GameplayKit

enum InstrumentYPosition: CGFloat {
    case HiHat = 70
    case Snare = 60
    case Tom1 = 50
    case Tom2 = 40
    case Tom3 = 30
    case Tom4 = 20
    case Kick = 10
}

class GameScene: SKScene {
    
    private var tick = 0
    private var song : Song?

    private var blankStaff = SKSpriteNode(imageNamed: "BlankStaff")

    override init(size: CGSize) {
        super.init(size:size)
        song = nil
    }
    
    override required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override func didMove(to view: SKView) {

        // Render blank staff as background
//        self.backgroundColor = SKColor.clear
//        blankStaff.position = CGPoint.zero
//        addChild(blankStaff)

        print("Loading...")

        if let song = SongReader().read("SporkTestSong") {
            
            run(SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.run(ingestTick),
                    // 1 sec = quarter notes at 60bpm
                    // 60/bpm/4 = sixteenth note ticks at 60 bpm
                    SKAction.wait(forDuration: TimeInterval(60/song.bpm/4))
    //                SKAction.run({ self.addQuarterNote(ofType: InstrumentYPosition.Snare) }),
    //                SKAction.wait(forDuration: TimeInterval(60/bpm)) // 1 sec = quarter notes at 60bpm
                ])
            ))
        }
    }

    func ingestTick() {
        // NOTE Unwrapping weirdness. Fix!
        if let _song = song {
            let notation = _song.notation
            let instruments = notation.getInstruments()

            for instrument in instruments {
                let sequence = notation.getNoteSequence(forType: instrument)
                sequence
            }
        }
        
        tick += 1
    }
    
    func addQuarterNote(ofType type: InstrumentYPosition) {

        let noteY : CGFloat = type.rawValue
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
