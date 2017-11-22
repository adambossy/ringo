//
//  SongNotationReader.swift
//  RingoSpriteKit
//
//  Created by Adam Bossy-Mendoza on 8/16/17.
//  Copyright © 2017 Patreon. All rights reserved.
//

import AppKit
import Foundation


let nonNote: Character = "-"

class SongReader {

    func readFile(_ name: String) -> String? {
        if let asset = NSDataAsset(name: name) {
            return String(data: asset.data, encoding: String.Encoding.utf8)
        }
        return nil
    }

    func readNotation(instrumentTypes: Array<String>, songData: Array<String>) -> SongNotation {
        let notation = SongNotation()

        var tick = 0
        var tickBookmark = 0
        var instrumentIndex = 0

        let startIndex = 4 // This is based on the format described in read()
        for index in startIndex...songData.count - 1 {

            let eightBars : String = songData[index] // Read eight bars (or less) per line for easy editing
            
            if eightBars.isEmpty { // Blank lines delimit eight bar chunks
                tickBookmark = tick
                instrumentIndex = 0
            } else {
            
                if let instrumentType = InstrumentType(rawValue: instrumentTypes[instrumentIndex]) {

                    for note in eightBars.characters {

                        if (note != nonNote) {
                            notation.addNote(type: instrumentType, tick: tick)
                        }

                        tick += 1
                    }
                    
                    notation.closeBar(at: tick, forType: instrumentType)

                    instrumentIndex += 1
                    tick = tickBookmark

                    print(String(describing: notation.getNoteSequence(forType: instrumentType)))
                }
            }
        }

        return notation
    }
    
    func read(_ name: String) -> Song? {
        /**
         Format:
         ---
         Rush
         Tom Sawyer
         88
         hihat snare kick
         
         x-x-x-x-
         o---o---
         --o---o-
         */

        if let file = readFile(name) {
            let songData : [String] = file.components(separatedBy: .newlines)

            let name = songData[0]
            let artist = songData[1]
            let bpm = Int(songData[2])!
            
            let instrumentData = songData[3] as String
            let instrumentTypes = instrumentData.components(separatedBy: .whitespaces)

            let notation = readNotation(instrumentTypes: instrumentTypes, songData: songData)

            return Song(name: name, artist: artist, bpm: bpm, notation: notation)
        }

        return nil
    }
}
