//
//  GameScene.swift
//  Pachinko
//
//  Created by Mr.Kevin on 22/07/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
  
  /// Properties
  
  // declare a score label node
  var scoreLabel: SKLabelNode!
  // create a score property that will update the scoreLabel when score changes
  var score = 0 {
    didSet {
      scoreLabel.text = "Score: \(score)"
    }
  }
  
  // declare a edit label node
  var editLabel: SKLabelNode!
  // a property that holds a boolean that tracks whether we're in editing mode or not.
  var editingMode: Bool = false {
    didSet {
      if editingMode {
        editLabel.text = "Done"
      } else {
        editLabel.text = "Edit"
      }
    }
  }
  
  var ballsLabel: SKLabelNode!
  var balls = 10 {
    didSet {
      ballsLabel.text = "Balls: \(balls)"
    }
  }
  
  
  override func didMove(to view: SKView) {
    // add a background to our game with specific properties
    let background = SKSpriteNode(imageNamed: "background")
    background.position = CGPoint(x: 512, y: 384)
    background.blendMode = .replace
    background.zPosition = -1
    addChild(background)
    
    // initialize the score label node and add properties to it
    scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    scoreLabel.text = "Score: 0"
    scoreLabel.horizontalAlignmentMode = .right
    scoreLabel.position = CGPoint(x: 980, y: 700)
    addChild(scoreLabel)
    
    // initialize the edit label node and add properties to it
    editLabel = SKLabelNode(fontNamed: "Chalkduster")
    editLabel.text = "Edit"
    editLabel.position = CGPoint(x: 80, y: 700)
    addChild(editLabel)
    
    ballsLabel = SKLabelNode(fontNamed: "Chalkduster")
    ballsLabel.text = "Balls: 10"
    ballsLabel.position = CGPoint(x: 512, y: 700)
    addChild(ballsLabel)
    
    // adds a physics body to the whole scene that is a line on each edge, acting like a container for the scene.
    physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    physicsWorld.contactDelegate = self
    
    makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
    makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
    makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
    makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
    
    makeBouncer(at: CGPoint(x: 0, y: 0))
    makeBouncer(at: CGPoint(x: 256, y: 0))
    makeBouncer(at: CGPoint(x: 512, y: 0))
    makeBouncer(at: CGPoint(x: 768, y: 0))
    makeBouncer(at: CGPoint(x: 1024, y: 0))
    
  }
  
  // a method that will create multiple bouncers in the sceene
  func makeBouncer(at position: CGPoint) {
    let bouncer = SKSpriteNode(imageNamed: "bouncer")
    bouncer.position = position
    bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
    bouncer.physicsBody?.isDynamic = false // it will not move when collisions happen
    addChild(bouncer)
  }
  
  // a method that will make slots and make it green for a good slot or red for a bad slot
  func makeSlot(at position: CGPoint, isGood: Bool) {
    var slotBase: SKSpriteNode
    var slotGlow: SKSpriteNode
    
    if isGood {
      slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
      slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
      slotBase.name = "good"
    } else {
      slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
      slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
      slotBase.name = "bad"
    }
    
    slotBase.position = position
    slotGlow.position = position
    
    // Add rectangle physics to our slots.
    slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
    slotBase.physicsBody?.isDynamic = false // dont move it when a ball hits
    
    addChild(slotBase)
    addChild(slotGlow)
    
    // will make the slotGlow spin
    let spin = SKAction.rotate(byAngle: .pi, duration: 10)
    let spinForever = SKAction.repeatForever(spin)
    slotGlow.run(spinForever)
  }
  
  // A method that is called when the user taps on the device screen
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    // check if the user is touching the device
    if let touch = touches.first {
      // find the touch location in the screen
      let location = touch.location(in: self)
      // will give us a list of all the nodes at the point that was tapped, and check whether it contains our edit label.
      let objects = nodes(at: location)
      if objects.contains(editLabel) {
        editingMode.toggle()
      } else {
        // if we are in editing mode we will create a box otherwise drop a ball
        if editingMode {
          let size = CGSize(width: Int.random(in: 16...128), height: 16)
          let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
          box.zRotation = CGFloat.random(in: 0...3)
          box.position = location
          box.name = "box"
          
          box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
          box.physicsBody?.isDynamic = false
          
          addChild(box)
          
        } else {
          if balls > 0 {
            // create a ball obj from the image
            var color = ["ballBlue", "ballCyan", "ballGreen", "ballGrey", "ballPurple", "ballRed", "ballYellow"]
            color.shuffle()
            
            let ball = SKSpriteNode(imageNamed: color.first!)
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
            ball.physicsBody?.restitution = 0.5
            ball.name = "ball"
            // we want to be notified about every collision that a ball has with other objects
            // contactTestBitMask : determines which collisions are reported to us.
            // collisionBitMask : determines what objects a node bounces off
            ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
            // add the ball to the user touch location
            ball.position = CGPoint(x: location.x, y: 670)
            balls -= 1
            // add the ball to the sceene
            addChild(ball)
          }
        }
        
      }
    }
  }
  
  // a method that will be called when a ball collides with something else
  func collisionBetween(ball: SKNode, object: SKNode) {
    if object.name == "good" {
      destroy(ball: ball)
      score += 1
      balls += 1
    } else if object.name == "bad" {
      destroy(ball: ball)
      if score > 0 {
        score -= 1
      } else {
        score = 0
      }
    } else if object.name == "box" {
      object.removeFromParent()
    }
  }
  
  // a method that will be called when we finish with the ball and we want to destroy it
  func destroy(ball: SKNode) {
    // create an efect when a ball gets destroyed
    if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
      fireParticles.position = ball.position
      addChild(fireParticles)
    }
    
    // will remove a node from the node tree
    ball.removeFromParent()
  }
  
  // a method we get from the SKPhysicsContactDelegate to check the contatct and se which one is the ball
  func didBegin(_ contact: SKPhysicsContact) {
    // check if both nodeA and nodeB have a valid node
    guard let nodeA = contact.bodyA.node else { return }
    guard let nodeB = contact.bodyB.node else { return }
    
    if nodeA.name == "ball" {
      collisionBetween(ball: nodeA, object: nodeB)
    } else if nodeB.name == "ball" {
      collisionBetween(ball: nodeB, object: nodeA)
    }
  }
  
}
