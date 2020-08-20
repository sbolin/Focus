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
  var fetchedResultsController: NSFetchedResultsController<ToDo>!
  
  override func setUp() {
    super.setUp()
    mockStack = MockCoreDataController()
    if fetchedResultsController == nil {
      fetchedResultsController = mockStack.fetchedToDoResultsController
    }
    do {
      try fetchedResultsController.performFetch()
    } catch {
      print("Fetch failed")
    }
  }
  
  override func tearDown() {
    super.tearDown()
    mockStack = nil
  }
  
  func deleteAllGoals() {
    // Initialize Fetch Request
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")
    let context = MockCoreDataController.shared.managedContext
    fetchRequest.includesPropertyValues = false
    do {
      let items = try context.fetch(fetchRequest) as! [NSManagedObject]
      for item in items {
        context.delete(item)
      }
      try context.save()
      
    } catch {
      print("Could not delete mockStack")
    }
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
  }
  
  func test_fetchedResultsControllerFetches() {
    let frca = mockStack.fetchedToDoResultsController
    let frcb = mockStack.fetchedGoalResultsController
    let frc1 = mockStack.fetchedToDoByWeekController
    let frc2 = mockStack.fetchedGoalByWeekController
    let frc3 = mockStack.fetchedToDoByMonthController
    let frc4 = mockStack.fetchedGoalByMonthController
    let frc5 = mockStack.fetchedToDoByLastMonthController
    let frc6 = mockStack.fetchedGoalByLastMonthController
    let frc7 = mockStack.fetchedToDoByYearController
    let frc8 = mockStack.fetchedGoalByYearController
    
    XCTAssertNotNil(frca)
    XCTAssertNotNil(frcb)
    XCTAssertNotNil(frc1)
    XCTAssertNotNil(frc2)
    XCTAssertNotNil(frc3)
    XCTAssertNotNil(frc4)
    XCTAssertNotNil(frc5)
    XCTAssertNotNil(frc6)
    XCTAssertNotNil(frc7)
    XCTAssertNotNil(frc8)    
  }
  
  func test_saveAsAfterAddingModdingGoal() {
    let derivedContext = mockStack.derivedContext
    let newGoal = Goal(context: derivedContext)
    newGoal.goal = "New Goal"
    newGoal.goalCompleted = false
    newGoal.goalDateCreated = Date()
    
    expectation(forNotification: .NSManagedObjectContextDidSave, object: mockStack.managedContext) { _ in
      return true
    }
    derivedContext.perform {
      // create goal
      self.mockStack.addNewGoal(title: newGoal.goal)
      XCTAssertNotNil(newGoal)
    }
    waitForExpectations(timeout: 1.0) { error in
      XCTAssertNil(error, "Save did not occur")
    }
  }
  
//MARK: Goal and ToDo tests
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
  
  func testModifyGoal() {
    let modifiedGoalTitle = "Goal 1B"
    let indexPath = IndexPath(row: 0, section: 0)
    // modify goal
    MockCoreDataController.shared.modifyGoal(updatedGoalText: modifiedGoalTitle, at: indexPath)
    
    // fetch same todo, convert to goal
    let todo = MockCoreDataController.shared.fetchedToDoResultsController.object(at: indexPath)
    let goal = todo.goal
    
    XCTAssertNotNil(goal, "goal should not be nil")
    XCTAssertEqual(goal.goal, modifiedGoalTitle)
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
    mockStack.markGoalCompleted(todo: todo)
    XCTAssertEqual(goal.goalCompleted, completed)
  }
  
  func testCreateToDos() {
    let context = mockStack.managedContext
    mockStack.createToDosIfNeeded(managedContext: context)
    
    do {
      try mockStack.fetchedToDoResultsController.performFetch()
    } catch {
      print("could not perform fetch")
    }
    let todoObjects = mockStack.fetchedToDoResultsController.fetchedObjects!
    let todoCount = todoObjects.count
    
    XCTAssertNotNil(todoCount)
    XCTAssert(todoCount == 300)
  }
}
