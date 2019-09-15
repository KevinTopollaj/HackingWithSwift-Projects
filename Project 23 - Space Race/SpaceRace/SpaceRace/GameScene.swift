//
//  GameScene.swift
//  SpaceRace
//
//  Created by Mr.Kevin on 28/07/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
  
  /// Properties
  
  var starField: SKEmitterNode!
  var player: SKSpriteNode!
  var scoreLabel: SKLabelNode!
  var gameOver: SKSpriteNode!
  
  var score = 0 {
    didSet {
      scoreLabel.text = "Score: \(score)"
    }
  }
  
  // array of enemies obj
  let possibleEnemies = ["ball", "hammer", "tv"]
  // is a simple boolean that will be set to true when we should stop increasing the player's score
  var isGameOver = false
  // timer is responsible for running code after a period of time has passed, either once or repeatedly
  var gameTimer: Timer?
  
  var seconds = 0.6
  var rounds = 0
  
  override func didMove(to view: SKView) {
    
    backgroundColor = .black
    // create the starField
    starField = SKEmitterNode(fileNamed: "starfield")!
    starField.position = CGPoint(x: 1024, y: 384)
    starField.advanceSimulationTime(10) // advance it 10 sec
    starField.zPosition = -1
    addChild(starField)
    
    // create the player
    player = SKSpriteNode(imageNamed: "player")
    player.position = CGPoint(x: 100, y: 384)
    // create a physic body of our player image
    player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
    // set the contact test bit mask for our player to be 1. This will match the category bit mask we will set for space objects later on, and it means that we'll be notified when the player collides with other objects.
    player.physicsBody?.contactTestBitMask = 1
    addChild(player)
    
    // create the score label
    scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    scoreLabel.position = CGPoint(x: 16, y: 16)
    scoreLabel.horizontalAlignmentMode = .left
    addChild(scoreLabel)
    
    score = 0
    
    // set the gravity of our physics world to be empty,
    physicsWorld.gravity = .zero
    physicsWorld.contactDelegate = self
    
    // initialize a Timer
    gameTimer = Timer.scheduledTimer(timeInterval: seconds, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    
  }
  
  @objc func createEnemy() {
    // get a random element from the possibleEnemies array
    guard let enemy = possibleEnemies.randomElement() else { return }
    // create the enemy sprite node
    let sprite = SKSpriteNode(imageNamed: enemy)
    // position it randomly in the vertical axis
    sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
    // add it to the scene
    addChild(sprite)
    // create the physics body of the sprite using per-pixel collision
    sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
    // will tell it to colide with the player
    sprite.physicsBody?.categoryBitMask = 1
    // make it move to the left at a fast speed
    sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
    // give the object a constant spin
    sprite.physicsBody?.angularVelocity = 5
    // means its movement and rotation will never slow down over time.
    sprite.physicsBody?.linearDamping = 0
    sprite.physicsBody?.angularDamping = 0
    
    if isGameOver {
      sprite.removeFromParent()
    } else {
      rounds += 1
      
      if rounds == 20 && seconds > 0.2 {
        rounds = 0
        seconds -= 0.1
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(timeInterval: seconds, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
      }
    }
  }
  
  /// Will update the game overtime
  override func update(_ currentTime: TimeInterval) {
    // get each node in the array of all nodes
    for node in children {
      // if the node has passed the x position of -300
      if node.position.x < -300 {
        // remove it from the parent
        node.removeFromParent()
      }
    }

    // increment the score if the game is not over
    if !isGameOver {
      score += 1
    }
  }
  
  /// Will handel the movement of the player
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    // get the first touch on the screan
    guard let touch = touches.first else { return }
    // get the location of the touch in the scene
    var location = touch.location(in: self)
    
    if location.y < 100 {
      location.y = 100
    } else if location.y > 668 {
      location.y = 668
    }
    
    // asign the player position to the the location
    player.position = location
  }
  
  /// Will handle the collision between two bodies and end the game
  func didBegin(_ contact: SKPhysicsContact) {
    // create the explosion emitter
    let explosion = SKEmitterNode(fileNamed: "explosion")!
    // position it where the player was positioned
    explosion.position = player.position
    // add the emiter to the scene
    addChild(explosion)
    
    // remove the player
    player.removeFromParent()
    gameTimer?.invalidate()
    // update the isGameOver to end the game and stop updating the scores
    isGameOver = true
    
    gameOver = SKSpriteNode(imageNamed: "gameOver")
    gameOver.position = CGPoint(x: 512, y: 384)
    gameOver.zPosition = 1
    addChild(gameOver)
    
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    // get the first touch on the screan
    guard let touch = touches.first else { return }
    // get the location of the touch in the scene
    var location = touch.location(in: self)
    
    if location.x < 50 {
      location.x = 50
    } else if location.x > 200 {
      location.x = 200
    }
    
    // asign the player position to the the location
    player.position = location
  }
  
}
