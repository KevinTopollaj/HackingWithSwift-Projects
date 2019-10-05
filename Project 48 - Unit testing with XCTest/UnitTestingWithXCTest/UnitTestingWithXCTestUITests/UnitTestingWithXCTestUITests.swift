//
//  UnitTestingWithXCTestUITests.swift
//  UnitTestingWithXCTestUITests
//
//  Created by Mr.Kevin on 30/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import XCTest

class UnitTestingWithXCTestUITests: XCTestCase {
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
    
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    XCUIApplication().launch()
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testInitialTestIsCorrect() {
    // run our app and get our table
    let table = XCUIApplication().tables
    // check that the table contains 7 cell when the app first runs
    XCTAssertEqual(table.cells.count, 7, "There should be 7 rows initially")
  }
  
  func testUserFilteringByString() {

    let app = XCUIApplication()
    
    app.buttons["Search"].tap()
    
    let filterAlert = app.alerts
    let textField = filterAlert.textFields.element
    textField.typeText("test")
    filterAlert.buttons["Filter"].tap()
    
    XCTAssertEqual(app.tables.cells.count, 56, "There should be 56 words matching 'test'")
    
  }
  
  func testUserFilterintByInt() {
    let app = XCUIApplication()
    
    app.buttons["Search"].tap()
    
    let filterAlert = app.alerts
    let textField = filterAlert.textFields.element
    textField.typeText("1000")
    filterAlert.buttons["Filter"].tap()
    
    XCTAssertEqual(app.tables.cells.count, 55, "There should be 55 words matching '1000'")
  }
  
}
