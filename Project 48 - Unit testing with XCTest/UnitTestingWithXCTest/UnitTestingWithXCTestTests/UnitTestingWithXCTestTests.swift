//
//  UnitTestingWithXCTestTests.swift
//  UnitTestingWithXCTestTests
//
//  Created by Mr.Kevin on 30/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import XCTest
@testable import UnitTestingWithXCTest

class UnitTestingWithXCTestTests: XCTestCase {
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testAllWordsLoaded() {
    let playData = PlayData()
    XCTAssertEqual(playData.allWords.count, 18440, "allWords was not 18440")
  }
  
  func testWordCountsAreCorrect() {
    let playData = PlayData()
    XCTAssertEqual(playData.wordsCount.count(for: "home"), 174, "Home does not appear 174 times")
    XCTAssertEqual(playData.wordsCount.count(for: "fun"), 4, "Fun does not appear 4 times")
    XCTAssertEqual(playData.wordsCount.count(for: "mortal"), 41, "Mortal does not appear 41 times")
  }
  
  func testUserFilterWorks() {
    let playData = PlayData()
    
    playData.applyUserFilter("100")
    XCTAssertEqual(playData.filteredWords.count, 495)
    
    playData.applyUserFilter("1000")
    XCTAssertEqual(playData.filteredWords.count, 55)
    
    playData.applyUserFilter("10000")
    XCTAssertEqual(playData.filteredWords.count, 1)
    
    playData.applyUserFilter("test")
    XCTAssertEqual(playData.filteredWords.count, 56)
    
    playData.applyUserFilter("swift")
    XCTAssertEqual(playData.filteredWords.count, 7)
    
    playData.applyUserFilter("objective-c")
    XCTAssertEqual(playData.filteredWords.count, 0)
    
  }
  
  // a performance test
  func testWordsLoadQuickly() {
    measure {
      _ = PlayData()
    }
  }
}
