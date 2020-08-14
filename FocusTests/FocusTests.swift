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
    super.tearDown()
  }
  
    //MARK: - Tests
  //MARK: CoreData Tests
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
  
  //MARK: Goal and ToDo tests
  func testAddGoalAt() {
    let goalTitle = "Goal 1"
    let indexPath = IndexPath(row: 0, section: 0)
    // create goal
    testStack.addGoalAt(title: goalTitle, at: indexPath)
    
    // fetch same goal
    let goal = testStack.fetchedGoalResultsController.object(at: indexPath)
    
    XCTAssertNotNil(goal, "goal should not be nil")
    XCTAssertEqual(goal.goal, goalTitle)
    XCTAssertNotEqual(goal.goal.count, 0)
    XCTAssertEqual(goal.goalCompleted, false)
    XCTAssertEqual(goal.goalDateCreated, Date())
  }
  
  func testAddNewGoal() {
    let goalTitle = "Goal 2"
    // create goal
    testStack.addNewGoal(title: goalTitle)
    
    // fetch same goal
    let allGoal = testStack.fetchedGoalResultsController.fetchedObjects
    guard let goal = allGoal?.last else {
      XCTAssert(false)
      return
    } // not sure if return is correct
    
    XCTAssertNotNil(goal, "goal should not be nil")
    XCTAssertEqual(goal.goal, goalTitle)
    XCTAssertNotEqual(goal.goal.count, 0)
    XCTAssertEqual(goal.goalCompleted, false)
    XCTAssertEqual(goal.goalDateCreated, Date())
  }
  
  func testAddNewTodo() {
    let goalTitle = "Goal 3"
    let todoTitle = "Goal 3 - Todo 1"
    let indexPath = IndexPath(row: 1, section: 0)
    // create todo
    testStack.addToDo(text: todoTitle, at: indexPath)
    
    // fetch same todo
    let todo = testStack.fetchedToDoResultsController.object(at: indexPath)
    
    XCTAssertNotNil(todo, "todo should not be nil")
    XCTAssertEqual(todo.todo, todoTitle)
    XCTAssertNotEqual(todo.todo.count, 0)
    XCTAssertEqual(todo.todoCompleted, false)
    XCTAssertEqual(todo.todoDateCreated, Date())
    XCTAssertEqual(todo.goal.goal, goalTitle)
  }
  
  func testModifyGoal() {
    let modifiedGoalTitle = "Goal 1B"
    let indexPath = IndexPath(row: 0, section: 0)
    // modify goal
    testStack.modifyGoal(updatedGoalText: modifiedGoalTitle, at: indexPath)
    
    // fetch same goal
    let goal = testStack.fetchedGoalResultsController.object(at: indexPath)
    
    XCTAssertNotNil(goal, "goal should not be nil")
    XCTAssertEqual(goal.goal, modifiedGoalTitle)
    XCTAssertEqual(goal.goalCompleted, false)
    XCTAssertEqual(goal.goalDateCreated, Date()) // may not be the case
  }
  
  func testModifyToDo() {
    let modifyTodoTitle = "Goal 1B - Todo 1B"
    let indexPath = IndexPath(row: 1, section: 0)
    // modify todo
    testStack.modifyToDo(updatedToDoText: modifyTodoTitle, at: indexPath)
    
    // fetch same todo
    let todo = testStack.fetchedToDoResultsController.object(at: indexPath)
    
    XCTAssertNotNil(todo, "todo should not be nil")
    XCTAssertEqual(todo.todo, modifyTodoTitle)
    XCTAssertNotEqual(todo.todo.count, 0)
    XCTAssertEqual(todo.todoCompleted, false)  // may not be the case - todo could be completed but renamed
    XCTAssertEqual(todo.todoDateCreated, Date()) // may not be the case
  }
  
  func testCompleteGoal() {
    let indexPath = IndexPath(row: 0, section: 0)
    // fetch todo at index Path
    let goal = testStack.fetchedGoalResultsController.object(at: indexPath)
    let todos = goal.todos
    for todo in todos {
      XCTAssertEqual(todo.todoCompleted, true)
    }
    XCTAssertEqual(goal.goalCompleted, true)
  }
  
  func testCompleteToDoItem() {
    let indexPath = IndexPath(row: 1, section: 0)
    // fetch todo at index Path
    let todo = testStack.fetchedToDoResultsController.object(at: indexPath)
    let completed = true
    
    // mark todo as complete
    testStack.markToDoCompleted(completed: completed, todo: todo)
    
    XCTAssertEqual(todo.todoCompleted, completed)
    
  }
  
  func testCompleteAllTodo() {
    let indexPath = IndexPath(row: 0, section: 0)
    // fetch goal
    let goal = testStack.fetchedGoalResultsController.object(at: indexPath)
    let todos = goal.todos
    for todo in todos {
      XCTAssertEqual(todo.todoCompleted, true)
    }
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
