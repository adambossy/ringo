    //
//  StaffNode.swift
//  RingoSpriteKit
//
//  Created by Adam Bossy-Mendoza on 8/17/17.
//  Copyright © 2017 Patreon. All rights reserved.
//

import SpriteKit


class StaffNode: SKShapeNode {

    func renderBars(forSong song: Song, count: Int, start: Int) {

        let notation = song.notation
        let instruments = notation.getInstruments()
        
        for instrument in instruments {
            print("instrument:", instrument)
            let sequence = notation.getNoteSequence(forType: instrument)
            
            let tickStart = start * 16
            let tickEnd = tickStart + (count * 16)
            print("tickStart", tickStart, "tickEnd", tickEnd)
            for tick in sequence.noteRange(from: tickStart, to: tickEnd) {
                print("tick:", tick)
                addQuarterNote(ofType: instrument, atRelativeTick: tick - tickStart)
            }
        }

        print("staffSize:", frame.size)
        print("calculateAccumulatedFrame:", calculateAccumulatedFrame())

        let blankStaff = SKSpriteNode(imageNamed: "BlankStaff")
        blankStaff.xScale = frame.size.width / blankStaff.size.width
        blankStaff.yScale = frame.size.height / blankStaff.size.height
        blankStaff.position = CGPoint(x: blankStaff.size.width / 2, y: -blankStaff.size.height / 2)
        addChild(blankStaff)
    }
    
    func instrumentYPosition(forType type: InstrumentType) -> CGFloat {
        switch type {
        case .HiHat:
            return 0
        case .Snare:
            return 50
        case .Tom1:
            return 100
        case .Tom2:
            return 150
        case .Tom3:
            return 200
        case .Tom4:
            return 250
        case .Kick:
            return 300
        }
    }
    
    func addQuarterNote(ofType type: InstrumentType, atRelativeTick tick: Int) {
        let staffSize = frame.size // staff!.calculateAccumulatedFrame()
        
        let notesOnScreen = 4 * 16 // 4 bars with 16 notes each
        let noteDistance = staffSize.width / CGFloat(notesOnScreen)
        
        let note = SKSpriteNode(imageNamed: "QuarterNoteUpright")
        
        // Crudely shrink
        //        note.size = CGSize(width: note.size.width / 4, height: note.size.height / 4)
        note.xScale = 0.5
        note.yScale = 0.5
        // Position notes on the right edge of the screen to begin with

        let staffOrigin = frame.origin

        let noteX = staffOrigin.x + (note.size.width * 0.5) + (noteDistance * CGFloat(tick))
        let noteY = staffOrigin.y + 300 - instrumentYPosition(forType: type)

//        note.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        note.position = CGPoint(x: noteX, y: noteY)
        note.zPosition = 1
        
        addChild(note)
    }
}
