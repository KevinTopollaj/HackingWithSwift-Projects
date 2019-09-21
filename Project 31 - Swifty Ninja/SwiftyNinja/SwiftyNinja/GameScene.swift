//
//  GameScene.swift
//  SwiftyNinja
//
//  Created by Mr.Kevin on 11/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import AVFoundation
import SpriteKit

// Enum that contains possible types of ways we can create enemy
enum SequenceType: CaseIterable {
  case oneNoBomb, one, twoWithOneBomb, two, three, four, chain, fastChain
}

// Enum that tracks what kind of enemy should be created
enum ForceBomb {
  case never, always, random
}


class GameScene: SKScene {
  
  /// Properties
  
  // properties used to keep the game score
  var gameScore: SKLabelNode!
  var score = 0 {
    didSet {
      gameScore.text = "Score: \(score)"
    }
  }
  
  // properties used to keep game lives
  var livesImages = [SKSpriteNode]()
  var lives = 3
  
  // properties used to draw swipe lines
  var activeSliceBG: SKShapeNode!
  var activeSliceFG: SKShapeNode!
  
  // property that will store the swipe points
  var activeSlicePoints = [CGPoint]()
  
  // property flag to add a swosh sound
  var isSwooshSoundActive = false
  
  // property that will track the items that are on the scene
  var activeEnemies = [SKSpriteNode]()
  
  // property that will contain the bomb sound effect
  var bombSoundEffect: AVAudioPlayer?
  
  /// Properties for sequence that the items will be displayed:
  // the amount of time to wait between the last enemy being destroyed and a new one being created.
  var popupTime = 0.9
  // an array of our SequenceType enum that defines what enemies to create.
  var sequence = [SequenceType]()
  // is where we are right now in the game.
  var sequencePosition = 0
  // is how long to wait before creating a new enemy when the sequence type is .chain or .fastChain.
  var chainDelay = 3.0
  // is used so we know when all the enemies are destroyed and we're ready to create more.
  var nextSequenceQueued = true
  
  // property flag to end the game
  var isGameEnded = false
  var gameOver: SKSpriteNode!
  
  
  override func didMove(to view: SKView) {
    // create the game background and add it to the scene
    let background = SKSpriteNode(imageNamed: "sliceBackground")
    background.position = CGPoint(x: 512, y: 384)
    background.blendMode = .replace
    background.zPosition = -1
    addChild(background)
    
    gameOver = SKSpriteNode(imageNamed: "gameOver")
    gameOver.position = CGPoint(x: 512, y: 384)
    gameOver.zPosition = 1
    gameOver.isHidden = true
    addChild(gameOver)
    
    // seting the gravity for how long the items will stay on scren
    physicsWorld.gravity = CGVector(dx: 0, dy: -6)
    physicsWorld.speed = 0.85
    
    createScore()
    createLives()
    createSlices()
    
    // create a sequence
    sequence = [.oneNoBomb, .oneNoBomb, .twoWithOneBomb, .twoWithOneBomb, .three, .one, .chain]
    
    for _ in 0...1000 {
      if let nextSequence = SequenceType.allCases.randomElement() {
        sequence.append(nextSequence)
      }
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
      self?.tossEnemies()
    }
    
  }
  
  /// method that will create the score label
  func createScore() {
    gameScore = SKLabelNode(fontNamed: "Chalkduster")
    gameScore.horizontalAlignmentMode = .left
    gameScore.fontSize = 48
    gameScore.position = CGPoint(x: 8, y: 8)
    addChild(gameScore)
    
    score = 0
  }
  
  /// method that will create the lives images
  func createLives() {
    for i in 0 ..< 3 {
      let spriteNode = SKSpriteNode(imageNamed: "sliceLife")
      spriteNode.position = CGPoint(x: CGFloat(834 + (i * 70)), y: 720)
      addChild(spriteNode)
      
      livesImages.append(spriteNode)
    }
  }
  
  // Draw two slice shapes, one in white and one in yellow to make it look like there's a hot glow.
  func createSlices() {
    activeSliceBG = SKShapeNode()
    activeSliceBG.zPosition = 2
    
    activeSliceFG = SKShapeNode()
    activeSliceFG.zPosition = 3
    
    activeSliceBG.strokeColor = UIColor(red: 1, green: 0.9, blue: 0, alpha: 1)
    activeSliceBG.lineWidth = 9
    
    activeSliceFG.strokeColor = .white
    activeSliceFG.lineWidth = 5
    
    addChild(activeSliceBG)
    addChild(activeSliceFG)
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    guard isGameEnded == false else { return }
    
    // find where in the scene user touched
    guard let touch = touches.first else { return }
    // get the location of the touch
    let location = touch.location(in: self)
    // add that location to the slice points array
    activeSlicePoints.append(location)
    // redraw the slice shape
    redrawActiveSlice()
    
    // will play a sound
    if !isSwooshSoundActive { playSwooshSound() }
    
    // get all the nodes at that location
    let nodesAtPoint = nodes(at: location)
    // find all the nodes whose type is SKSpriteNode
    for case let node as SKSpriteNode in nodesAtPoint {
      if node.name == "enemy" {
        /// Destroy penguin
        
        // 1. Create a particle effect over the penguin.
        if let emitter = SKEmitterNode(fileNamed: "sliceHitEnemy") {
          emitter.position = node.position
          addChild(emitter)
        }
        // 2. Clear its node name so that it can't be swiped repeatedly.
        node.name = ""
        // 3. Disable the isDynamic of its physics body so that it doesn't carry on falling.
        node.physicsBody?.isDynamic = false
        // 4. Make the penguin scale out and fade out at the same time.
        let scaleOut = SKAction.scale(to: 0.001, duration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let group = SKAction.group([scaleOut, fadeOut])
        // 5. After making the penguin scale out and fade out, we should remove it from the scene.
        let seq = SKAction.sequence([group, .removeFromParent()])
        node.run(seq)
        // 6. Add one to the player's score.
        score += 1
        // 7. Remove the enemy from our activeEnemies array.
        if let index = activeEnemies.firstIndex(of: node) {
          activeEnemies.remove(at: index)
        }
        // 8. Play a sound so the player knows they hit the penguin.
        run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion:
          false))
        
      } else if node.name == "bomb" {
        /// Destroy bomb
        guard let bombContainer = node.parent as? SKSpriteNode else { continue }
        
        if let emitter = SKEmitterNode(fileNamed: "sliceHitBomb") {
          emitter.position = bombContainer.position
          addChild(emitter)
        }
        
        node.name = ""
        
        bombContainer.physicsBody?.isDynamic = false
        
        let scaleOut = SKAction.scale(to: 0.001, duration:0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let group = SKAction.group([scaleOut, fadeOut])
        let seq = SKAction.sequence([group, .removeFromParent()])
        bombContainer.run(seq)
        
        if let index = activeEnemies.firstIndex(of: bombContainer) {
          activeEnemies.remove(at: index)
        }
        
        run(SKAction.playSoundFileNamed("explosion.caf", waitForCompletion: false))
        endGame(triggeredByBomb: true)
      }
    }
  }
  
  func playSwooshSound() {
    isSwooshSoundActive = true
    let randomNumber = Int.random(in: 1...3)
    let soundName = "swoosh\(randomNumber).caf"
    let swooshSound = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)
    
    run(swooshSound) { [weak self] in
      self?.isSwooshSoundActive = false
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    // fade the slides when the user stops touching the scene
    activeSliceBG.run(SKAction.fadeOut(withDuration: 0.25))
    activeSliceFG.run(SKAction.fadeOut(withDuration: 0.25))
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    // get the user touch on the scene
    guard let touch = touches.first else { return }
    // 1. Remove all existing points in the activeSlicePoints array, because we're starting fresh.
    activeSlicePoints.removeAll(keepingCapacity: true)
    // 2. Get the touch location and add it to the activeSlicePoints array.
    let location = touch.location(in: self)
    activeSlicePoints.append(location)
    // 3. Call the redrawActiveSlice() method to clear the slice shapes.
    redrawActiveSlice()
    // 4. Remove any actions that are currently attached to the slice shapes. This will be important if they are in the middle of a fadeOut(withDuration:) action.
    activeSliceBG.removeAllActions()
    activeSliceFG.removeAllActions()
    // 5. Set both slice shapes to have an alpha value of 1 so they are fully visible.
    activeSliceBG.alpha = 1
    activeSliceFG.alpha = 1
  }
  
  /// Will draw the slide shape
  func redrawActiveSlice() {
    // 1. If we have fewer than two points in our array, we don't have enough data to draw a line so it needs to clear the shapes and exit the method.
    if activeSlicePoints.count < 2 {
      activeSliceBG.path = nil
      activeSliceFG.path = nil
      return
    }
    // 2. If we have more than 12 slice points in our array, we need to remove the oldest ones until we have at most 12 – this stops the swipe shapes from becoming too long.
    if activeSlicePoints.count > 12 {
      activeSlicePoints.removeFirst(activeSlicePoints.count - 12)
    }
    // 3. It needs to start its line at the position of the first swipe point, then go through each of the others drawing lines to each point.
    let path = UIBezierPath()
    path.move(to: activeSlicePoints[0])
    
    for i in 1 ..< activeSlicePoints.count {
      path.addLine(to: activeSlicePoints[i])
    }
    // 4. Finally, it needs to update the slice shape paths so they get drawn using their designs – i.e., line width and color.
    activeSliceBG.path = path.cgPath
    activeSliceFG.path = path.cgPath
  }
  
  /// A method that is responsible for launching either a penguin or a bomb into the air for the player to swipe.
  func createEnemy(forceBomb: ForceBomb = .random) {
    // create a enemy sprite node
    let enemy: SKSpriteNode
    // create a random enemy type
    var enemyType = Int.random(in: 0...6)
    
    // Decide whether to create a bomb or a penguin (based on the parameter input) then create the correct thing.
    if forceBomb == .never {
      enemyType = 1
    } else if forceBomb == .always {
      enemyType = 0 // a bomb
    }
    
    if enemyType == 0 {
      /// Bomb Logic
      // 1. Create a new SKSpriteNode that will hold the fuse and the bomb image as children, setting its Z position to be 1.
      enemy = SKSpriteNode()
      enemy.zPosition = 1
      enemy.name = "bombContainer"
      // 2. Create the bomb image, name it "bomb", and add it to the container.
      let bombImage = SKSpriteNode(imageNamed: "sliceBomb")
      bombImage.name = "bomb"
      enemy.addChild(bombImage)
      // 3. If the bomb fuse sound effect is playing, stop it and destroy it.
      if bombSoundEffect != nil {
        bombSoundEffect?.stop()
        bombSoundEffect = nil
      }
      // 4. Create a new bomb fuse sound effect, then play it.
      if let path = Bundle.main.url(forResource: "sliceBombFuse", withExtension: "caf") {
        if let sound = try? AVAudioPlayer(contentsOf: path) {
          bombSoundEffect = sound
          sound.play()
        }
      }
      // 5. Create a particle emitter node, position it so that it's at the end of the bomb image's fuse, and add it to the container.
      if let emitter = SKEmitterNode(fileNamed: "sliceFuse") {
        emitter.position = CGPoint(x: 76, y: 64)
        enemy.addChild(emitter)
      }
      
    } else {
      // create a penguin
      enemy = SKSpriteNode(imageNamed: "penguin")
      run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
      enemy.name = "enemy"
    }
    
    /// Position Logic
    // 1. Give the enemy a random position off the bottom edge of the screen.
    let randomPosition = CGPoint(x: Int.random(in: 64...960), y: -128)
    enemy.position = randomPosition
    // 2. Create a random angular velocity, which is how fast something should spin.
    let randomAngularVelocity = CGFloat.random(in: -3...3 )
    let randomXVelocity: Int
    // 3. Create a random X velocity (how far to move horizontally) that takes into account the enemy's position.
    if randomPosition.x < 256 {
      randomXVelocity = Int.random(in: 8...15)
    } else if randomPosition.x < 512 {
      randomXVelocity = Int.random(in: 3...5)
    } else if randomPosition.x < 768 {
      randomXVelocity = -Int.random(in: 3...5)
    } else {
      randomXVelocity = -Int.random(in: 8...15)
    }
    // 4. Create a random Y velocity just to make things fly at different speeds.
    let randomYVelocity = Int.random(in: 24...32)
    // 5. Give all enemies a circular physics body where the collisionBitMask is set to 0 so they don't collide.
    enemy.physicsBody = SKPhysicsBody(circleOfRadius: 64)
    enemy.physicsBody?.velocity = CGVector(dx: randomXVelocity * 40, dy: randomYVelocity * 40)
    enemy.physicsBody?.angularVelocity = randomAngularVelocity
    enemy.physicsBody?.collisionBitMask = 0 // will not bounce with each other
    
    // Add the new enemy to the scene, and also to our activeEnemies array.
    addChild(enemy)
    activeEnemies.append(enemy)
    
  }
  
  // This method is called every frame before it's drawn, and gives you a chance to update your game state as you want.
  override func update(_ currentTime: TimeInterval) {
    
    if activeEnemies.count > 0 {
      for (index, node) in activeEnemies.enumerated().reversed() {
        if node.position.y < -140 {
          node.removeAllActions()
          if node.name == "enemy" {
            node.name = ""
            subtractLife()
            
            node.removeFromParent()
            activeEnemies.remove(at: index)
          } else if node.name == "bombContainer" {
            node.name = ""
            node.removeFromParent()
            activeEnemies.remove(at: index)
          }
        }
      }
    } else {
      if !nextSequenceQueued {
        DispatchQueue.main.asyncAfter(deadline: .now() + popupTime) { [weak self] in
          self?.tossEnemies()
        }
        nextSequenceQueued = true
      }
    }
    
    var bombCount = 0
    
    for node in activeEnemies {
      if node.name == "bombContainer" {
        bombCount += 1
        break
      }
    }
    
    if bombCount == 0 {
      // no bombs – stop the fuse sound!
      bombSoundEffect?.stop()
      bombSoundEffect = nil
    }
  }
  
  // will throw items in our scene
  func tossEnemies() {
    
    guard isGameEnded == false else { return }
    
    popupTime *= 0.991
    chainDelay *= 0.99
    physicsWorld.speed *= 1.02
    
    let sequenceType = sequence[sequencePosition]
    
    
    switch sequenceType {
    case .oneNoBomb:
      createEnemy(forceBomb: .never)
      
    case .one:
      createEnemy()
      
    case .twoWithOneBomb:
      createEnemy(forceBomb: .never)
      createEnemy(forceBomb: .always)
      
    case .two:
      createEnemy()
      createEnemy()
      
    case .three:
      createEnemy()
      createEnemy()
      createEnemy()
      
    case .four:
      createEnemy()
      createEnemy()
      createEnemy()
      createEnemy()
      
    case .chain:
      createEnemy()
      DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0)) { [weak self] in self?.createEnemy() }
      DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 2)) { [weak self] in self?.createEnemy() }
      DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 3)) { [weak self] in self?.createEnemy() }
      DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 4)) { [weak self] in self?.createEnemy() }
      
    case .fastChain:
      createEnemy()
      DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0)) { [weak self] in self?.createEnemy() }
      DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 2)) { [weak self] in self?.createEnemy() }
      DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 3)) { [weak self] in self?.createEnemy() }
      DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 4)) { [weak self] in self?.createEnemy() }
    }
    
    sequencePosition += 1
    nextSequenceQueued = false
  }
  
  func subtractLife() {
    lives -= 1
    run(SKAction.playSoundFileNamed("wrong.caf", waitForCompletion: false))
    
    var life: SKSpriteNode
    
    if lives == 2 {
      life = livesImages[0]
    } else if lives == 1 {
      life = livesImages[1]
    } else {
      life = livesImages[2]
      endGame(triggeredByBomb: false)
      gameOver.isHidden = false
    }
    
    life.texture = SKTexture(imageNamed: "sliceLifeGone")
    life.xScale = 1.3
    life.yScale = 1.3
    life.run(SKAction.scale(to: 1, duration:0.1))
  }
  
  func endGame(triggeredByBomb: Bool) {
    guard isGameEnded == false else { return }
    
    isGameEnded = true
    
    physicsWorld.speed = 0
    
    isUserInteractionEnabled = false
    
    bombSoundEffect?.stop()
    bombSoundEffect = nil
    
    if triggeredByBomb {
      livesImages[0].texture = SKTexture(imageNamed: "sliceLifeGone")
      livesImages[1].texture = SKTexture(imageNamed: "sliceLifeGone")
      livesImages[2].texture = SKTexture(imageNamed: "sliceLifeGone")
      gameOver.isHidden = false
    }
  }
  
  
}
