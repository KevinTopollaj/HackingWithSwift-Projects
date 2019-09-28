//
//  GameViewController.swift
//  ExplodingMonkeys
//
//  Created by Mr.Kevin on 20/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
  
  // create an instance of the GameScene
  var currentGame: GameScene!
  
  /// Outlets
  @IBOutlet var angleSlider: UISlider!
  @IBOutlet var angleLabel: UILabel!
  @IBOutlet var velocitySlider: UISlider!
  @IBOutlet var velocityLabel: UILabel!
  @IBOutlet var launchButton: UIButton!
  @IBOutlet var playerNumber: UILabel!
  
  /// Actions
  
  @IBAction func angleChanged(_ sender: UISlider) {
    // update the correct label with the slider's current value.
    angleLabel.text = "Angle: \(Int(angleSlider.value))°"
  }
  
  @IBAction func velocityChanged(_ sender: UISlider) {
    // update the correct label with the slider's current value.
    velocityLabel.text = "Velocity: \(Int(velocitySlider.value))"
  }
  
  @IBAction func launch(_ sender: Any) {
    angleSlider.isHidden = true
    angleLabel.isHidden = true
    velocitySlider.isHidden = true
    velocityLabel.isHidden = true
    launchButton.isHidden = true
    currentGame.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
  }
  
  func activatePlayer(number: Int) {
    if number == 1 {
      playerNumber.text = "<<< PLAYER ONE"
    } else {
      playerNumber.text = "PLAYER TWO >>>"
    }
    angleSlider.isHidden = false
    angleLabel.isHidden = false
    velocitySlider.isHidden = false
    velocityLabel.isHidden = false
    launchButton.isHidden = false
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    angleChanged(angleSlider)
    velocityChanged(velocitySlider)
    
    if let view = self.view as! SKView? {
      // Load the SKScene from 'GameScene.sks'
      if let scene = SKScene(fileNamed: "GameScene") {
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        // Present the scene
        view.presentScene(scene)
        
        // sets the property to the initial game scene so that we can start using it
        currentGame = scene as? GameScene
        // makes sure that the scene knows about the view controller too.
        currentGame.viewController = self
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
}
