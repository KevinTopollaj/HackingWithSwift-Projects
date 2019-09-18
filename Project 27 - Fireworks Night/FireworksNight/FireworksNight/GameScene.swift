//
//  GameScene.swift
//  FireworksNight
//
//  Created by Mr.Kevin on 04/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
  
  /// Properties
  var gameTimer: Timer?
  var fireworks = [SKNode]()
  
  var scoreLabel: SKLabelNode!
  var roundLabel: SKLabelNode!
  var newGameLabel: SKLabelNode!
  var gameOver: SKSpriteNode!
  
  // properties that are used to define where we launch fireworks from
  let leftEdge = -22
  let bottomEdge = -22
  let rightEdge = 1024 + 22
  
  var totalRounds = 5
  
  var score = 0 {
    didSet {
      // score code
      scoreLabel.text = "Score: \(score)"
    }
  }
  
  var round = 0 {
    didSet {
      roundLabel.text = "Round: \(round)"
    }
  }
  
  override func didMove(to view: SKView) {
    // create and add the background to the sceene
    let background = SKSpriteNode(imageNamed: "background")
    background.position = CGPoint(x: 512, y: 384)
    background.blendMode = .replace
    background.zPosition = -1
    addChild(background)
    
    scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    scoreLabel.position = CGPoint(x: 16, y: 16)
    scoreLabel.fontSize = 24
    scoreLabel.text = "Score: 0"
    scoreLabel.horizontalAlignmentMode = .left
    addChild(scoreLabel)
    
    roundLabel = SKLabelNode(fontNamed: "Chalkduster")
    roundLabel.position = CGPoint(x: 1000, y: 720)
    roundLabel.fontSize = 24
    roundLabel.text = "Round: \(round)"
    roundLabel.horizontalAlignmentMode = .right
    addChild(roundLabel)
    
    newGameLabel = SKLabelNode(fontNamed: "Chalkduster")
    newGameLabel.position = CGPoint(x: 512, y: 16)
    newGameLabel.fontSize = 34
    newGameLabel.text = "New Game!"
    newGameLabel.name = "newGame"
    newGameLabel.isHidden = true
    newGameLabel.horizontalAlignmentMode = .center
    addChild(newGameLabel)
    
    gameOver = SKSpriteNode(imageNamed: "gameOver")
    gameOver.position = CGPoint(x: 512, y: 384)
    gameOver.zPosition = 1
    gameOver.isHidden = true
    addChild(gameOver)
    
    startTimer()
  }
  
  func startTimer() {
    // initialize the timer to launch a rocket every 4sek
    gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
  }
  
  /// A method that will fire 5 fireworks at a time at different positions
  @objc func launchFireworks() {
    let movementAmount: CGFloat = 1800
    
    switch Int.random(in: 0...3) {
    case 0:
      // fire five, straight up
      createFirework(xMovement: 0, x: 512, y: bottomEdge)
      createFirework(xMovement: 0, x: 512 - 200, y: bottomEdge)
      createFirework(xMovement: 0, x: 512 - 100, y: bottomEdge)
      createFirework(xMovement: 0, x: 512 + 100, y: bottomEdge)
      createFirework(xMovement: 0, x: 512 + 200, y: bottomEdge)
    case 1:
      // fire five, in a fan
      createFirework(xMovement: 0, x: 512, y: bottomEdge)
      createFirework(xMovement: -200, x: 512 - 200, y: bottomEdge)
      createFirework(xMovement: -100, x: 512 - 100, y: bottomEdge)
      createFirework(xMovement: 100, x: 512 + 100, y: bottomEdge)
      createFirework(xMovement: 200, x: 512 + 200, y: bottomEdge)
    case 2:
      // fire five, from the left to the right
      createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
      createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
      createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
      createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
      createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
    case 3:
      // fire five, from the right to the left
      createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
      createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
      createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
      createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
      createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
    default:
      break
    }
    
    round += 1
    
    if round == totalRounds {
      gameTimer?.invalidate()
      gameOver.isHidden = false
      newGameLabel.isHidden = false
      for (index, firework) in fireworks.enumerated().reversed() {
        fireworks.remove(at: index)
        firework.removeFromParent()
      }
    }
  }
  
  /// A method used to create a firework
  func createFirework(xMovement: CGFloat, x: Int, y: Int) {
    // 1. Create an SKNode that will act as the firework container, and place it at the position that was specified.
    let node = SKNode()
    node.position = CGPoint(x: x, y: y)
    
    // 2. Create a rocket sprite node, give it the name "firework" so we know that it's the important thing, adjust its colorBlendFactor property so that we can color it, then add it to the container node.
    let firework = SKSpriteNode(imageNamed: "rocket")
    firework.colorBlendFactor = 1
    firework.name = "firework"
    node.addChild(firework)
    
    // 3. Give the firework sprite node one of three random colors: cyan, green or red.
    switch Int.random(in: 0...2) {
    case 0:
      firework.color = .red
    case 1:
      firework.color = .cyan
    case 2:
      firework.color = .green
    default:
      break
    }
    
    // 4. Create a UIBezierPath that will represent the movement of the firework.
    let path = UIBezierPath()
    path.move(to: .zero)
    path.addLine(to: CGPoint(x: xMovement, y: 1000))
    
    // 5. Tell the container node to follow that path, turning itself as needed.
    let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
    node.run(move)
    
    // 6. Create particles behind the rocket to make it look like the fireworks are lit.
    if let emitter = SKEmitterNode(fileNamed: "fuse") {
      emitter.position = CGPoint(x: 0, y: -22)
      node.addChild(emitter)
    }
    
    // 7. Add the node firework to our fireworks array and also to the scene.
    fireworks.append(node)
    addChild(node)
  }
  
  /// A method that will check for touch in the screan
  func checkTouches(_ touches: Set<UITouch>) {
    // get the first touch
    guard let touch = touches.first else { return }
    // get the location of the touch
    let location = touch.location(in: self)
    // get all the nodes in that location
    let nodesAtPoint = nodes(at: location)
    
    // iterate over all the nodes that have the type SKSpriteNode
    for case let node as SKSpriteNode in nodesAtPoint {
      // check for the node name
      guard node.name == "firework" else { continue }
      // inner loop that needs to ensure that the player can select only one firework color at a time.
      for parent in fireworks {
        guard let firework = parent.children.first as? SKSpriteNode else { continue }
        
        if firework.name == "selected" && firework.color != node.color {
          firework.name = "firework"
          firework.colorBlendFactor = 1
        }
      }
      
      // change it's name to selected
      node.name = "selected"
      // change it's color by removing colorBlendFactor which turns it to white
      node.colorBlendFactor = 0
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    // get the first touch
    guard let touch = touches.first else { return }
    // get the location of the touch
    let location = touch.location(in: self)
    // get all the nodes in that location
    let nodesAtPoint = nodes(at: location)
    
    if nodesAtPoint.contains(where: { $0.name == "newGame" }) {
      gameOver.isHidden = true
      newGameLabel.isHidden = true
      score = 0
      round = 0
      startTimer()
    }
    
    checkTouches(touches)
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesMoved(touches, with: event)
    checkTouches(touches)
  }
  
  // remove the fireworks when they are of the screen
  override func update(_ currentTime: TimeInterval) {
    for (index, firework) in fireworks.enumerated().reversed() {
      if firework.position.y > 900 {
        fireworks.remove(at: index)
        firework.removeFromParent()
      }
    }
  }
  
  /// A method that will explode a single firework
  func explode(firework: SKNode) {
    // check if the expolode emitter file exists
    if let emitter = SKEmitterNode(fileNamed: "explode") {
      // than add it in the same position as the firework
      emitter.position = firework.position
      // add it in the game scene
      addChild(emitter)
    }
    // remove firework form game scene
    firework.removeFromParent()
  }
  
  /// A method that will exploade multiple fireworks at once
  func explodeFireworks() {
    var numExploded = 0
    
    for (index, fireworkContainer) in fireworks.enumerated().reversed() {
      guard let firework = fireworkContainer.children.first as? SKSpriteNode else { continue }
      
      if firework.name == "selected" {
        // destroy this firework
        explode(firework: fireworkContainer)
        fireworks.remove(at: index)
        numExploded += 1
      }
    }
    
    switch numExploded {
    case 0:
      break
    case 1:
      score += 200
    case 2:
      score += 500
    case 3:
      score += 1500
    case 4:
      score += 2500
    default:
      score += 4000
    }
  }
  
}
