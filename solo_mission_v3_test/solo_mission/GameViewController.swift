//
//  GameViewController.swift
//  solo_mission
//
//  Created by 張世維 on 2022/1/22.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation
class GameViewController: UIViewController {

    var backingAudio = AVAudioPlayer()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filePath = Bundle.main.path(forResource: "bensound-epic", ofType: "mp3")
        let audioNSURL = URL(fileURLWithPath: filePath!)
        
        do{ backingAudio = try AVAudioPlayer(contentsOf: audioNSURL) }
        catch{ return print("Cannot Find The Audio") }
        backingAudio.numberOfLoops = -1
        backingAudio.play()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        let scene = MainMenuScene(size: CGSize(width: 1536, height: 2048))
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            skView.ignoresSiblingOrder = true
            
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
              
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
