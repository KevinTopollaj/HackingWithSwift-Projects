//
//  Place.swift
//  PhotoOfThings
//
//  Created by Mr.Kevin on 24/07/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import Foundation
import UIKit

class Place: Codable {
  var name: String
  var image: String
  
  init(name: String, image: String) {
    self.name = name
    self.image = image
  }
}
