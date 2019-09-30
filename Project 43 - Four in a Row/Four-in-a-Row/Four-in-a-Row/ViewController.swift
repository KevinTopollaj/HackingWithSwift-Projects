//
//  ViewController.swift
//  Four-in-a-Row
//
//  Created by Mr.Kevin on 27/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import GameplayKit
import UIKit

class ViewController: UIViewController {

  @IBOutlet var columnButtons: [UIButton]!
  
  // we'll need an array to store each column, and another array to hold all those column arrays
  var placedChips = [[UIView]]()
  // a property tha will be used to create a Board obj
  var board: Board!
  // a property that will be used to create the AI opponent
  var strategist: GKMinmaxStrategist!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    strategist = GKMinmaxStrategist()
    strategist.maxLookAheadDepth = 6
    strategist.randomSource = nil
    
    for _ in 0 ..< Board.width {
      placedChips.append([UIView]())
    }
    
    resetBoard()
  }
  
  func resetBoard() {
    // create an instance of the board object
    board = Board()
    
    strategist.gameModel = board
    
    updateUI()
    
    for i in 0 ..< placedChips.count {
      for chip in placedChips[i] {
        chip.removeFromSuperview()
      }
      placedChips[i].removeAll(keepingCapacity: true)
    }
  }
  
  /// A method that will create an add a chip in to the UI
  func addChip(inColumn column: Int, row: Int, color: UIColor) {
    let button = columnButtons[column]
    let size = min(button.frame.width, button.frame.height / 6)
    let rect = CGRect(x: 0, y: 0, width: size, height: size)
    
    if placedChips[column].count < row + 1 {
      let newChip = UIView()
      newChip.frame = rect
      newChip.isUserInteractionEnabled = false
      newChip.backgroundColor = color
      newChip.layer.cornerRadius = size / 2
      newChip.center = positionForChip(inColumn: column, row: row)
      newChip.transform = CGAffineTransform(translationX: 0, y: -800)
      view.addSubview(newChip)
      
      UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
        newChip.transform = CGAffineTransform.identity
      })
      
      placedChips[column].append(newChip)
    }
  }
  
  /// will position a chip in the ui based on the column and row
  func positionForChip(inColumn column: Int, row: Int) -> CGPoint {
    // 1. It pulls out the UIButton that represents the correct column.
    let button = columnButtons[column]
    // 2. It sets the chip size to be either the width of the column button, or the height of the column button divided by six (for six full rows) – whichever is the lowest.
    let size = min(button.frame.width, button.frame.height / 6)
    // 3. It uses midX to get the horizontal center of the column button, used for the X position of the chip
    let xOffset = button.frame.midX
    // 4. It uses maxY to get the bottom of the column button, then subtracts half the chip size because we're working with the center of the chip.
    var yOffset = button.frame.maxY - size / 2
    // 5. It then multiplies the row by the size of each chip to figure out how far to offset the new chip, and subtracts that from the Y position calculated in 4.
    yOffset -= size * CGFloat(row)
    // 6. Finally, it creates a CGPoint return value by putting together the X offset calculated in step 3 with the Y offset calculated in step 5.
    return CGPoint(x: xOffset, y: yOffset)
  }
  
  // A method that is responsible for updating the title of the view controller to show whose turn it is
  func updateUI() {
    title = "\(board.currentPlayer.name)'s Turn"
    
    if board.currentPlayer.chip == .black {
      startAIMove()
    }
  }
  
  // A method that will get called after every move, and will end the game with an alert if needed, otherwise it will switch players.
  func continueGame() {
    // 1. We create a gameOverTitle optional string set to nil.
    var gameOverTitle: String? = nil
    // 2. If the game is over or the board is full, gameOverTitle is updated to include the relevant status message.
    if board.isWin(for: board.currentPlayer) {
      gameOverTitle = "\(board.currentPlayer.name) Wins!"
    } else if board.isFull() {
      gameOverTitle = "Draw!"
    }
    // 3. If gameOverTitle is not nil (i.e., the game is won or drawn), show an alert controller that resets the board when dismissed.
    if gameOverTitle != nil {
      let alert = UIAlertController(title: gameOverTitle, message: nil, preferredStyle: .alert)
      let alertAction = UIAlertAction(title: "Play Again", style: .default) { [unowned self] (action) in
        self.resetBoard()
      }
      alert.addAction(alertAction)
      present(alert, animated: true)
      return
    }
    // 4. Otherwise, change the current player of the game, then call updateUI() to set the navigation bar title.
    board.currentPlayer = board.currentPlayer.oponent
    updateUI()
  }
  
  @IBAction func makeMove(_ sender: UIButton) {
    let column = sender.tag
    
    if let row = board.nextEmptySlot(in: column) {
      board.add(chip: board.currentPlayer.chip, in: column)
      addChip(inColumn: column, row: row, color: board.currentPlayer.color)
      continueGame()
    }
    
  }
  
  func columnForAIMove() -> Int? {
    if let aiMove = strategist.bestMove(for: board.currentPlayer) as? Move {
      return aiMove.column
    }
    return nil
  }
  
  func makeAIMove(in column: Int) {
    
    columnButtons.forEach { $0.isEnabled = true }
    navigationItem.leftBarButtonItem = nil
    
    if let row = board.nextEmptySlot(in: column) {
      board.add(chip: board.currentPlayer.chip, in: column)
      addChip(inColumn: column, row: row, color: board.currentPlayer.color)
      continueGame()
    }
  }
  
  func startAIMove() {
    
    columnButtons.forEach { $0.isEnabled = false }
    let spinner = UIActivityIndicatorView(style: .gray)
    spinner.startAnimating()
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: spinner)
    
    DispatchQueue.global().async { [unowned self] in
      let strategistTime = CFAbsoluteTimeGetCurrent()
      guard let column = self.columnForAIMove() else { return }
      let delta = CFAbsoluteTimeGetCurrent() - strategistTime
      let aiTimeCeiling = 1.0
      let delay = aiTimeCeiling - delta
      DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        self.makeAIMove(in: column)
      }
    }
  }
  
}

