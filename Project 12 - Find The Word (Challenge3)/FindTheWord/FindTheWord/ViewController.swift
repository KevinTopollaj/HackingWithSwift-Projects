//
//  ViewController.swift
//  FindTheWord
//
//  Created by Mr.Kevin on 07/09/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  var scoreLabel: UILabel!
  var wrongAnswersLabel: UILabel!
  var wordToGuessLabel: UILabel!
  var charButtons = [UIButton]()
  var wordToGuess = "test"
  
  var score = 0 {
    didSet {
      scoreLabel.text = "Score: \(score)"
    }
  }
  
  var wrongAnswers = 0 {
    didSet {
      wrongAnswersLabel.text = "Wrong Answers: \(wrongAnswers)"
    }
  }
  
  var level = 0
  
  override func loadView() {
    view = UIView()
    view.backgroundColor = .white
    
    /// UI Elements
    
    scoreLabel = UILabel()
    scoreLabel.translatesAutoresizingMaskIntoConstraints = false
    scoreLabel.textAlignment = .right
    scoreLabel.text = "Score: \(score)"
    scoreLabel.font = UIFont.systemFont(ofSize: 24)
    view.addSubview(scoreLabel)
    
    wrongAnswersLabel = UILabel()
    wrongAnswersLabel.translatesAutoresizingMaskIntoConstraints = false
    wrongAnswersLabel.textAlignment = .center
    wrongAnswersLabel.text = "Wrong Answers: \(wrongAnswers)"
    wrongAnswersLabel.font = UIFont.systemFont(ofSize: 34)
    wrongAnswersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
    view.addSubview(wrongAnswersLabel)
    
    wordToGuessLabel = UILabel()
    wordToGuessLabel.translatesAutoresizingMaskIntoConstraints = false
    wordToGuessLabel.textAlignment = .center
    wordToGuessLabel.text = "????"
    wordToGuessLabel.font = UIFont.systemFont(ofSize: 48)
    view.addSubview(wordToGuessLabel)
    
    let charButtonsView = UIView()
    charButtonsView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(charButtonsView)
    
    /// Constraints
    
    NSLayoutConstraint.activate([
      scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
      scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 0),
      wrongAnswersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 40),
      wrongAnswersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      wrongAnswersLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
      wordToGuessLabel.topAnchor.constraint(equalTo: wrongAnswersLabel.bottomAnchor, constant: 20),
      wordToGuessLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      wordToGuessLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
      charButtonsView.widthAnchor.constraint(equalToConstant: 650),
      charButtonsView.heightAnchor.constraint(equalToConstant: 300),
      charButtonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      charButtonsView.topAnchor.constraint(equalTo: wordToGuessLabel.bottomAnchor, constant: 80),
      charButtonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -80)
      ])
    
    let width = 50
    let height = 100
    
    for row in 0..<2 {
      for column in 0..<13 {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 36)
        button.setTitle("A", for: .normal)
        button.widthAnchor.constraint(equalToConstant: CGFloat(width))
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
        button.frame = frame
        
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 8
        
        charButtonsView.addSubview(button)
        charButtons.append(button)
      }
    }
    
    for (index, char) in "abcdefghijklmnopqrstuvwxyz".enumerated() {
      charButtons[index].setTitle(String(char).uppercased(), for: .normal)
    }
    
  }
  
  func loadLevel() {
    if let fileURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
      if let contentURL = try? String(contentsOf: fileURL) {
        let words = contentURL.components(separatedBy: "\n")
        
        if level == words.count - 1 {
          let ac = UIAlertController(title: "Congratulation you found all the words in the game!", message: nil, preferredStyle: .alert)
          ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
          ac.addAction(UIAlertAction(title: "Restart Game", style: .default) { [weak self] _ in
            self?.newGame()
          })
          present(ac, animated: true)
        }
        
        wordToGuess = words[level]
      }
    }
    
    for button in charButtons {
      button.isHidden = false
    }
    
    wordToGuessLabel.text = String.init(repeating: "?", count: wordToGuess.count)
  }
  
  func newGame() {
    score = 0
    wrongAnswers = 0
    level = 0
    loadLevel()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    newGame()
  }


  @objc func buttonTapped(_ sender: UIButton) {
    guard let char = sender.titleLabel?.text else { return }
    
    if wordToGuess.contains(char.lowercased()) {
      var words = wordToGuessLabel.text?.map { $0.uppercased() }
      
      for (index, item) in wordToGuess.enumerated() {
        if String(item) == char.lowercased() {
          words![index] = char.uppercased()
        }
      }
      
      wordToGuessLabel.text = words?.joined()
      
      sender.isHidden = true
      
      if wordToGuessLabel.text?.lowercased() == wordToGuess {
         let ac = UIAlertController(title: "Congratulation you guessed the word - \(wordToGuess.uppercased()) !", message: nil, preferredStyle: .alert)
        
        level += 1
        score += 1
        wrongAnswers = 0
        loadLevel()
       
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
      }
    } else {
      wrongAnswers += 1
      sender.isHidden = true
    }
    
    if wrongAnswers == 7 {
      let ac = UIAlertController(title: "That was not the right word!", message: nil, preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "Try Again!", style: .default) { [weak self] _ in
        self?.wrongAnswers = 0
        if self?.score == 0 {
          self?.score = 0
        } else {
          self?.score -= 1
        }
        self?.loadLevel()
      })
      present(ac, animated: true)
    }
  }
  
}

