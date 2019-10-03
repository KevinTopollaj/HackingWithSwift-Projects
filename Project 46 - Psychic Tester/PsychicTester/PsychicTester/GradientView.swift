//
//  GradientView.swift
//  PsychicTester
//
//  Created by Mr.Kevin on 29/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit

/// @IBDesignable, means that Xcode should build the class and make it draw inside Interface Builder whenever changes are made.
@IBDesignable class GradientView: UIView {
  
  // @IBInspectable, exposes a property from your class as an editable value inside Interface Builder.
  @IBInspectable var topColor: UIColor = UIColor.white
  @IBInspectable var bottomColor: UIColor = UIColor.black
  
  // when iOS asks it what kind of layer to use for drawing it should return CAGradientLayer
  override class var layerClass: AnyClass {
    return CAGradientLayer.self
  }
  
  // when iOS tells the view to layout its subviews it should apply the colors to the gradient.
  override func layoutSubviews() {
    (layer as! CAGradientLayer).colors = [topColor.cgColor, bottomColor.cgColor]
  }
}
