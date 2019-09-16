//
//  GameScene.swift
//  ShootingGallery
//
//  Created by Mr.Kevin on 16/09/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
  
  var waterBackgroundNode: SKSpriteNode!
  var waterForegroundNode: SKSpriteNode!
  var targetNode: SKSpriteNode!
  
  
  var timeLabel: SKLabelNode!
  var seconds = 120 {
    willSet {
      timeLabel.text = "\(newValue)"
    }
  }
  
  var gameOver: SKSpriteNode!
  var isGameOver: Bool = true {
    willSet {
      if newValue {
        newGameLabel.isHidden = false
      } else if !newValue {
        newGameLabel.isHidden = true
      }
    }
  }
  
  var newGameLabel: SKLabelNode!
  var gameTimer: Timer?
  
  var scoreLabel: SKLabelNode!
  var score = 0 {
    didSet {
      scoreLabel.text = "Score: \(score)"
    }
  }
  
  var bulletsNode: SKSpriteNode!
  var bullet = 3 {
    didSet {
      bulletsNode.texture = SKTexture(imageNamed: "bullet\(bullet)")
    }
  }
  
  var reloadLabel: SKLabelNode!
  
  override func didMove(to view: SKView) {
    let background = SKSpriteNode(imageNamed: "background")
    background.blendMode = .replace
    background.position = CGPoint(x: 512, y: 394)
    background.zPosition = -1
    background.size = view.frame.size
    addChild(background)
    
    let forest = SKSpriteNode(imageNamed: "forest")
    forest.position = CGPoint(x: 512, y: 480)
    forest.size.width = view.frame.size.width
    forest.zPosition = 2
    addChild(forest)
    
    waterBackgroundNode = SKSpriteNode(imageNamed: "water-bg")
    waterBackgroundNode.position = CGPoint(x: 512, y: 280)
    waterBackgroundNode.size.width = view.frame.size.width
    waterBackgroundNode.zPosition = 4
    addChild(waterBackgroundNode)
    
    waterForegroundNode = SKSpriteNode(imageNamed: "water-fg")
    waterForegroundNode.position = CGPoint(x: 512, y: 180)
    waterForegroundNode.size.width = view.frame.size.width
    waterForegroundNode.zPosition = 6
    addChild(waterForegroundNode)
    
    timeLabel = SKLabelNode(fontNamed: "Chalkduster")
    timeLabel.position = CGPoint(x: 512, y: 10)
    timeLabel.zPosition = 10
    timeLabel.text = "120"
    timeLabel.fontSize = 40
    addChild(timeLabel)
    
    scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    scoreLabel.position = CGPoint(x: 120, y: 10)
    scoreLabel.zPosition = 10
    scoreLabel.fontSize = 40
    scoreLabel.text = "Score: 0"
    scoreLabel.horizontalAlignmentMode = .left
    addChild(scoreLabel)
    
    bulletsNode = SKSpriteNode(imageNamed: "bullet\(bullet)")
    bulletsNode.position = CGPoint(x: 700, y: 30)
    bulletsNode.zPosition = 10
    bulletsNode.isHidden = true
    addChild(bulletsNode)
    
    reloadLabel = SKLabelNode(fontNamed: "Chalkduster")
    reloadLabel.position = CGPoint(x: 840, y: 10)
    reloadLabel.zPosition = 10
    reloadLabel.fontSize = 25
    reloadLabel.text = "RELOAD!"
    reloadLabel.name = "reload"
    reloadLabel.isHidden = true
    addChild(reloadLabel)
    
    newGameLabel = SKLabelNode(fontNamed: "Chalkduster")
    newGameLabel.fontColor = .white
    newGameLabel.position = CGPoint(x: 512, y: 690)
    newGameLabel.zPosition = 10
    newGameLabel.fontSize = 50
    newGameLabel.text = "New Game"
    newGameLabel.name = "playGame"
    newGameLabel.alpha = 1
    addChild(newGameLabel)
    
    gameOver = SKSpriteNode(imageNamed: "game-over")
    gameOver.zPosition = 10
    gameOver.position = CGPoint(x: 512, y: 384)
    gameOver.isHidden = true
    addChild(gameOver)
  }
  
  @objc func startGame() {
    
    createWaveAnimation()
    
    // Reset parameters
    gameOver.alpha = 0
    seconds = 120
    bullet = 3
    score = 0
    reloadLabel.isHidden = false
    bulletsNode.isHidden = false
    
    // Initialize a timer every second so it updates the label to display how many seconds remain and creates enemy
    gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
  }
  
  @objc func handleTimer() {
    seconds -= 1
    
    slideEnemy()
    
    if seconds == 0 {
      gameTimer?.invalidate()
      reloadLabel.isHidden = true
      bulletsNode.isHidden = true
      gameOver.isHidden = false
      isGameOver.toggle()
      gameOver.run(SKAction.fadeIn(withDuration: 1.5))
      run(SKAction.playSoundFileNamed("gameOver", waitForCompletion: false))
    }
  }
  
  func slideEnemy() {
    guard !isGameOver else { return }
    
    if Int.random(in: 1...2) == 1 {
      let numLine = Int.random(in: 1...2)
      
      if numLine == 1 {
        createEnemy(y: 300, zPosition: 5)
      }
      
      if numLine == 2 {
        createEnemy(y: 400, zPosition: 3)
      }
    }
  }
  
  func createEnemy(y: Int, zPosition: CGFloat) {
    let randomTarget = Int.random(in: 0...2)
    
    switch randomTarget {
    case 0:
      targetNode = SKSpriteNode(imageNamed: "target0")
      targetNode.name = "badTarget"
    case 1:
      targetNode = SKSpriteNode(imageNamed: "target1")
      targetNode.name = "goodTarget"
    default:
      targetNode = SKSpriteNode(imageNamed: "target2")
      targetNode.name = "goldTarget"
    }
    
    let moveTargetSlowOnLine = SKAction.moveTo(x: -200, duration: 4)
    let moveTargetFastOnLine = SKAction.moveTo(x: -200, duration: 2)
    
    if randomTarget == 2 {
      targetNode.xScale = 0.7
      targetNode.yScale = 0.7
      targetNode.run(moveTargetFastOnLine)
      targetNode.position = CGPoint(x: 960, y: CGFloat(y - 20))
    } else {
      targetNode.run(moveTargetSlowOnLine)
      targetNode.position = CGPoint(x: 960, y: y)
    }
    
    targetNode.zPosition = zPosition
    
    addChild(targetNode)
  }
  
  func createWaveAnimation() {
    
    let moveWaveForward = SKAction.moveTo(x: 562, duration: 0.8)
    let moveWaveBackward = SKAction.moveTo(x: 472, duration: 0.8)
    
    // Create forever animation for the first line
    let moveLineForeground = SKAction.sequence([moveWaveForward, moveWaveBackward])
    let moveLineForegroundForever = SKAction.repeatForever(moveLineForeground)
    waterForegroundNode.run(moveLineForegroundForever)
    
    let moveLineBackground = SKAction.sequence([moveWaveBackward, moveWaveForward])
    let moveLineBackgroundForever = SKAction.repeatForever(moveLineBackground)
    waterBackgroundNode.run(moveLineBackgroundForever)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let tappedNodes = nodes(at: location)
    
    if tappedNodes.contains(where: { $0.name == "playGame" }) {
      startGame()
      isGameOver.toggle()
      return
    }

    if tappedNodes.contains(where: { $0.name == "reload" }) {
      run(SKAction.playSoundFileNamed("reload", waitForCompletion: false))
      bullet = 3
    } else {
      if bullet > 0 {
        run(SKAction.playSoundFileNamed("shot", waitForCompletion: false))
        bullet -= 1
      } else {
        return
      }
    }
    
    for node in tappedNodes {
      if node.name == "badTarget" {
        node.removeAllActions()
        node.run(SKAction.fadeOut(withDuration: 0.3))
        switch score {
        case 0...1000:
          score -= 50
        case 1001...5000:
          score -= 150
        case 5001...10000:
          score -= 300
        case 10001...50000:
          score -= 500
        default:
          score -= 50
        }
      } else if node.name == "goodTarget" {
        node.removeAllActions()
        node.run(SKAction.fadeOut(withDuration: 0.3))
        score += 100
      } else if node.name == "goldTarget" {
        node.removeAllActions()
        node.run(SKAction.fadeOut(withDuration: 0.3))
        if score > 0 {
          score *= 2
        }
      }
    }
    
  }
  
  override func update(_ currentTime: TimeInterval) {
    
    for node in children {
      if node.position.x < -150 {
        node.removeFromParent()
      }
    }
  }
  
}
