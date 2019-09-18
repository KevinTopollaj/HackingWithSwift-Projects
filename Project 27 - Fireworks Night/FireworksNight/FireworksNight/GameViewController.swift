//
//  GameViewController.swift
//  FireworksNight
//
//  Created by Mr.Kevin on 04/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
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
  
  /// A system method that detects when we shake the device
  override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    // get the SpriteKit view
    guard let skView = view as? SKView else { return }
    // get the game scene from the SpriteKit view
    guard let gameScene = skView.scene as? GameScene else { return }
    // explode all fireworks
    gameScene.explodeFireworks()
  }
}
