//
//  Player.swift
//  Four-in-a-Row
//
//  Created by Mr.Kevin on 27/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import GameplayKit
import UIKit

/// Will be data model two for the game, players for storing their color and name
class Player: NSObject, GKGameModelPlayer {
  /// Properties
  // The chip color of the player, either .red, .black, or .none.
  var chip: ChipColor
  // The drawing color the player, set to a UIColor.
  var color: UIColor
  // The name of the player, which will be either "Red" or "Black".
  var name: String
  // A GameplayKit playerId property, which we'll just set to the raw value of their chip type.
  var playerId: Int
  // A static array of two players, red and black.
  static var allPlayers = [Player(chip: .red), Player(chip: .black)]
  
  // create the initializer
  init(chip: ChipColor) {
    self.chip = chip
    self.playerId = chip.rawValue
    
    if chip == .red {
      color = .red
      name = "Red"
    } else {
      color = .black
      name = "Black"
    }
    
    super.init()
  }
  
  // create a computed property that will give us the oponent player based on the current player
  var oponent: Player {
    if chip == .red {
      return Player.allPlayers[1]
    } else {
      return Player.allPlayers[0]
    }
  }
  
}
