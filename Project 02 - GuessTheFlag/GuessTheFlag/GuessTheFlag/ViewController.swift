//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by Mr.Kevin on 06/07/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  /// Outlets
  @IBOutlet var button1: UIButton!
  @IBOutlet var button2: UIButton!
  @IBOutlet var button3: UIButton!
  
  /// Properties
  var countries = [String]()
  var correctAnswer = 0
  var score = 0
  var totalQuestionAsked = -1
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // add a navigation bar button
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showScore))
    
    // populate the array with all the countries name
    countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
    
    // call the methods
    buttonDesign()
    askQuestion()
  }
  
  // Navigation Bar Button Method
  @objc func showScore() {
    let ac = UIAlertController(title: "Actual Score", message: "Your actual score is \(score)", preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(ac, animated: true)
  }
  
  /// Methods
  
  fileprivate func buttonDesign() {
    // give buttons a border width
    button1.layer.borderWidth = 1
    button2.layer.borderWidth = 1
    button3.layer.borderWidth = 1
    
    // give the border a color
    button1.layer.borderColor = UIColor.lightGray.cgColor
    button2.layer.borderColor = UIColor.lightGray.cgColor
    button3.layer.borderColor = UIColor.lightGray.cgColor
  }
  
  func askQuestion(action: UIAlertAction! = nil) {
    // shuffle the countries array to get different items each time
    countries.shuffle()
    
    // set an image for each button
    button1.setImage(UIImage(named: countries[0]), for: .normal)
    button2.setImage(UIImage(named: countries[1]), for: .normal)
    button3.setImage(UIImage(named: countries[2]), for: .normal)
    
    // set the correctAnswer property a random number in the range 0...2
    correctAnswer = Int.random(in: 0...2)
    
    // add a title to the navigation bar
    title = countries[correctAnswer].uppercased() + "  (Score: \(score))"
    
    // increase the totalQuestionAsked every time we ask a question
    totalQuestionAsked += 1
    
    if totalQuestionAsked >= 5 {
      title = ""
      let ac = UIAlertController(title: "Game Over!", message: "Your Total Score is \(score)", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "New Game", style: .default, handler: resetTheGame))
      present(ac, animated: true)
    }
  }
  
  func resetTheGame(action: UIAlertAction! = nil) {
    score = 0
    totalQuestionAsked = 0
    title = countries[correctAnswer].uppercased() + "  (Score: \(score))"
  }
  
  /// Actions
  
  // create a buttonTapped action that will be used by all 3 buttons
  @IBAction func buttonTaped(_ sender: UIButton) {
    var title: String
    // 1- check if the answer was correct
    if sender.tag == correctAnswer {
      // 2- Adjust navigation bar title and the player score up or down
      title = "Correct!"
      score += 1
    } else {
      title = "Wrong! That's the flag of \(countries[sender.tag].uppercased())."
      if score > 0 {
        score -= 1
      } else {
        score = 0
      }
    }
    
    // 3- Show a message that will tell the user their score by creating an Alert
    let alertController = UIAlertController(title: title, message: "Your score is  \(score).", preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
    present(alertController, animated: true)
  }
  
}

