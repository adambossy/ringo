//
//  SongNotation.swift
//  RingoSpriteKit
//
//  Created by Adam Bossy-Mendoza on 8/16/17.
//  Copyright © 2017 Patreon. All rights reserved.
//

import Foundation

enum InstrumentType: String {
    case HiHat = "hihat"
    case Snare = "snare"
    case Kick = "kick"
    case Tom1 = "tom1"
    case Tom2 = "tom2"
    case Tom3 = "tom3"
    case Tom4 = "tom4"
}

class SongNotation {

    var noteSequenceByInstrument: Dictionary<InstrumentType, NoteSequence>

    init() {
        noteSequenceByInstrument = [InstrumentType: NoteSequence]()
    }

    func getInstruments() -> [InstrumentType] {
        return Array(noteSequenceByInstrument.keys)
    }

    func addInstrument(_ type: InstrumentType) -> NoteSequence {
        noteSequenceByInstrument[type] = NoteSequence()
        return noteSequenceByInstrument[type]!
    }

    func getNoteSequence(forType type: InstrumentType) -> NoteSequence {
        var sequence = noteSequenceByInstrument[type]

        if sequence == nil {
            sequence = addInstrument(type)
        }

        return sequence!
    }

    func addNote(type: InstrumentType, tick: Int) {
        getNoteSequence(forType: type).addNote(tick)
    }

    func closeBar(at tick: Int, forType type: InstrumentType) {
        getNoteSequence(forType: type).closeBar(at: tick)
    }
}
