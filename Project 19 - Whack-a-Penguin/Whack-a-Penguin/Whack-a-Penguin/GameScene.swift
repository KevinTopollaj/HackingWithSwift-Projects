//
//  GameScene.swift
//  Whack-a-Penguin
//
//  Created by Mr.Kevin on 25/07/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
  
  /// Properties
  
  // create an array of slots
  var slots = [WhackSlot]()
  // create a game score label
  var gameScore: SKLabelNode!
  // create a score property with a property observer
  var score = 0 {
    didSet {
      gameScore.text = "Score: \(score)"
    }
  }
  
  var totalGameScore: SKLabelNode!
  // the time it will take for a penguin to show
  var popupTime = 0.85
  // a property that will contain the number of rounds for the game
  var numRounds = 0
  
  override func didMove(to view: SKView) {
    // create the background and add it as a child node
    let background = SKSpriteNode(imageNamed: "whackBackground")
    background.position = CGPoint(x: 512, y: 384)
    background.blendMode = .replace
    background.zPosition = -1
    addChild(background)
    
    // create game score and add it as a child node
    gameScore = SKLabelNode(fontNamed: "Chalkduster")
    gameScore.text = "Score: 0"
    gameScore.position = CGPoint(x: 8, y: 8)
    gameScore.horizontalAlignmentMode = .left
    gameScore.fontSize = 48
    addChild(gameScore)
    
    // will create the slots in the sceene
    for i in 0..<5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410)) }
    for i in 0..<4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320)) }
    for i in 0..<5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230)) }
    for i in 0..<4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140)) }
    
    // Because createEnemy() calls itself, all we have to do is call it once in didMove(to: ) after a brief delay.
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
      self?.createEnemy()
    }
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    // get the first touch on the screen
    guard let touch = touches.first else { return }
    // get the location of the touch in the current sceene
    let location = touch.location(in: self)
    // get an array of all nodes on the taped location
    let tappedNodes = nodes(at: location)
    
    // iterate over each node
    for node in tappedNodes {
      // get an instance of the WhackSlot
      guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
      // check if isVisible is true and isHit is false
      if !whackSlot.isVisible { continue }
      if whackSlot.isHit { continue }
      // call the hit method
      whackSlot.hit()
      
      // check for the node name and check if they should whacked that node or not
      if node.name == "charFriend" {
        score -= 5
        run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
      } else if node.name == "charEnemy"{
        // set the xScale and yScale properties of our character node so the penguin shrinks in the scene, as if they had been hit.
        whackSlot.charNode.xScale = 0.85
        whackSlot.charNode.yScale = 0.85

        score += 1
        
        run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
      }
    }
    
  }
  
  // a method that will create a slot at a specified position add them to the sceene and to the slots array
  func createSlot(at position: CGPoint) {
    let slot = WhackSlot()
    slot.configure(at: position)
    addChild(slot)
    slots.append(slot)
  }
  
  // a method that will be called when the game starts and create a round each time it is called
  func createEnemy() {
    numRounds += 1
    
    if numRounds >= 30 {
      // hide all slots
      for slot in slots {
        slot.hide()
      }
      
      // create a game over node
      let gameOver = SKSpriteNode(imageNamed: "gameOver")
      gameOver.position = CGPoint(x: 512, y: 384)
      gameOver.zPosition = 1
      addChild(gameOver)
      
      gameScore.isHidden = true
      
      totalGameScore = SKLabelNode(fontNamed: "Chalkduster")
      totalGameScore.text = "Total Score: \(score)"
      totalGameScore.position = CGPoint(x: 512, y: 10)
      totalGameScore.horizontalAlignmentMode = .center
      totalGameScore.fontSize = 48
      addChild(totalGameScore)
      
      return
    }
    
    // decrease the popupTime
    popupTime *= 0.991
    // shuffle the slots
    slots.shuffle()
    // take the firs element in the shuffeled slots and show it
    slots[0].show(hideTime: popupTime)
    
    // Generate four random numbers to see if more slots should be shown. Potentially up to five slots could be shown at once.
    if Int.random(in: 0...12) > 4 { slots[1].show(hideTime: popupTime) }
    if Int.random(in: 0...12) > 8 { slots[2].show(hideTime: popupTime) }
    if Int.random(in: 0...12) > 10 { slots[3].show(hideTime: popupTime) }
    if Int.random(in: 0...12) > 11 { slots[4].show(hideTime: popupTime) }
    
    // calculate the delay
    let minDelay = popupTime / 2.0
    let maxDelay = popupTime * 2
    let delay = Double.random(in: minDelay...maxDelay)
    
    // Call itself again after a random delay.
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
      self?.createEnemy()
    }
  }
  
}
