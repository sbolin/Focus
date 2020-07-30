//
//  CoreDataController.swift
//  Focus
//
//  Created by Scott Bolin on 4/30/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import Foundation
import CoreData

class CoreDataController {
  
  //MARK: - Create CoreData Stack
  static let shared = CoreDataController() // singleton
  private init() {} // Prevent clients from creating another instance.

  lazy var managedContext: NSManagedObjectContext = {
    return self.persistentContainer.viewContext
  }()
  
  private lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Focus")
    container.loadPersistentStores { (storeDescription, error) in
      container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
      if let error = error as NSError? {
        print("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()
  
  //MARK: - Fetch Properties
  // used in TodayView
  lazy var fetchedToDoResultsController: NSFetchedResultsController<ToDo> = {
    let managedContext = persistentContainer.viewContext
    let request = ToDo.todoFetchRequest()
//    let goalSort = NSSortDescriptor(keyPath: \ToDo.goal.goal, ascending: true)
//    let goalCreatedSort = NSSortDescriptor(keyPath: \ToDo.goal.goalDateCreated, ascending: true)
    let todoCreatedSort = NSSortDescriptor(keyPath: \ToDo.todoDateCreated, ascending: true)
    let todoSort = NSSortDescriptor(keyPath: \ToDo.todo, ascending: true)
    let todoIDSort = NSSortDescriptor(keyPath: \ToDo.id, ascending: true)
    request.sortDescriptors = [todoCreatedSort]// [todoCreatedSort, todoIDSort]

    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: managedContext,
      sectionNameKeyPath: #keyPath(ToDo.goal.goal), // #keyPath(ToDo.goal.goalDateCreated), //#keyPath(Goal.goal),
      cacheName: nil)
    
    return fetchedResultsController
  }()
  
  lazy var fetchedGoalResultsController: NSFetchedResultsController<Goal> = {
    let managedContext = persistentContainer.viewContext
    let request = Goal.goalFetchRequest()
    let goalSort = NSSortDescriptor(keyPath: \Goal.goal, ascending: true)
    let createdSort = NSSortDescriptor(keyPath: \Goal.goalDateCreated, ascending: true)
    request.sortDescriptors = [createdSort, goalSort]
    
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: managedContext,
      sectionNameKeyPath: #keyPath(Goal.goal),
      cacheName: nil)
    
    return fetchedResultsController
  }()

 
  // used in progress view for yearly results
  lazy var fetchedToDoByYearController: NSFetchedResultsController<ToDo> = {
    let managedContext = persistentContainer.viewContext
    let request = ToDo.todoFetchRequest()
    let createdSort = NSSortDescriptor(keyPath: \ToDo.todoDateCreated, ascending: true)
    let idSort = NSSortDescriptor(keyPath: \ToDo.id, ascending: true)
    request.sortDescriptors = [createdSort, idSort]
    
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: managedContext,
      sectionNameKeyPath: "groupByMonth", // "groupByYear"
      cacheName: nil)
    
    return fetchedResultsController
  }()
  
  lazy var fetchedGoalByYearController: NSFetchedResultsController<Goal> = {
    let managedContext = persistentContainer.viewContext
    let request = Goal.goalFetchRequest()
    let createdSort = NSSortDescriptor(keyPath: \Goal.goalDateCreated, ascending: true)
    request.sortDescriptors = [createdSort]
    
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: managedContext,
      sectionNameKeyPath: "groupByMonth", // "groupByYear"
      cacheName: nil)
    
    return fetchedResultsController
  }()
  
  // used in HistoryView for main results
  lazy var fetchedToDoByMonthController: NSFetchedResultsController<ToDo> = {
    let managedContext = persistentContainer.viewContext
    let request = ToDo.todoFetchRequest()
    let createdSort = NSSortDescriptor(keyPath: \ToDo.todoDateCreated, ascending: true)
    let nameSort = NSSortDescriptor(keyPath: \ToDo.todo, ascending: true)
    let idSort = NSSortDescriptor(keyPath: \ToDo.id, ascending: true)
    request.sortDescriptors = [createdSort, nameSort, idSort]
    
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: managedContext,
      sectionNameKeyPath: "groupByMonth",
      cacheName: nil)
    
    return fetchedResultsController
  }()
  
  // used in progressView for last month results
  lazy var fetchedToDoByLastMonthController: NSFetchedResultsController<ToDo> = {
    let managedContext = persistentContainer.viewContext
    let request = ToDo.todoFetchRequest()
    let createdSort = NSSortDescriptor(keyPath: \ToDo.todoDateCreated, ascending: true)
    let idSort = NSSortDescriptor(keyPath: \ToDo.id, ascending: true)
    request.sortDescriptors = [createdSort, idSort]
    
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: managedContext,
      sectionNameKeyPath: "groupByWeek", // "groupByMonth",
      cacheName: nil)
    
    return fetchedResultsController
  }()
  
  lazy var fetchedGoalByMonthController: NSFetchedResultsController<Goal> = {
    let managedContext = persistentContainer.viewContext
    let request = Goal.goalFetchRequest()
    let createdSort = NSSortDescriptor(keyPath: \Goal.goalDateCreated, ascending: true)
    request.sortDescriptors = [createdSort]
    
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: managedContext,
      sectionNameKeyPath: "groupByWeek", // "groupByMonth",
      cacheName: nil)
    
    return fetchedResultsController
  }()
 
  // used in progress view for weekly results
  lazy var fetchedToDoByWeekController: NSFetchedResultsController<ToDo> = {
    let context = persistentContainer.viewContext
    let request = ToDo.todoFetchRequest()
    let createdSort = NSSortDescriptor(keyPath: \ToDo.todoDateCreated, ascending: true)
    let idSort = NSSortDescriptor(keyPath: \ToDo.id, ascending: true)
    request.sortDescriptors = [createdSort, idSort]
    
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: context,
      sectionNameKeyPath: "groupByDay", //"groupByWeek"
      cacheName: nil)
    
    return fetchedResultsController
  }()
  
  lazy var fetchedGoalByWeekController: NSFetchedResultsController<Goal> = {
    let managedContext = persistentContainer.viewContext
    let request = Goal.goalFetchRequest()
    let createdSort = NSSortDescriptor(keyPath: \Goal.goalDateCreated, ascending: true)
    request.sortDescriptors = [createdSort]
    
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: managedContext,
      sectionNameKeyPath: "groupByDay", //"groupByWeek"
      cacheName: nil)
    
    return fetchedResultsController
  }()
  
  lazy var sectionExpanded: [Bool] = []  //Make a class - get/set values easily
  
  //MARK: - SaveContext
  func saveContext () {
    guard managedContext.hasChanges else { return }
    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Unresolved error \(error), \(error.localizedDescription)")
    }
  }
  
  //MARK: - Creation Methods
  func addToDo(text: String, at indexPath: IndexPath) {
    print("addToDo")
    let context = persistentContainer.viewContext
    let todo = fetchedToDoResultsController.object(at: indexPath)
    let goal = todo.goal
    let newToDo = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: context) as! ToDo
    newToDo.todo = text
    newToDo.todoDateCreated = Date()
    newToDo.todoCompleted = false
    newToDo.goal = goal
    saveContext()
  }
  
  //Modify existing todo
  func modifyToDo(updatedToDoText: String, at indexPath: IndexPath) {
    print("modifyToDo")
    let todo = fetchedToDoResultsController.object(at: indexPath)
    if todo.todo != updatedToDoText {
      todo.todo = updatedToDoText
      todo.todoDateCreated = Date()
      todo.todoCompleted = false
      saveContext()
    }
  }
  
  //Add or modify new Goal
  func addModifyGoal(title: String, at indexPath: IndexPath) {
    print("addModifyGoal")
    let context = persistentContainer.viewContext
    let todo = fetchedToDoResultsController.object(at: indexPath)
//    let goal = fetchedGoalResultsController.object(at: indexPath)
    let goal = todo.goal
    if goal.goal.isEmpty {
      // new goal
      let newgoal = Goal(context: context)
      newgoal.goal = title
      newgoal.goalDateCreated = Date()
      newgoal.goalCompleted = false
    } else {
      // modify existing goal
      goal.goal = title
    }
    saveContext()
  }
  
  //Mark ToDo Completed
  func markToDoCompleted(completed: Bool, todo: ToDo) {
    print("markToDoCompleted")
    todo.todoCompleted = completed
    let goalToCheck = todo.goal
    goalToCheck.goalCompleted = false
    goalToCheck.goalDateCompleted = nil
    let todos = goalToCheck.todos
    let todosNotCompleted = todos.contains { (todo) -> Bool in
      todo.todoCompleted == false
    }
    if !todosNotCompleted {
      todo.todoDateCompleted = Date()
      goalToCheck.goalCompleted = true
      goalToCheck.goalDateCompleted = Date()
    }
    saveContext()
  }
  
  //Delete Goal
  func deleteGoal(goal: Goal) {
    print("deleteGoal")
    managedContext.delete(goal)
    saveContext()
  }
  
  //Delete ToDo
  func deleteToDo(todo: ToDo) {
    print("deleteToDo")
    let associatedGoal = todo.goal
    let todoCount = associatedGoal.todos.count
    if todoCount < 2 {
      managedContext.delete(todo)
      managedContext.delete(associatedGoal)
    } else {
      managedContext.delete(todo)
    }
    saveContext()
  }
  
  //MARK: - create todos
  func createToDosIfNeeded() {
    
    // check if todos exist, if so return
    let fetchRequest = ToDo.todoFetchRequest()
    let count = try! managedContext.count(for: fetchRequest)
    
    guard count == 0 else { return }
    
    // automatically create (goalCount+1) goals and associated todos
    
    let goalCount = 99 // # total number of goals (+1)
    let intermediateGoalCount1 = (goalCount - 1) / 2 // extent of daily goals
    let intermediateGoalCount2 = goalCount - 10 // extent of every other day goals
    let intermediateGoalCount3 = goalCount - 5 // extent of every 3rd day goals
    
    var dateCreated = Date()
    var dateCompleted = Date()
    var goalComplete: Bool = true
    
    for goalNumber in 0...goalCount {  // create
      let goalTitle = "Goal #\(goalNumber + 1)"
      if goalNumber <= intermediateGoalCount1 {
        dateCreated = Date(timeIntervalSinceNow: TimeInterval(-86400 * goalNumber))
      } else if (goalNumber > intermediateGoalCount1) && (goalNumber <= intermediateGoalCount2) {
        dateCreated = Date(timeIntervalSinceNow: TimeInterval(-86400 * 2 * goalNumber))
      } else if (goalNumber > intermediateGoalCount2) && (goalNumber <= intermediateGoalCount3) {
        dateCreated = Date(timeIntervalSinceNow: TimeInterval(-86400 * 3 * goalNumber))
      } else {
        dateCreated = Date(timeIntervalSinceNow: TimeInterval(-86400 * (365 + goalNumber - 100)))
      }
      dateCompleted = dateCreated
      let goal = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: managedContext) as! Goal
      goal.goal = goalTitle
      goal.goalDateCreated = dateCreated
      goal.goalCompleted = true
      
      for todoNumber in 0...2 {
        let random = Int.random(in: 1...20)
        let todo = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
        let todoTitle = "Goal #\(goalNumber + 1) To Do #\(todoNumber + 1)"
        todo.todo = todoTitle
        todo.todoDateCreated = dateCreated
        todo.id = UUID()
        todo.goal = goal
        if random % 10 == 0 { // 20% change of todo being incomplete
          goalComplete = false
          todo.todoCompleted = false
          todo.todoDateCompleted = nil
        } else {
          todo.todoCompleted = true
          todo.todoDateCompleted = dateCompleted.addingTimeInterval(TimeInterval(86400 * (todoNumber + 1)))
          goal.goalDateCompleted = dateCompleted.addingTimeInterval(TimeInterval(86400 * (todoNumber + 1)))
        }
      }
      if goalComplete == false {
        goal.goalCompleted = false
        goal.goalDateCompleted = nil
      }
      goalComplete = true
    }
    saveContext()
  }
}
