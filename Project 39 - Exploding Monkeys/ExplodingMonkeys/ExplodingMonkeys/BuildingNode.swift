//
//  BuildingNode.swift
//  ExplodingMonkeys
//
//  Created by Mr.Kevin on 20/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import SpriteKit
import UIKit

class BuildingNode: SKSpriteNode {
  
  var currentImage: UIImage!

  /// will do the basic work required to make this thing a building: setting its name, texture, and physics.
  func setup() {
    name = "building"
    
    currentImage = drawBuilding(size: size)
    texture = SKTexture(image: currentImage)
    
    configurePhysics()
  }
  
  /// will do the Core Graphics rendering of a building, and return it as a UIImage.
  func drawBuilding(size: CGSize) -> UIImage {
    
    // 1. Create a new Core Graphics context the size of our building.
    let renderer = UIGraphicsImageRenderer(size: size)
    
    let image = renderer.image { context in
      
      // 2. Fill it with a rectangle that's one of three colors.
      let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height)
      let color: UIColor
      
      switch Int.random(in: 0...2) {
      case 0:
        color = UIColor(hue: 0.502, saturation: 0.98, brightness: 0.67, alpha: 1)
      
      case 1:
        color = UIColor(hue: 0.999, saturation: 0.99, brightness: 0.67, alpha: 1)
        
      default:
        color = UIColor(hue: 0, saturation: 0, brightness: 0.67, alpha: 1)
      }
      
      color.setFill()
      context.cgContext.addRect(rectangle)
      context.cgContext.drawPath(using: .fill)
      
      // 3. Draw windows all over the building in one of two colors: there's either a light on (yellow) or not (gray).
      let lightOnColor = UIColor(hue: 0.190, saturation: 0.67, brightness: 0.99, alpha: 1)
      let lightOffColor = UIColor(hue: 0, saturation: 0, brightness: 0.34, alpha: 1)
      
      for row in stride(from: 10, to: Int(size.height - 10), by: 40) {
        for col in stride(from: 10, to: Int(size.width - 10), by: 40) {
          if Bool.random() {
            lightOnColor.setFill()
          } else {
            lightOffColor.setFill()
          }
          context.cgContext.fill(CGRect(x: col, y: row, width: 15, height: 20))
        }
      }
    }
    // 4. Pull out the result as a UIImage and return it for use.
    return image
  }
  
  /// will set up per-pixel physics for the sprite's current texture.
  func configurePhysics() {
    physicsBody = SKPhysicsBody(texture: texture!, size: size)
    physicsBody?.isDynamic = false
    physicsBody?.categoryBitMask = CollisionTypes.building.rawValue
    physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
  }
  
  
  func hit(at point: CGPoint) {
    let convertedPoint = CGPoint(x: point.x + size.width / 2.0, y: abs(point.y - (size.height / 2.0)))
    let renderer = UIGraphicsImageRenderer(size: size)
    
    let img = renderer.image { ctx in
      currentImage.draw(at: .zero)
      ctx.cgContext.addEllipse(in: CGRect(x: convertedPoint.x - 32, y: convertedPoint.y - 32, width: 64, height: 64))
      ctx.cgContext.setBlendMode(.clear)
      ctx.cgContext.drawPath(using: .fill)
    }
    
    texture = SKTexture(image: img)
    currentImage = img
    configurePhysics()
  }
  
}
