//
//  GameScene.swift
//  CrashyPlane
//
//  Created by Mr.Kevin on 28/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import SpriteKit

enum GameState {
  case showingLogo
  case playing
  case dead
}

/// Adopt to a protocol that will tell us when a collision happens
class GameScene: SKScene, SKPhysicsContactDelegate {
  
  /// Properties
  var player: SKSpriteNode!
  var scoreLabel: SKLabelNode!
  
  var score = 0 {
    didSet {
      scoreLabel.text = "Score: \(score)"
    }
  }
  
  var backgroundMusic: SKAudioNode!
  
  var logo: SKSpriteNode!
  var gameOver: SKSpriteNode!
  var gameState = GameState.showingLogo
  
  let rockTexture = SKTexture(imageNamed: "rock")
  var rockPhysics: SKPhysicsBody!
  
  // will create the emitter and have it in memory
  let explosion = SKEmitterNode(fileNamed: "PlayerExplosion")
  
  override func didMove(to view: SKView) {
    rockPhysics = SKPhysicsBody(texture: rockTexture, size: rockTexture.size())
    
    createPlayer()
    createSky()
    createBackground()
    createGround()
    createScore()
    createLogos()
    
    // add gravity to the game
    physicsWorld.gravity = CGVector(dx: 0, dy: -5.0)
    // make our GameScene to be the delegate for contacts
    physicsWorld.contactDelegate = self
    
    // find the url of the music file in the bundle
    if let musicURL = Bundle.main.url(forResource: "music", withExtension: "m4a") {
      // initialize the audio node and add it to the scene
      backgroundMusic = SKAudioNode(url: musicURL)
      addChild(backgroundMusic)
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    switch gameState {
      
    case .showingLogo:
      // update the game state to playing
      gameState = .playing
      
      // create actions
      let fadeOut = SKAction.fadeOut(withDuration: 0.5)
      let remove = SKAction.removeFromParent()
      let wait = SKAction.wait(forDuration: 0.5)
      let activatePlayer = SKAction.run { [unowned self] in
        // make the player respond to physics
        self.player.physicsBody?.isDynamic = true
        // start showing the rocks
        self.startRocks()
      }
      // create a sequence that will execute all actions
      let sequence = SKAction.sequence([fadeOut, wait, activatePlayer, remove])
      // execute the sequence on the logo
      logo.run(sequence)
      
    case .playing:
      // make the physics a bit more realistic and it effectively neutralizes any existing upward velocity the player has before applying the new movement.
      player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
      // give the player a push upwards every time the player taps the screen.
      player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
      
    case .dead:
      // present a whole new GameScene scene that causes the whole game to be reset:
      if let scene = GameScene(fileNamed: "GameScene") {
        scene.scaleMode = .aspectFill
        let transition = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 1)
        view?.presentScene(scene, transition: transition)
      }
    }
    
    
  }
  
  // A method, which is called by SpriteKit once every frame so we can update our game
  override func update(_ currentTime: TimeInterval) {
    // make sure a player exists
    guard player != nil else { return }
    
    // take 1/1000th of the player's upward velocity and turn that into rotation.
    let value = player.physicsBody!.velocity.dy * 0.001
    let rotate = SKAction.rotate(toAngle: value, duration: 0.1)
    player.run(rotate)
  }
  
  // A method called when 2bodies first contact each other
  func didBegin(_ contact: SKPhysicsContact) {
    
    if contact.bodyA.node?.name == "scoreDetect" || contact.bodyB.node?.name == "scoreDetect" {
      
      if contact.bodyA.node == player {
        contact.bodyB.node?.removeFromParent()
      } else {
        contact.bodyA.node?.removeFromParent()
      }
      
      let sound = SKAction.playSoundFileNamed("coin.wav", waitForCompletion: false)
      run(sound)
      score += 1
      return
    }
    // The guard avoids any collisions where either node has become nil.
    guard contact.bodyA.node != nil && contact.bodyB.node != nil else { return }
    
    
    if contact.bodyA.node == player || contact.bodyB.node == player {
      // player has hit the rock or the ground so remove it an add an explosion emitter
      if let explosion = SKEmitterNode(fileNamed: "PlayerExplosion") {
        explosion.position = player.position
        addChild(explosion)
      }
      // add the explosion sound and remove the player from the scene
      let sound = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
      run(sound)
      
      // show the gameOver node
      gameOver.alpha = 1
      // change the game state to ded
      gameState = .dead
      // stop the background music
      backgroundMusic.run(SKAction.stop())
      
      player.removeFromParent()
      // adjusting the speed property to 0 for our game scene, which in turns get inherited by all children – i.e., everything in the game. This has the effect of halting all those move actions we added to make parallax scrolling work, effectively ending the game.
      speed = 0
    }
  }
  
  /// a method that will create a player in the scene
  func createPlayer() {
    let playerTexture = SKTexture(imageNamed: "player-1")
    player = SKSpriteNode(texture: playerTexture)
    player.zPosition = 10
    player.position = CGPoint(x: frame.width / 6, y: frame.height * 0.75)
    addChild(player)
    
    // 1. sets up pixel-perfect physics body using the sprite of the plane.
    player.physicsBody = SKPhysicsBody(texture: playerTexture, size: playerTexture.size())
    // 2. makes SpriteKit tell us whenever the player collides with anything.
    player.physicsBody!.contactTestBitMask = player.physicsBody!.collisionBitMask
    // 3. makes the plane respond to physics.
    player.physicsBody?.isDynamic = false
    // 4. makes the plane bounce off nothing.
    player.physicsBody?.collisionBitMask = 0
    
    let frame2 = SKTexture(imageNamed: "player-2")
    let frame3 = SKTexture(imageNamed: "player-3")
    let animation = SKAction.animate(with: [playerTexture, frame2, frame3, frame2], timePerFrame: 0.01)
    let runForever = SKAction.repeatForever(animation)
    
    player.run(runForever)
  }
  
  func createScore() {
    scoreLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
    scoreLabel.fontSize = 24
    scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 60)
    scoreLabel.text = "SCORE: 0"
    scoreLabel.fontColor = UIColor.black
    addChild(scoreLabel)
  }
  
  func createSky() {
    
    let topSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.14, brightness: 0.97, alpha: 1), size: CGSize(width: frame.width, height: frame.height * 0.67))
    topSky.anchorPoint = CGPoint(x: 0.5, y: 1)
    
    let bottomSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.16, brightness: 0.96, alpha: 1), size: CGSize(width: frame.width, height: frame.height * 0.33))
    bottomSky.anchorPoint = CGPoint(x: 0.5, y: 1)
    
    topSky.position = CGPoint(x: frame.midX, y: frame.height)
    bottomSky.position = CGPoint(x: frame.midX, y: bottomSky.frame.height)
    
    addChild(topSky)
    addChild(bottomSky)
    
    bottomSky.zPosition = -40
    topSky.zPosition = -40
  }
  
  func createBackground() {
    let backgroundTexture = SKTexture(imageNamed: "background")
    
    for i in 0 ... 1 {
      let background = SKSpriteNode(texture: backgroundTexture)
      background.zPosition = -30
      
      background.anchorPoint = CGPoint.zero
      background.position = CGPoint(x: (backgroundTexture.size().width * CGFloat(i)) - CGFloat(1 * i), y: 100)
      addChild(background)
      
      // will make a infinit scroll for the mountain on the scene
      let moveLeft = SKAction.moveBy(x: -backgroundTexture.size().width, y: 0, duration: 20)
      let moveReset = SKAction.moveBy(x: backgroundTexture.size().width, y: 0, duration: 0)
      let moveLoop = SKAction.sequence([moveLeft, moveReset])
      let moveForever = SKAction.repeatForever(moveLoop)
      background.run(moveForever)
    }
  }
  
  func createGround() {
    let groundTexture = SKTexture(imageNamed: "ground")
    
    for i in 0 ... 1 {
      
      let ground = SKSpriteNode(texture: groundTexture)
      ground.zPosition = -10
      ground.position = CGPoint(x: (groundTexture.size().width / 2.0 + (groundTexture.size().width * CGFloat(i))), y: groundTexture.size().height / 2)
      
      ground.physicsBody = SKPhysicsBody(texture: ground.texture!, size: ground.texture!.size())
      ground.physicsBody?.isDynamic = false
      
      addChild(ground)
      
      // will make a infinit scroll for the ground on the scene
      let moveLeft = SKAction.moveBy(x: -groundTexture.size().width, y: 0, duration: 5)
      let moveReset = SKAction.moveBy(x: groundTexture.size().width, y: 0, duration: 0)
      let moveLoop = SKAction.sequence([moveLeft, moveReset])
      let moveForever = SKAction.repeatForever(moveLoop)
      
      ground.run(moveForever)
    }
  }
  
  func createRocks() {
    // 1. Create top and bottom rock sprites. They are both the same graphic, but we're going to rotate the top one and flip it horizontally so that the two rocks form a spiky death for the player.
    let rockTexture = SKTexture(imageNamed: "rock")
    
    let topRock = SKSpriteNode(texture: rockTexture)
    // give the top rock a picel-perfect physics body
    topRock.physicsBody = rockPhysics.copy() as? SKPhysicsBody
    // make the top rock to be in a static position on the scene
    topRock.physicsBody?.isDynamic = false
    
    topRock.zRotation = .pi
    topRock.xScale = -1.0
    
    let bottomRock = SKSpriteNode(texture: rockTexture)
    bottomRock.physicsBody = rockPhysics.copy() as? SKPhysicsBody
    bottomRock.physicsBody?.isDynamic = false
    
    topRock.zPosition = -20
    bottomRock.zRotation = -20
    
    // 2. Create a third sprite that is a large red rectangle. This will be positioned just after the rocks and will be used to track when the player has passed through the rocks safely – if they touch that red rectangle, they should score a point. (Don't worry, we'll make it invisible later!)
    let rockCollision = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 32, height: frame.height))
    
    rockCollision.physicsBody = SKPhysicsBody(rectangleOf: rockCollision.size)
    rockCollision.physicsBody?.isDynamic = false
    
    rockCollision.name = "scoreDetect"
    
    addChild(topRock)
    addChild(bottomRock)
    addChild(rockCollision)
    
    // 3. Use Swift’s random number generation to generate a number in a range. This will be used to determine where the safe gap in the rocks should be.
    let xPosition = frame.width + topRock.frame.width
    let max = CGFloat(frame.height / 3)
    let yPosition = CGFloat.random(in: -50...max)
    // this next value affects the width of the gap between rocks
    // make it smaller to make your game harder – if you're feeling evil!
    let rockDistance: CGFloat = 70
    
    // 4. Position the rocks just off the right edge of the screen, then animate them across to the left edge. When they are safely off the left edge, remove them from the game.
    topRock.position = CGPoint(x: xPosition, y: yPosition + topRock.size.height + rockDistance)
    bottomRock.position = CGPoint(x: xPosition, y: yPosition - rockDistance)
    rockCollision.position = CGPoint(x: xPosition + (rockCollision.size.width * 2), y: frame.midY)
    
    let endPosition = frame.width + (topRock.frame.width * 2)
    let moveAction = SKAction.moveBy(x: -endPosition, y: 0, duration: 6.2)
    let moveSequence = SKAction.sequence([moveAction, SKAction.removeFromParent()])
    
    topRock.run(moveSequence)
    bottomRock.run(moveSequence)
    rockCollision.run(moveSequence)
  }
  
  func startRocks() {
    // will create the rocks
    let create = SKAction.run { [unowned self] in
      self.createRocks()
    }
    // will wait 3sek
    let wait = SKAction.wait(forDuration: 3)
    // put them in a sequence and repeat them forever
    let sequence = SKAction.sequence([create, wait])
    let repeatForever = SKAction.repeatForever(sequence)
    run(repeatForever)
  }
  
  func createLogos() {
    // creates and positions the logo that it's shown when the game starts
    logo = SKSpriteNode(imageNamed: "logo")
    logo.position = CGPoint(x: frame.midX, y: frame.midY)
    addChild(logo)
    
    // creates and positions the logo that it's shown when the game is over
    gameOver = SKSpriteNode(imageNamed: "gameover")
    gameOver.position = CGPoint(x: frame.midX, y: frame.midY)
    // will make it invisible
    gameOver.alpha = 0
    addChild(gameOver)
  }
  
}
