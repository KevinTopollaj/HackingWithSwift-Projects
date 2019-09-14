//
//  ViewController.swift
//  Animation
//
//  Created by Mr.Kevin on 26/07/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  // declare an imageView
  var imageView: UIImageView!
  // a property that will contain the current animation
  var currentAnimation = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // initialize the imageView with an image
    imageView = UIImageView(image: UIImage(named: "penguin"))
    // position the image in the center of the screen
    imageView.center = CGPoint(x: 512, y: 384)
    // add it to the view
    view.addSubview(imageView)
  }

  @IBAction func tapped(_ sender: UIButton) {
    // hide the Tap button when it is tapped
    sender.isHidden = true
    
    // add Animations
    UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
      
      switch self.currentAnimation {
      case 0:
        self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
      case 1:
        self.imageView.transform = .identity // clears out any transform
      case 2:
        self.imageView.transform = CGAffineTransform(translationX: -256, y: -256)
      case 3:
        self.imageView.transform = .identity
      case 4:
        self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
      case 5:
        self.imageView.transform = .identity
      case 6:
        self.imageView.alpha = 0.1
        self.imageView.backgroundColor = .gray
      case 7:
        self.imageView.alpha = 1
        self.imageView.backgroundColor = .clear
        
      default:
        break
      }
      
    }) { (finished) in
      
      // show the Tap button when the animation finishes
      sender.isHidden = false
    }
    
    // add 1 to the value of currentAnimation until it reaches 7, at which point it will set it back to 0.
    currentAnimation += 1
    if currentAnimation > 7 {
      currentAnimation = 0
    }
  }
  
}

