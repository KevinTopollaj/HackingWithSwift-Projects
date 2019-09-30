//
//  Board.swift
//  Four-in-a-Row
//
//  Created by Mr.Kevin on 27/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import GameplayKit
import UIKit

// and one for a "move" (for storing the position of one valid move in the game.)

enum ChipColor: Int {
  case none = 0
  case red
  case black
}

/// Will be data model one for the game, board that stores the complete game state
class Board: NSObject, GKGameModel {
  // two properties: one for tracking the width of the board, and one to track the height.
  static var width = 7
  static var height = 6
  
  var slots = [ChipColor]()
  
  var currentPlayer: Player
  
  var players: [GKGameModelPlayer]? {
    return Player.allPlayers
  }
  var activePlayer: GKGameModelPlayer? {
    return currentPlayer
  }
  
  // Will be used to initialize a Board object with all slots being empty
  override init() {
    currentPlayer = Player.allPlayers[0]
    
    for _ in 0 ..< Board.width * Board.height {
      slots.append(.none)
    }
    super.init()
  }
  
  // A method used to read the chip color of a specific slot
  func chip(inColumn column: Int, row: Int) -> ChipColor {
    return slots[row + column * Board.height]
  }
  
  // A method used to set the chip color of a specific slot
  func set(chip: ChipColor, in column: Int, row: Int) {
    slots[row + column * Board.height] = chip
  }
  
  // A helper method which will return the first row number that contains no chips in a specific column
  func nextEmptySlot(in column: Int) -> Int? {
    for row in 0 ..< Board.height {
      if chip(inColumn: column, row: row) == .none {
        return row
      }
    }
    return nil
  }
  
  // A method that will check if a player can move in a particular column
  func canMove(in column: Int) -> Bool {
    return nextEmptySlot(in: column) != nil
  }
  
  // A method that will add a chip in a column
  func add(chip: ChipColor, in column: Int) {
    if let row = nextEmptySlot(in: column) {
      set(chip: chip, in: column, row: row)
    }
  }
  
  // A method that will determine if the board is full of pieces
  func isFull() -> Bool {
    for column in 0 ..< Board.width {
      if canMove(in: column) {
        return false
      }
    }
    return true
  }
  
  // A method that will determine if a particular player has won
  func isWin(for player: GKGameModelPlayer) -> Bool {
    let chip = (player as! Player).chip
    
    for row in 0 ..< Board.height {
      for col in 0 ..< Board.width {
        if squaresMatch(initialChip: chip, row: row, col: col, moveX: 1, moveY: 0) {
          return true
        } else if squaresMatch(initialChip: chip, row: row, col: col, moveX: 0, moveY: 1) {
          return true
        } else if squaresMatch(initialChip: chip, row: row, col: col, moveX: 1, moveY: 1) {
          return true
        } else if squaresMatch(initialChip: chip, row: row, col: col, moveX: 1, moveY: -1) {
          return true
        }
      }
    }
    
    return false
  }
  
  // A method that will determine when 4 chips of the same color are in a win pattern for every direction
  func squaresMatch(initialChip: ChipColor, row: Int, col: Int, moveX: Int, moveY: Int) -> Bool {
    
    // bail out early if we can't win from here
    if row + (moveY * 3) < 0 { return false }
    if row + (moveY * 3) >= Board.height { return false }
    if col + (moveX * 3) < 0 { return false }
    if col + (moveX * 3) >= Board.width { return false }
    
    // still here? Check every square
    if chip(inColumn: col, row: row) != initialChip { return false }
    if chip(inColumn: col + moveX, row: row + moveY) != initialChip { return false }
    if chip(inColumn: col + (moveX * 2), row: row + (moveY * 2)) != initialChip { return false }
    if chip(inColumn: col + (moveX * 3), row: row + (moveY * 3)) != initialChip { return false }
    
    return true
  }
  
  /// Methods to our game models to enable an AI to make choices.
  
  func copy(with zone: NSZone? = nil) -> Any {
    let copy = Board()
    copy.setGameModel(self)
    return copy
  }
  
  func setGameModel(_ gameModel: GKGameModel) {
    if let board = gameModel as? Board {
      slots = board.slots
      currentPlayer = board.currentPlayer
    }
  }
  
  func gameModelUpdates(for player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
      // 1 We optionally downcast our GKGameModelPlayer parameter into a Player object.
      if let playerObject = player as? Player {
        // 2 If the player or their opponent has won, return nil to signal no moves are available.
        if isWin(for: playerObject) || isWin(for: playerObject.oponent) { return nil }
        // 3 Otherwise, create a new array that will hold Move objects.
        var moves = [Move]()
        // 4 Loop through every column in the board, asking whether the player can move in that column.
        for column in 0 ..< Board.width {
          if canMove(in: column) {
            // 5 If so, create a new Move object for that column, and add it to the array.
            moves.append(Move(column: column))
          }
        }
        // 6 Finally, return the array to tell the AI all the possible moves it can make.
        return moves
      }
      return nil
  }
  
  func apply(_ gameModelUpdate: GKGameModelUpdate) {
    if let move = gameModelUpdate as? Move {
      add(chip: currentPlayer.chip, in: move.column)
      currentPlayer = currentPlayer.oponent
    }
  }
  
  func score(for player: GKGameModelPlayer) -> Int {
    if let playerObject = player as? Player {
      if isWin(for: playerObject) {
        return 1000
      } else if isWin(for: playerObject.oponent) {
        return -1000
      }
    }
    return 0
  }
}
