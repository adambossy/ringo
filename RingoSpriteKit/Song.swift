//
//  Song.swift
//  RingoSpriteKit
//
//  Created by Adam Bossy-Mendoza on 8/16/17.
//  Copyright © 2017 Patreon. All rights reserved.
//

import Foundation

class Song {
    public var name : String
    public var artist : String
    public var bpm : Int
    public var notation : SongNotation
    
    init(name _name: String, artist _artist: String, bpm _bpm: Int, notation _notation: SongNotation) {
        name = _name
        artist = _artist
        bpm = _bpm
        notation = _notation
    }
}
