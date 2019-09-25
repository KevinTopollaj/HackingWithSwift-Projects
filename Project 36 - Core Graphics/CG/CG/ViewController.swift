//
//  ViewController.swift
//  CG
//
//  Created by Mr.Kevin on 17/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet var imageView: UIImageView!
  var currentDrawType = 0

  override func viewDidLoad() {
    super.viewDidLoad()

    drawRectangle()
  }
  
  @IBAction func redrawTapped(_ sender: Any) {
    currentDrawType += 1
    
    if currentDrawType > 7 {
      currentDrawType = 0
    }
    
    switch currentDrawType {
    case 0:
      drawRectangle()
    case 1:
      drawCircle()
    case 2:
      drawCheckerboard()
    case 3:
      drawRotatedSquares()
    case 4:
      drawLines()
    case 5:
      drawImagesAndText()
    case 6:
      drawEmoji()
    case 7:
      writeTwin()
    default:
      break
    }
  }
  
  /// A method that will use CoreGraphics to draw a rectangle
  func drawRectangle() {
    // create a renderer obj
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
    
    // starts drawing using a context
    let img = renderer.image { context in
      // create the rectangle dimensions
      let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
      
      // sets the fill color of our context, which is the color used on the insides of the rectangle we'll draw.
      context.cgContext.setFillColor(UIColor.red.cgColor)
      // sets the stroke color of our context, which is the color used on the line around the edge of the rectangle we'll draw.
      context.cgContext.setStrokeColor(UIColor.black.cgColor)
      // adjusts the line width that will be used to stroke our rectangle.
      context.cgContext.setLineWidth(10)
      
      // adds a CGRect rectangle to the context's current path to be drawn.
      context.cgContext.addRect(rectangle)
      // draws the context's current path using the state you have configured.
      context.cgContext.drawPath(using: .fillStroke)
    }

    // add the drawing to the image of the imageView
    imageView.image = img
  }
  
  /// A method that will use CoreGraphics to draw a circle
  func drawCircle() {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
    
    let image = renderer.image { contex in
      let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
      
      contex.cgContext.setFillColor(UIColor.cyan.cgColor)
      contex.cgContext.setStrokeColor(UIColor.gray.cgColor)
      contex.cgContext.setLineWidth(10)
      
      contex.cgContext.addEllipse(in: rectangle)
      contex.cgContext.drawPath(using: .fillStroke)
    }
    
    imageView.image = image
  }

  /// A method that will use CoreGraphics to draw a Checkerboard
  func drawCheckerboard() {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width:512, height: 512))
    
    let img = renderer.image { context in
      context.cgContext.setFillColor(UIColor.black.cgColor)
      
      for row in 0 ..< 8 {
        for col in 0 ..< 8 {
          if (row + col) % 2 == 0 {
            context.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
          }
        }
      }
      
    }
    
    imageView.image = img
  }
  
  
  func drawRotatedSquares() {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
    
    let img = renderer.image { context in
      
      // translates (moves) the current transformation matrix.
      context.cgContext.translateBy(x: 256, y: 256)
      let rotations = 16
      let amount = Double.pi / Double(rotations)
      
      for _ in 0 ..< rotations {
        // rotates the current transformation matrix.
        context.cgContext.rotate(by: CGFloat(amount))
        // adds a CGRect rectangle to the context's current path to be drawn.
        context.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
      }
      // sets the stroke color of our context, which is the color used on the line
      context.cgContext.setStrokeColor(UIColor.green.cgColor)
      // strokes the path with your specified line width, which is 1 if you don't set it explicitly.
      context.cgContext.strokePath()
    }
    
    imageView.image = img
  }
  
  
  func drawLines() {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
    
    let img = renderer.image { ctx in
      
      ctx.cgContext.translateBy(x: 256, y: 256) // draw to the center
      
      var first = true
      var length: CGFloat = 256
      
      for _ in 0 ..< 256 {
        ctx.cgContext.rotate(by: .pi / 2) // rotate 90 degres
        if first {
          ctx.cgContext.move(to: CGPoint(x: length, y: 50))
          first = false
        } else {
          ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
        }
        length *= 0.99
      }
      
      ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
      ctx.cgContext.strokePath()
    }
    
    imageView.image = img
  }
  
  
  func drawImagesAndText() {
    // 1. Create a renderer at the correct size.
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
    
    let image = renderer.image { (context) in
      
      // 2. Define a paragraph style that aligns text to the center.
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.alignment = .center
      
      // 3. Create an attributes dictionary containing that paragraph style, and also a font.
      let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 36),
        .paragraphStyle: paragraphStyle
      ]
      
      // 4. Wrap that attributes dictionary and a string into an instance of NSAttributedString.
      let string = "This is a mouse image."
      let attributedString = NSAttributedString(string: string, attributes: attributes)
      
      // 5. Draw the NSAttributedString to the context.
      attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
      
      // 6. Load an image from the project and draw it to the context.
      let mouse = UIImage(named: "mouse")
      mouse?.draw(at: CGPoint(x: 300, y: 150))
      
    }
    
    // 6. Update the image view with the finished result.
    imageView.image = image
  }
  
  func drawEmoji() {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
    
    let img = renderer.image { ctx in
      ctx.cgContext.translateBy(x: 256, y: 256)
      
      let rotations = 5
      let amount = (Double.pi) / 2.5
      
      ctx.cgContext.rotate(by: .pi / 5.7)
      
      ctx.cgContext.move(to: CGPoint(x: -11, y: 130))
      
      for _ in 0 ..< rotations {
        ctx.cgContext.addLine(to: CGPoint(x: -30, y: 30))
        ctx.cgContext.addLine(to: CGPoint(x: -128, y: 30))
        ctx.cgContext.rotate(by: CGFloat(amount))
      }
      
      ctx.cgContext.setFillColor(UIColor.red.cgColor)
      
      ctx.cgContext.drawPath(using: .fill)
    }
    
    imageView.image = img
  }
  
  func writeTwin() {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
    
    let img = renderer.image { ctx in
      let spacing = 15
      var letterStartingPoint = 15
      let lenghtLineLetter = 50
      
      // Start String
      ctx.cgContext.translateBy(x: 187, y: 228)
      
      // Letter T
      ctx.cgContext.move(to: CGPoint(x: 0, y: 0))
      ctx.cgContext.addLine(to: CGPoint(x: 0, y: lenghtLineLetter))
      
      ctx.cgContext.move(to: CGPoint(x: -(lenghtLineLetter / 2), y: 0))
      ctx.cgContext.addLine(to: CGPoint(x: lenghtLineLetter / 2, y: 0))
      
      // Reset for next letter
      letterStartingPoint += lenghtLineLetter / 2
      
      // Letter W
      var spacingW = letterStartingPoint
      for _ in 0 ..< 2 {
        ctx.cgContext.move(to: CGPoint(x: spacingW, y: 0))
        spacingW += 12
        ctx.cgContext.addLine(to: CGPoint(x: spacingW, y: lenghtLineLetter))
        
        ctx.cgContext.move(to: CGPoint(x: spacingW, y: lenghtLineLetter))
        spacingW += 12
        ctx.cgContext.addLine(to: CGPoint(x: spacingW, y: 0))
      }
      
      // Reset for next letter
      letterStartingPoint = spacingW + spacing
      
      // Letter I
      ctx.cgContext.move(to: CGPoint(x: letterStartingPoint, y: 0))
      ctx.cgContext.addLine(to: CGPoint(x: letterStartingPoint, y: lenghtLineLetter))
      
      // Reset for next letter
      letterStartingPoint += spacing
      
      // Letter N
      var spacingN = letterStartingPoint
      for lineOfLetterN in 0 ..< 3 {
        ctx.cgContext.move(to: CGPoint(x: spacingN, y: 0))
        
        // if we are in the middle of the letter move to the right
        if lineOfLetterN == 1 { spacingN += lenghtLineLetter / 2 }
        
        ctx.cgContext.addLine(to: CGPoint(x: spacingN, y: lenghtLineLetter))
      }
      
      
      ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
      ctx.cgContext.strokePath()
    }
    
    imageView.image = img
  }
}

