//
//  Note.swift
//  RingoSpriteKit
//
//  Created by Adam Bossy-Mendoza on 8/16/17.
//  Copyright © 2017 Patreon. All rights reserved.
//

import Foundation

class Note {
    var next: Note?
    var tick: Int

    init(_ _tick: Int) {
        tick = _tick
    }
}
