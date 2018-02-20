//
//  ViewController.swift
//  RingoCalibrator
//
//  Created by Adam Bossy-Mendoza on 2/19/18.
//  Copyright © 2018 Bossy Software. All rights reserved.
//

import AVFoundation
import Cocoa

var player: AVAudioPlayer?

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        playSong()
    }

    func playSong() {
        if let asset = NSDataAsset(name:NSDataAsset.Name(rawValue: "Rush_TomSawyer")) {
            do {
                player = try AVAudioPlayer(data:asset.data, fileTypeHint:"mp3")
                player?.play()
                
                Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.printTime), userInfo: nil, repeats: true)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    override public func keyDown(with event: NSEvent) {
        print("keycode", event.keyCode)
        print("deviceCurrentTime", player?.deviceCurrentTime as Any)
        switch UInt16(event.keyCode) {
        case Keycode.d:
            print("d")
        case Keycode.f:
            print("f")
        case Keycode.j:
            print("j")
        case Keycode.k:
            print("k")
        default:
            break
        }
    }
}
