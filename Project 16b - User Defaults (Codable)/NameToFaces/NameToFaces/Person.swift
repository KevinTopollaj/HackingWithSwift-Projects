//
//  Person.swift
//  NameToFaces
//
//  Created by Mr.Kevin on 20/07/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import Foundation
import  UIKit

// A class to hold data for our app.
// NSObject is what's called a universal base class for all Cocoa Touch classes. That means all UIKit classes ultimately come from NSObject, including all of UIKit.
class Person: NSObject, Codable {
  var name: String
  var image: String
  
  init(name: String, image: String) {
    self.name = name
    self.image = image
  }
}
