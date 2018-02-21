//
//  ViewController.swift
//  Ringo
//
//  Created by Adam Bossy-Mendoza on 2/19/18.
//  Copyright © 2018 Bossy Software. All rights reserved.
//

import Cocoa
import SpriteKit

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let sceneWidth: CGFloat = self.view.frame.width
        let sceneHeight: CGFloat = self.view.frame.height
        let scene = SheetMusicScene(song: Rush_TomSawyer, size: CGSize(width: sceneWidth, height: sceneHeight))
        
        // Playground sturf
        let sceneView = SKView(frame: CGRect(x: 0, y: 0, width: sceneWidth, height: sceneHeight))
        sceneView.showsFPS = true
        sceneView.presentScene(scene)
        self.view = sceneView
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}
