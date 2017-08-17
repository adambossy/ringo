//
//  SongNotationReader.swift
//  RingoSpriteKit
//
//  Created by Adam Bossy-Mendoza on 8/16/17.
//  Copyright © 2017 Patreon. All rights reserved.
//

import Foundation
import AppKit


class SongNotationReader {

    func read(_ song: String) -> String? {
        if let asset = NSDataAsset(name: song) {
            return String(data: asset.data, encoding: String.Encoding.utf8)
        }
        return nil
    }
}
