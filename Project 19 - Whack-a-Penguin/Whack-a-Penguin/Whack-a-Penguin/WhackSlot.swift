//
//  WhackSlot.swift
//  Whack-a-Penguin
//
//  Created by Mr.Kevin on 25/07/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import SpriteKit
import UIKit

class WhackSlot: SKNode {

  // a property where we'll store the penguin picture node
  var charNode: SKSpriteNode!
  
  var isVisible = false
  var isHit = false
  
  func configure(at position: CGPoint) {
    // will get the current position and draw a hole image in that position and add it to the sceene
    self.position = position
    let sprite = SKSpriteNode(imageNamed: "whackHole")
    addChild(sprite)
    
    // a node that we'll use to hide our penguins
    let cropNode = SKCropNode()
    cropNode.position = CGPoint(x: 0, y: 15)
    cropNode.zPosition = 1
    cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
    
    // create the penguin node
    charNode = SKSpriteNode(imageNamed: "penguinGood")
    charNode.position = CGPoint(x:0, y: -90)
    charNode.name = "character"
    // add the penguin node inside the cropNode
    cropNode.addChild(charNode)
    // add the cropNode into the sceene
    addChild(cropNode)
  }
  
  // a method that will show penguins good or evil
  func show(hideTime: Double) {
    // check if the slot isVisible
    if isVisible { return }
    
    // reset the scales for the penguin node
    charNode.xScale = 1
    charNode.yScale = 1
    
    // will move the penguin up
    charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
    isVisible = true
    isHit = false
    // set what type of penguin it is good or evil by changing only the texture
    if Int.random(in: 0...2) == 0 {
      charNode.texture = SKTexture(imageNamed: "penguinGood")
      charNode.name = "charFriend"
    } else {
      charNode.texture = SKTexture(imageNamed: "penguinEvil")
      charNode.name = "charEnemy"
    }
    
    // hide the penguins after they are shown in a calculated delay
    DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [weak self] in
      self?.hide()
    }
  }
  
  // a method that will hide the penguins back to the slots
  func hide() {
    // if it isVisible is true return
    if !isVisible { return }
    // move the penguind down
    charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
    // set isVisible to false
    isVisible = false
  }
  
  // a method that will be executed when a penguin is hit
  func hit() {
    isHit = true
    // create an action that will cause a delay of 0.25 sek
    let delay = SKAction.wait(forDuration: 0.25)
    // create an action that will move the penguin down
    let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
    // create an action that will change the isVisible to false
    let notVisible = SKAction.run { [weak self] in
      self?.isVisible = false
    }
    // run all the actions in the specified order on the penguin node
    charNode.run(SKAction.sequence([delay, hide, notVisible]))
  }
}
