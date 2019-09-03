//
//  ViewController.swift
//  WordScramble
//
//  Created by Mr.Kevin on 09/07/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
  
  /// Properties
  // will contain all the words that are in the start.txt
  var allWords = [String]()
  // will contain the words used by the player
  var usedWords = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(restartGame))
    
    // find the path for our start.txt file
    if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
      // load the content of that file as a long string
      if let startWords = try? String(contentsOf: startWordsURL) {
        // split the stringWords in to an array string based where we find a line break \n
        allWords = startWords.components(separatedBy: "\n")
      }
    }
    
    if allWords.isEmpty {
      allWords = ["silkworm"]
    }
    
    if usedWords.isEmpty {
      startGame()
    }
    
  }
  
  /// Method that will start the game
  func startGame() {
    // sets our view controller's title to be a random word in the array
    title = allWords.randomElement()
    // removes all values from the usedWords array, which we'll be using to store the player's answers so far.
    usedWords.removeAll(keepingCapacity: true)
    // will reload the rows and section in the tableView
    tableView.reloadData()
  }
  
  /// Method that is used by the Nav Bar Button
  @objc func promptForAnswer() {
    let alertController = UIAlertController (title: "Enter answer", message: nil, preferredStyle: .alert)
    // add a TextField to the Alert Controller
    alertController.addTextField()
    
    // create an action whith a handler using closures
    let submitAction = UIAlertAction(title: "Submit", style: .default) {
      [weak self, weak alertController] _ in
      // get the text from the TextField
      guard let answer = alertController?.textFields?[0].text else { return }
      // send the text that we get from the TextField to the submit method
      self?.submit(answer)
    }
    
    alertController.addAction(submitAction)
    present(alertController, animated: true)
  }
  
  @objc func restartGame() {
    startGame()
  }
  
  /// Method that will submit the user Answer
  func submit(_ answer: String) {
    // take the answer and make it lowercasse
    let lowerAnswer = answer.lowercased()
    
    // chek if the answer passes all conditions
    if isPossible(word: lowerAnswer) {
      if isOriginal(word: lowerAnswer) {
        if isReal(word: lowerAnswer) {
          // add the answer a the 0 index
          usedWords.insert(lowerAnswer, at: 0)
          // create an indexPath and insert it in to the tableView as a row
          let indexPath = IndexPath(row: 0, section: 0)
          tableView.insertRows(at: [indexPath], with: .automatic)
          // If the user enters a valid answer, a call to return forces Swift to exit the method immediately once the table has been updated.
          return
        } else {
          showErrorMessage(errorTitle: "Word not recognised", errorMessage: "You can't just make them up, you know!")
        }
      } else {
        showErrorMessage(errorTitle: "Word used already", errorMessage: "Be more original!")
      }
    } else {
      guard let title = title?.lowercased() else { return }
      showErrorMessage(errorTitle: "Word not possible", errorMessage: "You can't spell that word from \(title)")
    }
    
  }
  
  /// Method that will handle the Errors and give the user an specific alert
  func showErrorMessage(errorTitle: String, errorMessage: String) {
    let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default))
    present(ac, animated: true)
  }
  
  /// Method will check if the word is possible
  func isPossible(word: String) -> Bool {
    // creates a tempWord from the title
    guard var tempWord = title?.lowercased() else { return false }
    
    // gets each letter of the word
    for letter in word {
      // gets the possition of each letter in the tempWord
      if let possition = tempWord.firstIndex(of: letter) {
        // and removes a letter in that possition
        tempWord.remove(at: possition)
      } else {
        return false
      }
    }
    // The method ends with return true, because this line is reached only if every letter in the user's word was found in the start word no more than once.
    return true
  }
  
  /// Method will check if the word is original
  func isOriginal(word: String) -> Bool {
    // compare the start word against their input word and return false if they are the same.
    guard let startWord = title?.lowercased() else { return false }
    if startWord == word {
      return false
    }
    // which will check whether our usedWords array already contains the word that was provided.
    return !usedWords.contains(word)
  }
  
  /// Method will check if the word is real
  func isReal(word: String) -> Bool {
    // if the word is less than 3 letters return false
    if word.count < 3 {
      return false
    }
    
    // an iOS class that is designed to spot spelling errors
    let checker = UITextChecker()
    // NSRange is used to store a string range, which is a value that holds a start position and a length. We want to examine the whole string, so we use 0 for the start position and the string's length for the length.
    let range = NSRange(location: 0, length: word.utf16.count)
    // Calling rangeOfMisspelledWord(in:) returns another NSRange structure, which tells us where the misspelling was found.
    let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
    // Usually location would tell you where the misspelling started, but NSNotFound is telling us the word is spelled correctly
    return misspelledRange.location == NSNotFound
  }
  
  /// TableView Methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return usedWords.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
    cell.textLabel?.text = usedWords[indexPath.row]
    return cell
  }

}

