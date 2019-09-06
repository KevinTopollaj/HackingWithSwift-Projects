//
//  ViewController.swift
//  7SwiftyWords
//
//  Created by Mr.Kevin on 14/07/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  /// Properties
  var cluesLabel: UILabel!
  var answerLabel: UILabel!
  var currentAnswer: UITextField!
  var scoreLabel: UILabel!
  var letterButtons = [UIButton]()
  // create an array that will store the buttons that are currently being used to spell an answer
  var activatedButtons = [UIButton]()
  // create an array that will contain all possible solutions
  var solutions = [String]()
  // a property that will hold the score
  var score = 0 {
    didSet {
      scoreLabel.text = "Score: \(score)"
    }
  }
  
  var totalScore = 7
  // a property that will hold the level
  var level = 1
  
  // method that will load our custom view
  override func loadView() {
    view = UIView()
    view.backgroundColor = .white
    
    // create score label
    scoreLabel = UILabel()
    scoreLabel.translatesAutoresizingMaskIntoConstraints = false
    scoreLabel.textAlignment = .right
    scoreLabel.text = "Score: 0"
    // add it to the view
    view.addSubview(scoreLabel)
    
    // create clue label
    cluesLabel = UILabel()
    cluesLabel.translatesAutoresizingMaskIntoConstraints = false
    cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
    cluesLabel.font = UIFont.systemFont(ofSize: 24)
    cluesLabel.text = "CLUES"
    cluesLabel.numberOfLines = 0
    // add it to the view
    view.addSubview(cluesLabel)
    
    // create answer label
    answerLabel = UILabel()
    answerLabel.translatesAutoresizingMaskIntoConstraints = false
    answerLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
    answerLabel.font = UIFont.systemFont(ofSize: 24)
    answerLabel.text = "ANSWERS"
    answerLabel.numberOfLines = 0
    answerLabel.textAlignment = .right
    // add it to the view
    view.addSubview(answerLabel)
    
    // create the current answer text field
    currentAnswer = UITextField()
    currentAnswer.translatesAutoresizingMaskIntoConstraints = false
    currentAnswer.placeholder = "Tapp Letters To Guess"
    currentAnswer.textAlignment = .center
    currentAnswer.font = UIFont.systemFont(ofSize: 40)
    currentAnswer.isUserInteractionEnabled = false
    // add it to the view
    view.addSubview(currentAnswer)
    
    // create 2 buttons under the text field
    let submit = UIButton(type: .system)
    submit.translatesAutoresizingMaskIntoConstraints = false
    submit.setTitle("SUBMIT", for: .normal)
    submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
    view.addSubview(submit)
    
    let clear = UIButton(type: .system)
    clear.translatesAutoresizingMaskIntoConstraints = false
    clear.setTitle("CLEAR", for: .normal)
    clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
    view.addSubview(clear)
    
    // create a buttons view that will contain our 20 buttons
    let buttonsView = UIView()
    buttonsView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(buttonsView)
    
    // put all the constraints in one place
    NSLayoutConstraint.activate([
      // scoreLabel constraints
      scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
      scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 0),
      // clues label constraints
      cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
      cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
      cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
      // answers label constraints
      answerLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
      answerLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
      answerLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
      answerLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
      // current answer text field constraints
      currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
      currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
      // submit and clear buttons constraints
      submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
      submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
      submit.heightAnchor.constraint(equalToConstant: 44),
      clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
      clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
      clear.heightAnchor.constraint(equalToConstant: 44),
      // buttons view constraints
      buttonsView.widthAnchor.constraint(equalToConstant: 750),
      buttonsView.heightAnchor.constraint(equalToConstant: 320),
      buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
      buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
      ])
    
    // width an height for the buttons inside the buttonsView
    let width = 150
    let height = 80
    
    // create 20 buttons as a 4x5 grid
    for row in 0..<4 {
      for col in 0..<5 {
        // create a button and give it a font size
        let letterButton = UIButton(type: .system)
        letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
        // give the button some temporary text so we can see it
        letterButton.setTitle("AAA", for: .normal)
        // add a target to the buttons
        letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
        // * add border to the button
        letterButton.layer.borderWidth = 1
        letterButton.layer.borderColor = UIColor.lightGray.cgColor
        letterButton.layer.cornerRadius = 8
        // calculate the frame of the button using the row and col
        let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
        letterButton.frame = frame
        // add it to the buttonsView
        buttonsView.addSubview(letterButton)
        // add it to letterButtons array
        letterButtons.append(letterButton)
      }
    }
  }
  
  // method that will load the level data into the game
  func loadLevel() {
    // will store all the level's clues
    var clueString = ""
    // will store how many letters each answer is
    var solutionString = ""
    // an array to store all letter groups
    var letterBits = [String]()
    
    // Use GCD to load the level on a background thread
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      // get the file1.txt url
      if let levelFileURL = Bundle.main.url(forResource: "level\(self?.level ?? 1)", withExtension: "txt") {
        // create a big String with all the elements in the level1.txt
        if let levelContents = try? String(contentsOf: levelFileURL) {
          // create an array form the big String levelContents with each element that get separated by a \n
          var lines = levelContents.components(separatedBy: "\n")
          lines.shuffle()
          
          for (index, line) in lines.enumerated() {
            // line -> HA|UNT|ED: Ghosts in residence
            
            // parts will separate the string at :
            let parts = line.components(separatedBy: ": ")
            // will take the first part: HA|UNT|ED
            let answer = parts[0]
            // will take the second part: Ghosts in residence
            let clue = parts[1]
            // 1. Ghosts in residence
            clueString += "\(index + 1). \(clue)\n"
            // solutionWord will be the word HAUNTED
            let solutionWord = answer.replacingOccurrences(of: "|", with: "")
            // get the number of letters and add them to the solutionString
            solutionString += "\(solutionWord.count) letters\n"
            // add the solutionWord to the solutions array: HAUNTED
            self?.solutions.append(solutionWord)
            // turn the string "HA|UNT|ED" into an array of three elements, then add all three to our letterBits array.
            let bits = answer.components(separatedBy: "|")
            letterBits += bits
          }
        }
      }
    }
    
    
    /// Configure the buttons and labels
    
    // Use GCD to update the UI on the main thread
    DispatchQueue.main.async { [weak self] in
      // add the clueLabel and answerLabel text
      self?.cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
      self?.answerLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
      
      letterBits.shuffle()
      
      // set titles to the buttons
      if self?.letterButtons.count == letterBits.count {
        for i in 0 ..< self!.letterButtons.count {
          self?.letterButtons[i].setTitle(letterBits[i], for: .normal)
        }
      }
    }
    
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    loadLevel()

  }

  /// Methods that will be triggerd by our buttons
  
  //activatedButtons array is being used to hold all buttons that the player has tapped before submitting their answer. This is important because we're hiding each button as it is tapped, so if the user taps "Clear" we need to know which buttons are currently in use so we can re-show them.
  
  @objc func letterTapped(_ sender: UIButton){
    // get the button title from the tapped button
    guard let buttonTitle = sender.titleLabel?.text else { return }
    // add the button title to the text field currentAnswer
    currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
    // Appends the button to the activatedButtons array
    activatedButtons.append(sender)
    // hide the button that was tapped
//    sender.isHidden = true
    
    // use animation to hide the buttons that are tapped
    UIView.animate(withDuration: 0.6, delay: 0, options: [], animations: {
      sender.alpha = 0
    }) { (finished) in
      sender.isHidden = true
    }
  }
  
  @objc func clearTapped(_ sender: UIButton) {
    // empty the text field
    currentAnswer.text = ""
    // show all the buttons text that are inside the activeButtons array
    for btn in activatedButtons {
      UIView.animate(withDuration: 0.6, delay: 0, options: [], animations: {
        btn.alpha = 1
      }) { (finished) in
        btn.isHidden = false
      }
    }
    // remover all buttons text that are inside the activeButtons array
    activatedButtons.removeAll()
  }
  
  @objc func submitTapped(_ sender: UIButton) {
    // get the text from the text field
    guard let answerText = currentAnswer.text else { return }
    
    // use firstIndex(of:) to search through the solutions array for an item and, if it finds it, tells us its position.
    if let solutionPosition = solutions.firstIndex(of: answerText) {
      // remove all elements from the activateButtons
      activatedButtons.removeAll()
      // create an array with each answer label ["7 letters", "6 letters",...]
      var splitAnswer = answerLabel.text?.components(separatedBy: "\n")
      // the "7 letters" will be replaced with HAUNTED
      splitAnswer?[solutionPosition] = answerText
      // change the answersLabel to the correct answer by joining all the bits
      answerLabel.text = splitAnswer?.joined(separator: "\n")
      // empty the text field
      currentAnswer.text = ""
      
      // add the score
      score += 1
      
      // if all the solutions are found
      if score % totalScore == 0 {
        let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
        present(ac, animated: true)
      }
    } else {
      if score > 0 {
        totalScore -= 1
        score -= 1
      }
      let ac = UIAlertController(title: "Wrong!", message: "The word is not correct", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK", style: .default))
      present(ac, animated: true)
    }
  }
  
  func levelUp(action: UIAlertAction) {
    // add one to the level
    level += 1
    // remove all the words from the solution array
    solutions.removeAll(keepingCapacity: true)
    // load the new level
    loadLevel()
    // show all the buttons titles
    for btn in letterButtons {
      UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
        btn.alpha = 1
      }) { (finished) in
        btn.isHidden = false
      }
    }
  }

}

