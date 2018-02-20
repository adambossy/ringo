//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit
import AVFoundation

let bpm = 87.7
let startDelay = 0.411556658699514

var beepPlayer: AVAudioPlayer?
var songPlayer: AVAudioPlayer?
var songStarted = false

class GameScene: SKScene {
    
    private var label : SKLabelNode!
    private var spinnyNode : SKShapeNode!
    private var keyStrokes = [Double]()

    @objc
    public func createNode(_ timer: Timer) {
        let userInfo = timer.userInfo as! (pos: CGPoint, color: SKColor)
        
        guard let n = spinnyNode.copy() as? SKShapeNode else { return }
        
        n.position = userInfo.pos
        n.fillColor = userInfo.color
        addChild(n)
    }

    override func didMove(to view: SKView) {
        // Get label node from scene and store it for use later
        label = childNode(withName: "//helloLabel") as? SKLabelNode
        label.alpha = 0.0
        let fadeInOut = SKAction.sequence([.fadeIn(withDuration: 2.0),
                                           .fadeOut(withDuration: 2.0)])
        label.run(.repeatForever(fadeInOut))
        
        // Set up 1 sec timer
//        let args = (CGPoint(x: 0, y: 0), SKColor.blue)
//        Timer.scheduledTimer(
//            timeInterval: 60.0 / bpm,
//            target: self,
//            selector: #selector(GameScene.createNode(_:)),
//            userInfo: args,
//            repeats: true)

        // Start metronome with the delay that we calibrated for Tom Sawyer
        Timer.scheduledTimer(
            timeInterval: startDelay,
            target: self,
            selector: #selector(GameScene.startMetronome),
            userInfo: nil,
            repeats: false)
        playSong()
        
        // Create shape node to use during mouse interaction
        let w = (size.width + size.height) * 0.05
        
        spinnyNode = SKShapeNode(circleOfRadius: w / 4)
        spinnyNode.lineWidth = 0
        
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let scale = SKAction.scale(by: 5.0, duration: 0.5)
        let fadeAndScale = SKAction.group([fadeOut, scale])
        let actions = [fadeAndScale, .removeFromParent()]
        let fadeScaleAndRemove = SKAction.sequence(actions)
        spinnyNode.run(fadeScaleAndRemove)
        
//        setupBeep()
    }
    
    @objc
    public func startMetronome() {
        setupBeep()
        Timer.scheduledTimer(
            timeInterval: 60.0 / bpm,
            target: self,
            selector: #selector(GameScene.playBeep),
            userInfo: nil,
            repeats: true)
    }
    
    @objc
    func playBeep() {
        beepPlayer?.play()
    }

    func touchDown(atPoint pos: CGPoint) {
//        let args = (pos, SKColor.red)
//        createNode(args)
    }
    
    override func mouseDown(with event: NSEvent) {
        touchDown(atPoint: event.location(in: self))
    }
    
    override func keyDown(with event: NSEvent) {
        print(event.keyCode)

        if !songStarted {
            songStarted = true
            playSong()
        } else {
            if let currentTime = songPlayer?.currentTime {
                keyStrokes.append(currentTime)
            }
            print(keyStrokes.last as Any)
            findDownbeats(fromTime: keyStrokes.last as! Double)
        }
    }
    
    func findDownbeats(fromTime time: TimeInterval) {
        let bpm_ = getBPM()
        let timeInterval = time
        let beatDuration = 60.0 / bpm_
        let startDelay = timeInterval.truncatingRemainder(dividingBy: beatDuration)
        print("startDelay", startDelay)
    }

    func getBPM() -> Double {
        if keyStrokes.count <= 1 {
            return 0.0
        }
        var deltas = [Double]()
        for i in 1..<keyStrokes.count - 1 {
            let delta = keyStrokes[i] - keyStrokes[i - 1]
            deltas.append(delta)
//            print(delta)
        }
        let average = deltas.reduce(0, +) / Double(deltas.count)
        print(average) // 60 / bpm = average
        print("BPM!!!", 60.0 / average)
        return 60.0 / average
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }

    func setupBeep() {
        let beepURL = URL(fileURLWithPath: Bundle.main.path(forResource: "beep-07", ofType: "mp3")!)
        do {
            beepPlayer = try AVAudioPlayer(contentsOf: beepURL)
            beepPlayer?.prepareToPlay()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func playSong() {
        let beepURL = URL(fileURLWithPath: Bundle.main.path(forResource: "Rush_TomSawyer", ofType: "mp3")!)
        do {
            songPlayer = try AVAudioPlayer(contentsOf: beepURL)
            songPlayer?.play()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}

// Load the SKScene from 'GameScene.sks'
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
if let scene = GameScene(fileNamed: "GameScene") {
    // Set the scale mode to scale to fit the window
    scene.scaleMode = .aspectFill
    
    // Present the scene
    sceneView.presentScene(scene)
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView

