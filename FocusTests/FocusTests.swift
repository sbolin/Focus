//
//  FocusTests.swift
//  FocusTests
//
//  Created by Scott Bolin on 4/30/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import XCTest
import CoreData
@testable import Focus

final class FocusTests: XCTestCase {
  
  //MARK: - Properties
  var mockStack: CoreDataController!
//  var fetchedGoalResultsController: NSFetchedResultsController<Goal>!
  var fetchedResultsController: NSFetchedResultsController<ToDo>!
  
  override func setUp() {
    super.setUp()
    mockStack = MockCoreDataController()
    if fetchedResultsController == nil {
      fetchedResultsController = mockStack.fetchedToDoResultsController
    }
    fetchedResultsController = mockStack.fetchedToDoResultsController
    do {
      try fetchedResultsController.performFetch()
    } catch {
      print("Fetch failed")
    }
  }
  
  override func tearDown() {
//    mockStack = nil
    super.tearDown()
  }
  
    //MARK: - Tests
  //MARK: CoreData Tests
  func test_coreDataManager() {
    let instance = MockCoreDataController.shared
    XCTAssertNotNil(instance)
  }
  
  func test_persistentContainerCreated() {
    let persistentContainer = MockCoreDataController.shared.persistentContainer
      XCTAssertNotNil(persistentContainer)
  }
  
  func test_persistentStoreType() {
    let persistentStore = mockStack.persistentContainer.persistentStoreDescriptions
    print("persistentStore \(persistentStore)")
    let persistentStoreType = persistentStore[0].type
      XCTAssertEqual(persistentStoreType, NSInMemoryStoreType)
  }
  
  func test_contextCreated() {
    let managedContext = MockCoreDataController.shared.managedContext
    XCTAssertNotNil(managedContext)
  }
  
  func test_mainContextConcurrencyType() {
    let concurrencyType = MockCoreDataController.shared.managedContext.concurrencyType
      XCTAssertEqual(concurrencyType, .mainQueueConcurrencyType)
  }
  
  func test_fetchedResultsFetched() {
    let fetchToDo = fetchedResultsController
    XCTAssertNotNil(fetchToDo)
    
//    let fetchGoal = fetchedGoalResultsController
//    XCTAssertNotNil(fetchGoal)
  }
  
//MARK: Goal and ToDo tests

  //  func testAddGoalAt() {
//    let goalTitle = "Goal 1"
//    let indexPath = IndexPath(row: 0, section: 0)
//    // create goal
//    mockStack.addGoalAt(title: goalTitle, at: indexPath)
//
//    // fetch same goal
//        let goal = fetchedGoalResultsController.object(at: indexPath)
//
//    XCTAssertNotNil(goal, "goal should not be nil")
//    XCTAssertEqual(goal.goal, goalTitle)
//    XCTAssertNotEqual(goal.goal.count, 0)
//    XCTAssertEqual(goal.goalCompleted, false)
//    XCTAssertEqual(goal.goalDateCreated, Date())
//  }
  
  func testAddNewGoal() {
    let goalTitle = "Goal 2"
    // create goal
    MockCoreDataController.shared.addNewGoal(title: goalTitle)
    
    // fetch same goal
    let allToDo = fetchedResultsController.fetchedObjects
    guard let goal = allToDo?.last?.goal else { return }
    
    XCTAssertNotNil(goal, "goal should not be nil")
    XCTAssertEqual(goal.goal, goalTitle)
    XCTAssertNotEqual(goal.goal.count, 0)
    XCTAssertEqual(goal.goalCompleted, false)
    XCTAssertEqual(goal.goalDateCreated, Date())
  }
  
//  func testAddNewTodo() {
//    let goalTitle = "Goal 3"
//    let todoTitle = "Goal 3 - Todo 1"
//    let indexPath = IndexPath(row: 1, section: 0)
//    // create todo
//    mockStack.addToDo(text: todoTitle, at: indexPath)
//
//    // fetch same todo
//    let todo = fetchedToDoResultsController.object(at: indexPath)
//
//    XCTAssertNotNil(todo, "todo should not be nil")
//    XCTAssertEqual(todo.todo, todoTitle)
//    XCTAssertNotEqual(todo.todo.count, 0)
//    XCTAssertEqual(todo.todoCompleted, false)
//    XCTAssertEqual(todo.todoDateCreated, Date())
//    XCTAssertEqual(todo.goal.goal, goalTitle)
//  }
  
  func testModifyGoal() {
    let modifiedGoalTitle = "Goal 1B"
    let indexPath = IndexPath(row: 0, section: 0)
    // modify goal
    MockCoreDataController.shared.modifyGoal(updatedGoalText: modifiedGoalTitle, at: indexPath)
    
    // fetch same goal
    // fetch same todo, convert to goal
    let todo = MockCoreDataController.shared.fetchedToDoResultsController.object(at: indexPath)
    let goal = todo.goal
    
    XCTAssertNotNil(goal, "goal should not be nil")
    XCTAssertEqual(goal.goal, modifiedGoalTitle)
//    XCTAssertEqual(goal.goalCompleted, false)
//    XCTAssertEqual(goal.goalDateCreated, Date()) // may not be the case
  }
  
  func testModifyToDo() {
    let modifyTodoTitle = "Goal 1B - Todo 1B"
    let indexPath = IndexPath(row: 1, section: 0)
    // modify todo
    MockCoreDataController.shared.modifyToDo(updatedToDoText: modifyTodoTitle, at: indexPath)
    
    // fetch same todo
    let todo = MockCoreDataController.shared.fetchedToDoResultsController.object(at: indexPath)
    
    XCTAssertNotNil(todo, "todo should not be nil")
    XCTAssertEqual(todo.todo, modifyTodoTitle)
    XCTAssertNotEqual(todo.todo.count, 0)
//    XCTAssertEqual(todo.todoCompleted, false)  // may not be the case - todo could be completed but renamed
//    XCTAssertEqual(todo.todoDateCreated, Date()) // may not be the case
  }
  
  func testCompleteGoal() {
    let indexPath = IndexPath(row: 0, section: 0)
    // fetch todo at index Path
    let todo = MockCoreDataController.shared.fetchedToDoResultsController.object(at: indexPath)
    let goal = todo.goal
    let todos = goal.todos
    let completed = true
    for todo in todos {
      mockStack.markToDoCompleted(completed: completed, todo: todo)
      XCTAssertEqual(todo.todoCompleted, completed)
    }
    XCTAssertEqual(goal.goalCompleted, true)
  }
  
  func testCompleteToDoItem() {
    let indexPath = IndexPath(row: 1, section: 0)
    let todo = MockCoreDataController.shared.fetchedToDoResultsController.object(at: indexPath)
    let completed = true
    mockStack.markToDoCompleted(completed: completed, todo: todo)
    
    XCTAssertEqual(todo.todoCompleted, completed)
  }
  
  func testCompleteAllTodo() {
    let indexPath = IndexPath(row: 0, section: 0)
    let todo = MockCoreDataController.shared.fetchedToDoResultsController.object(at: indexPath)
    let goal = todo.goal
    let todos = goal.todos
    let completed = true
    for todo in todos {
      mockStack.markToDoCompleted(completed: completed, todo: todo)
      XCTAssertEqual(todo.todoCompleted, completed)
    }
  }
}
