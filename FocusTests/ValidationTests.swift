//
//  ValidationTests.swift
//  FocusTests
//
//  Created by Scott Bolin on 8/20/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import XCTest
@testable import Focus

class ValidationTests: XCTestCase {
  
  var oldText: String!
  var newText: String!
  let validation = Validation()
  var isValid: Bool!

    override func setUp() {
    }

    override func tearDown() {
    }
  
  func testOldTextEqualsNewText() {
    oldText = "Test"
    newText = "Test"
    isValid = validation.validatedText(newText: oldText, oldText: newText)
    XCTAssertFalse(isValid)
  }
  
  func testNewTextIsBlank() {
    oldText = "Test"
    newText = ""
    isValid = validation.validatedText(newText: oldText, oldText: newText)
    XCTAssertFalse(isValid)
  }
  
  func testOldTextIsBlank() {
    oldText = ""
    newText = "Test"
    isValid = validation.validatedText(newText: oldText, oldText: newText)
    XCTAssertFalse(isValid)
  }
  
  func testOldTextNotEqualsNewText() {
    oldText = "Test A"
    newText = "Test B"
    isValid = validation.validatedText(newText: oldText, oldText: newText)
    XCTAssert(isValid)
  }

}
