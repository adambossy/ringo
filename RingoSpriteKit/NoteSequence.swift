//
//  NoteSequence.swift
//  RingoSpriteKit
//
//  Created by Adam Bossy-Mendoza on 8/16/17.
//  Copyright © 2017 Patreon. All rights reserved.
//

import Foundation


class NoteSequence : CustomStringConvertible {

    var head : Note?
    var tail : Note?
    var tickOffset : Int

    init() {
        head = nil
        tail = nil
        tickOffset = 0
    }

    // Ingestion
    
    func next() -> Note? {
        head = head?.next
        return head
    }

    func getNote(at tick: Int) {
        
    }
    
    // Construction
    
    func addNote(_ tick: Int) {
        let note = Note(tick + tickOffset)
        
        if nil == head {
            head = note
        }

        tail?.next = note

        tail = note
    }

    func closeBar(at tick: Int) {
        tickOffset += tick
    }

    public var description: String {
        
        var s = ""
        var _current = head

        var tick = 0
        while let current = _current {
            
            if current.tick > tick {
                for _ in 0..<current.tick - tick - 1 {
                    s += "-"
                }
            }
            s += "o"

            tick = current.tick

            _current = current.next
        }

        if tickOffset > tick {
            for _ in 0..<tickOffset - tick - 1 {
                s += "-"
            }
        }
        
        return s
    }
}
