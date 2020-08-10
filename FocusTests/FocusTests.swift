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
  var testStack: CoreDataController!
  
  override func setUp() {
    super.setUp()

    testStack = TestCoreDataController()
  }
  
  override func tearDown() {
    testStack = nil
  }
  
    //MARK: - Tests
  
  func test_persistentStoreCreated() {
    let coreDataSetupExpectation = expectation(description: "Set up core data")
    
    coreDataSetupExpectation.fulfill()
    waitForExpectations(timeout: 1.0) { (_) in
      XCTAssertTrue(self.testStack.persistentContainer.persistentStoreCoordinator.persistentStores.count > 0)
    }
  }
  
  func test_persistentContainerLoadedOnDisk() {
  
    let coreDataSetupExpectation = expectation(description: "set up completion called")
    
    let storeUrl = testStack.persistentContainer.persistentStoreCoordinator.persistentStores.first!.url!

      XCTAssertEqual(self.testStack.persistentContainer.persistentStoreDescriptions.first?.type, NSSQLiteStoreType)
      coreDataSetupExpectation.fulfill()
    waitForExpectations(timeout: 1.0) { (_) in
      do {
        try self.testStack.persistentContainer.persistentStoreCoordinator.destroyPersistentStore(at: storeUrl, ofType: NSSQLiteStoreType, options: nil)
      } catch {
        print(error)
      }
    }
  }
  
  func test_mainContextConcurrencyType() {
    let setupExpectation = expectation(description: "main context")
    
      XCTAssertEqual(self.testStack.managedContext.concurrencyType, .mainQueueConcurrencyType)
      setupExpectation.fulfill()
    
    waitForExpectations(timeout: 1.0, handler: nil)
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
