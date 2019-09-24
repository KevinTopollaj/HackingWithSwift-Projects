//
//  GameScene.swift
//  MarbleMaze
//
//  Created by Mr.Kevin on 15/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import CoreMotion
import SpriteKit

// create an enum that will define a number for a type of object
enum CollisionTypes: UInt32 {
  case player = 1
  case wall = 2
  case star = 4
  case vortex = 8
  case finish = 16
}

class GameScene: SKScene {
  
  // property that represents the player
  var player: SKSpriteNode!
  
  // property that will give us the last touch position
  var lastTouchPosition: CGPoint?
  
  // property that declares a motion manager that will handle the accelerometer data.
  var motionManager: CMMotionManager!
  
  // properties for the score
  var scoreLabel: SKLabelNode!
  
  var score = 0 {
    didSet {
      scoreLabel.text = "Score: \(score)"
    }
  }
  
  // property that will notify when the game is over
  var isGameOver = false
  
  override func didMove(to view: SKView) {

    // will create a background sprite node
    let background = SKSpriteNode(imageNamed: "background.jpg")
    background.position = CGPoint(x: 512, y: 384)
    background.blendMode = .replace
    background.zPosition = -1
    addChild(background)
    
    scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    scoreLabel.text = "Score: 0"
    scoreLabel.horizontalAlignmentMode = .left
    scoreLabel.position = CGPoint(x: 16, y: 16)
    scoreLabel.zPosition = 2
    addChild(scoreLabel)
    
    // remove the default gravity
    physicsWorld.gravity = .zero
    physicsWorld.contactDelegate = self
    
    loadLevel(name: "level1")
    createPlayer()
    
    // initialize the Motion Manager obj and start collecting accelerometer information we can read later.
    motionManager = CMMotionManager()
    motionManager.startAccelerometerUpdates()
  }
  
  // A method that is responsible for loading a level file from disk and creating SpriteKit nodes onscreen.
  func loadLevel(name: String) {
    // get the url of the file level.txt location
    guard let levelURL = Bundle.main.url(forResource: name, withExtension: "txt") else { fatalError("Could not find level1.txt in the app bundle") }
    // get the level.txt content
    guard let levelString = try? String(contentsOf: levelURL) else { fatalError("Could not load level1.txt from the app bundle") }
    // create an array from the content of the level1.txt
    let lines = levelString.components(separatedBy: "\n")
    
    // iterate over each element of the array and its index
    for (row, line) in lines.reversed().enumerated() {
      for (column, letter) in line.enumerated() {
        let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
        
        if letter == "x" {
          // load wall sprite node
          let node = SKSpriteNode(imageNamed: "block")
          node.position = position
          
          node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
          node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
          node.physicsBody?.isDynamic = false
          addChild(node)
        } else if letter == "v" {
          // load vortex sprite node
          let node = SKSpriteNode(imageNamed: "vortex")
          node.name = "vortex"
          node.position = position
          node.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat.pi, duration: 1)))
          node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
          node.physicsBody?.isDynamic = false
          // a number that will identify the vortex
          node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
          // get notified when a collision hapens whith the player sprite node
          node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
          // no bounce when it collides with other objects
          node.physicsBody?.collisionBitMask = 0
          addChild(node)
        } else if letter == "s" {
          // load star sprite node
          let node = SKSpriteNode(imageNamed: "star")
          node.name = "star"
          node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
          node.physicsBody?.isDynamic = false
          
          node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
          node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
          node.physicsBody?.collisionBitMask = 0
          node.position = position
          addChild(node)
        } else if letter == "f" {
          // load finish sprite node
          let node = SKSpriteNode(imageNamed: "finish")
          node.name = "finish"
          node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
          node.physicsBody?.isDynamic = false
          
          node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
          node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
          node.physicsBody?.collisionBitMask = 0
          node.position = position
          addChild(node)
        } else if letter == " " {
          // this is an empty space – do nothing!
        } else {
          fatalError("Unknown level letter: \(letter)")
        }
      }
    }
  }
  
  // A method that will create the player sprite node
  func createPlayer() {
    player = SKSpriteNode(imageNamed: "player")
    player.position = CGPoint(x: 96, y: 672)
    player.zPosition = 1
    player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
    player.physicsBody?.allowsRotation = false
    player.physicsBody?.linearDamping = 0.5
    
    player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
    player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue |
      CollisionTypes.finish.rawValue
    player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
    addChild(player)
  }
  
  /// Method that will handel the touches on the screen
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    lastTouchPosition = location
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    lastTouchPosition = location
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    lastTouchPosition = nil
  }
  
  // needs to unwrap our optional property, calculate the difference between the current touch and the player's position, then use that to change the gravity value of the physics world.
  override func update(_ currentTime: TimeInterval) {
    // run the rest of the code only if the isGameOver is false
    guard isGameOver == false else { return }
    
    // will check if we are runnig the app in the simulator and run this code else we are on a real device and it will run the other code after the #else
    #if targetEnvironment(simulator)
    if let currentTouch = lastTouchPosition {
      let diff = CGPoint(x: currentTouch.x - player.position.x,
                         y: currentTouch.y - player.position.y)
      physicsWorld.gravity = CGVector(dx: diff.x / 100, dy:
        diff.y / 100)
    }
    #else
    // The code to read from the accelerometer and apply its tilt data to the world gravity
    if let accelerometerData = motionManager.accelerometerData {
      physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
    }
    #endif
  }
}

/// Extension thet will contain the collision between the player and other nodes
extension GameScene: SKPhysicsContactDelegate {
  
  func didBegin(_ contact: SKPhysicsContact) {
    guard let nodeA = contact.bodyA.node else { return }
    guard let nodeB = contact.bodyB.node else { return }
    
    if nodeA == player {
      playerCollided(with: nodeB)
    } else if nodeB == player {
      playerCollided(with: nodeA)
    }
  }
  
  func playerCollided(with node: SKNode) {
    if node.name == "vortex" {
      // We need to stop the ball from being a dynamic physics body so that it stops moving once it's sucked in.
      player.physicsBody?.isDynamic = false
      isGameOver = true
      score -= 1
      // We need to move the ball over the vortex, to simulate it being sucked in. It will also be scaled down at the same time.
      let move = SKAction.move(to: node.position, duration: 0.25)
      let scale = SKAction.scale(to: 0.0001, duration: 0.25)
      let remove = SKAction.removeFromParent()
      let sequence = SKAction.sequence([move, scale, remove])
      
      player.run(sequence) { [weak self] in
        self?.createPlayer()
        self?.isGameOver = false
      }
    } else if node.name == "star" {
      node.removeFromParent()
      score += 1
    } else if node.name == "finish" {
      // next level
    }
  }
  
}
