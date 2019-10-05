//
//  PlayData.swift
//  UnitTestingWithXCTest
//
//  Created by Mr.Kevin on 30/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import Foundation

class PlayData {
  // an array that will be populated with the words from the plays.txt file.
  var allWords = [String]()
  
  // NSCountedSet is a set data type, which means that items can only be added once.
  var wordsCount: NSCountedSet!
  
  // an array that will contain filtered words and can only be changed by the PlayData class
  private(set) var filteredWords = [String]()
  
  init() {
    if let path = Bundle.main.path(forResource: "plays", ofType: "txt") {
      if let plays = try? String(contentsOfFile: path) {
        allWords = plays.components(separatedBy: CharacterSet.alphanumerics.inverted)
        allWords = allWords.filter { $0 != "" }
        
        // creates a counted set from all the words, which immediately de-duplicates and counts them all.
        wordsCount = NSCountedSet(array: allWords)
        // sort the items to put the most used words first
        let sorted = wordsCount.allObjects.sorted { wordsCount.count(for: $0) > wordsCount.count(for: $1) }
        // updates the allWords array to be the words from the counted set, thus ensuring they are unique.
        allWords = sorted as! [String]
        
        applyUserFilter("swift")
//        filteredWords = allWords
      }
    }
  }
  
  func applyUserFilter(_ input: String) {
    if let userNumber = Int(input) {
      // we got an Int, create an array out of words with a count great or equal to the number the user entered
//      filteredWords = allWords.filter { self.wordsCount.count(for: $0) >= userNumber}
      applyFilter { self.wordsCount.count(for: $0) >= userNumber }
    } else {
      // we got a String, create an array out of words that contain the user's text as a substring
//      filteredWords = allWords.filter { $0.range(of: input, options: .caseInsensitive) != nil }
      applyFilter { $0.range(of: input, options: .caseInsensitive) != nil}
    }
  }
  
  // a method that will be used to apply a filter
  func applyFilter(_ filter: (String) -> Bool) {
    filteredWords = allWords.filter(filter)
  }
  
}
