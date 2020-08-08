//
//  FocusTests.swift
//  FocusTests
//
//  Created by Scott Bolin on 4/30/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import XCTest
@testable import Focus
import CoreData

final class FocusTests: XCTestCase {
  
  //MARK: - Properties
  var coreDataStack: CoreDataController!
  
  override func setUp() {
    super.setUp()
    
    coreDataStack = TestCoreDataController()
  }
  
  override func tearDown() {
    coreDataStack = nil
  }
  
  func testAddNewGoal() {
    
  }
  
  func testAddNewTodo() {
    
  }
  
  func testModifyGoal() {
    
  }
  
  func testModifyToDo() {
    
  }
  
  func testCompleteGoal() {
    
  }
  
  func testCompleteToDoItem() {
    
  }
  
  func testCompleteAllTodo() {
    
  }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
