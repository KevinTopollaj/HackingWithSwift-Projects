//
//  CardViewController.swift
//  PsychicTester
//
//  Created by Mr.Kevin on 29/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {
  
  // a property used to send data back to the ViewController
  weak var delegate: ViewController!
  // properties that will represent the 2 states of a card
  var front: UIImageView!
  var back: UIImageView!
  // a property that will check if the card is a star
  var isCorrect = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 1. Give the view a precise size of 100x140.
    view.bounds = CGRect(x: 0, y: 0, width: 100, height: 140)
    // 2. Add two image views, one for the card back and one for the front.
    front = UIImageView(image: UIImage(named: "cardBack"))
    back = UIImageView(image: UIImage(named: "cardBack"))
    
    view.addSubview(front)
    view.addSubview(back)
    // 3. Set the front image view to be hidden by default.
    front.isHidden = true
    back.alpha = 0
    // 4. Set the back image view to have an alpha value of 0 by default, fading up to 1 with an animation.
    UIView.animate(withDuration: 0.2) {
      self.back.alpha = 1
    }
    
    // create a tap gesture recognizer and add it to the back image view
    let tap = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
    back.isUserInteractionEnabled = true
    back.addGestureRecognizer(tap)
    
    perform(#selector(wiggle), with: nil, afterDelay: 1)

  }
  
  @objc func cardTapped() {
    // we need each card to decide if it was tapped, but we need to pass control onto the ViewController class to act upon the tap
    delegate.cardTapped(self)
  }
  
  @objc func wasntTapped() {
    UIView.animate(withDuration: 0.7) {
      self.view.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)
      self.view.alpha = 0
    }
  }
  
  // animate a 3D flip effect from the card back to the card front.
  func wasTapped() {
    UIView.transition(with: view, duration: 0.7, options: [.transitionFlipFromRight], animations: { [unowned self] in
        self.back.isHidden = true
        self.front.isHidden = false
    })
  }
  
  
  @objc func wiggle() {
    if Int.random(in: 0...3) == 1 {
      UIView.animate(withDuration: 0.2, delay: 0, options: .allowUserInteraction, animations: {
        self.back.transform = CGAffineTransform(scaleX: 1.01, y: 1.01)
      }) { _ in
        self.back.transform = CGAffineTransform.identity
      }
      perform(#selector(wiggle), with: nil, afterDelay: 8)
    } else {
      perform(#selector(wiggle), with: nil, afterDelay: 2)
    }
  }
  
  
}
