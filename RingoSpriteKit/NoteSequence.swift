    //
//  ticksequence.swift
//  RingoSpriteKit
//
//  Created by Adam Bossy-Mendoza on 8/16/17.
//  Copyright © 2017 Patreon. All rights reserved.
//

import Foundation


class NoteSequence : CustomStringConvertible {

    public var ticks : [Int]

    var tickOffset : Int

    init() {
        ticks = [Int]()
        tickOffset = 0
    }

    // Ingestion
    
    func hasNote(at tick: Int) -> Bool {
        if let noteIndex = binarySearch(ticks, key: tick, range: 0 ..< ticks.count) {
            if tick == ticks[noteIndex] {
                return true
            }
        }
        return false
    }
    
    func noteRange(from: Int, to: Int) -> [Int] {
        if let noteFrom : Int = binarySearch(ticks, key: from, range: 0 ..< ticks.count),
           let noteTo : Int = binarySearch(ticks, key: to, range: 0 ..< ticks.count) {
            return Array(ticks[noteFrom ..< noteTo])
        }
        return [Int]()
    }
    
    // Construction
    
    func addNote(_ tick: Int) {
        ticks.append(tick + tickOffset)
    }

    func closeBar(at tick: Int) {
        tickOffset += tick
    }

    public var description: String {
        
        var s = ""
        var tick = 0

        for currentTick in ticks {

            if currentTick > tick {
                for _ in 0 ..< currentTick - tick - 1 {
                    s += "-"
                }
            }
            s += "o"
            
            tick = currentTick
        }

        if tickOffset > tick {
            for _ in 0 ..< tickOffset - tick - 1 {
                s += "-"
            }
        }
        
        return s
    }
}
