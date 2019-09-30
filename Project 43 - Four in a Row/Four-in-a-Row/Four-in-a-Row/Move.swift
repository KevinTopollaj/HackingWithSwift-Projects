//
//  Move.swift
//  Four-in-a-Row
//
//  Created by Mr.Kevin on 27/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import GameplayKit
import UIKit

class Move: NSObject, GKGameModelUpdate {
  
  var value: Int = 0
  var column: Int
  
  init(column: Int) {
    self.column = column
  }
  
}
