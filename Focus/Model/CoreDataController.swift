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
  // new fetches
  // used in TodayView
  lazy var fetchedToDoResultsController: NSFetchedResultsController<ToDo> = {
    let managedContext = persistentContainer.viewContext
    let request = ToDo.todoFetchRequest()
    let goalSort = NSSortDescriptor(keyPath: \ToDo.goal.goal, ascending: true)
    let createdSort = NSSortDescriptor(keyPath: \ToDo.todoDateCreated, ascending: false)
    request.sortDescriptors = [goalSort, createdSort]
    
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: managedContext,
      sectionNameKeyPath: "Goal.goal",
      cacheName: nil)
    
    return fetchedResultsController
  }()
  
//  lazy var fetchedGoalResultsController: NSFetchedResultsController<Goal> = {
//    let managedContext = persistentContainer.viewContext
//    let request = Goal.goalFetchRequest()
//    let goalCreatedSort = NSSortDescriptor(keyPath: \Goal.goalDateCreated, ascending: false)
//    let todoCreatedSort = NSSortDescriptor(keyPath: \ToDo.todoDateCreated, ascending: false)
//    request.sortDescriptors = [todoCreatedSort, goalCreatedSort ]
//
//    let fetchedResultsController = NSFetchedResultsController(
//      fetchRequest: request,
//      managedObjectContext: managedContext,
//      sectionNameKeyPath: "goalDateCreated",
//      cacheName: nil)
//
//    return fetchedResultsController
//  }()
  
//  lazy var fetchedToDoGoalResultsController: NSFetchedResultsController<ToDo> = {
//    let context = persistentContainer.viewContext
//    let request = ToDo.todoFetchRequest()
//    let goalCreatedSort = NSSortDescriptor(keyPath: \ToDo.goal.goalDateCreated, ascending: false)
//    let todoCreatedSort = NSSortDescriptor(keyPath: \ToDo.todoDateCreated, ascending: false)
//
//    request.sortDescriptors = [goalCreatedSort, todoCreatedSort]
//
//    let fetchedResultsController = NSFetchedResultsController(
//      fetchRequest: request,
//      managedObjectContext: context,
//      sectionNameKeyPath: "goal.goalDateCreated",
//      cacheName: nil)
//
//    return fetchedResultsController
//  }()
  
  // used in HistoryView for main results, and progressView for monthly results
  lazy var fetchedToDoByMonthController: NSFetchedResultsController<ToDo> = {
    let context = persistentContainer.viewContext
    let request = ToDo.todoFetchRequest()
    let createdSort = NSSortDescriptor(keyPath: \ToDo.todoDateCreated, ascending: false)
    request.sortDescriptors = [createdSort]
    
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: context,
      sectionNameKeyPath: "groupByMonth",
      cacheName: nil)
    
    return fetchedResultsController
  }()
  
  // used in progress view for yearly results
  lazy var fetchedToDoByYearController: NSFetchedResultsController<ToDo> = {
    let context = persistentContainer.viewContext
    let request = ToDo.todoFetchRequest()
    let createdSort = NSSortDescriptor(keyPath: \ToDo.todoDateCreated, ascending: false)
    request.sortDescriptors = [createdSort]
    
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: context,
      sectionNameKeyPath: "groupByYear",
      cacheName: nil)
    
    return fetchedResultsController
  }()
  
  // used in progress view for weekly results
  lazy var fetchedToDoByWeekController: NSFetchedResultsController<ToDo> = {
    let context = persistentContainer.viewContext
    let request = ToDo.todoFetchRequest()
    let createdSort = NSSortDescriptor(keyPath: \ToDo.todoDateCreated, ascending: false)
    request.sortDescriptors = [createdSort]
    
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: context,
      sectionNameKeyPath: "groupByWeek",
      cacheName: nil)
    
    return fetchedResultsController
  }()
  
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
  
  //Add new Goal
  func addGoal(title: String, todo: String) {
    print("addGoal")
    let context = persistentContainer.viewContext
    let newgoal = Goal(context: context)
    let newtodo = ToDo(context: context)
    
    newgoal.goal = title
    newgoal.goalDateCreated = Date()
    newgoal.goalCompleted = false
    newtodo.todo = todo
    newtodo.todoDateCreated = Date()
    newtodo.todoCompleted = false
    newgoal.addToTodos(newtodo)
//    newtodo.goal = newgoal
    saveContext()
//    return newgoal
  }
  
  func updateGoal(updatedGoalTitle: String, updatedToDoText: String, at indexPath: IndexPath) {
    print("updateGoal")
    let todo = fetchedToDoResultsController.object(at: indexPath)
    let goal = todo.goal
    
    if todo.todo != updatedToDoText {
      todo.todo = updatedToDoText
    }
    if goal.goal != updatedGoalTitle {
      goal.goal = updatedGoalTitle
    }
    goal.addToTodos(todo)
    saveContext()
  }
  
  //Mark ToDo Completed
  func markToDoCompleted(completed: Bool, todo: ToDo) {
    print("markToDoCompleted")
    print("todo: \(todo)")
    todo.todoCompleted = completed
    todo.todoDateCompleted = Date()
    
    let goalToCheck = todo.goal
    goalToCheck.goalCompleted = false
    let todos = goalToCheck.todos
    let todoCount = todos.count
    print("todoCount: \(todoCount)")
    var count = 0
    for todo in todos {
      if todo.todoCompleted == true { count += 1 }
    }
    if todoCount == count {
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
    
    // Goal 8
    let goal8 = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: managedContext) as! Goal
    goal8.goal = "Eighth Goal"
    goal8.goalDateCreated = Date(timeIntervalSinceNow: -60*60*24*366)
    goal8.goalCompleted = false
    
    let todo22 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo22.todo = "Goal 8, ToDo 1"
    todo22.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*367)
    todo22.todoCompleted = false
    todo22.goal = goal8
    
    let todo23 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo23.todo = "Goal 8, ToDo 2"
    todo23.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*368)
    todo23.todoCompleted = false
    todo23.goal = goal8
    
    let todo24 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo24.todo = "Goal 8, ToDo 3"
    todo24.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*369)
    todo24.todoCompleted = false
    todo24.goal = goal8
    
    // Goal 7
    let goal7 = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: managedContext) as! Goal
    goal7.goal = "Seventh Goal"
    goal7.goalDateCreated = Date(timeIntervalSinceNow: -60*60*24*181)
    goal7.goalCompleted = false
    
    let todo19 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo19.todo = "Goal 7, ToDo 1"
    todo19.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*182)
    todo19.todoCompleted = false
    todo19.goal = goal7
    
    let todo20 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo20.todo = "Goal 7, ToDo 2"
    todo20.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*183)
    todo20.todoCompleted = false
    todo20.goal = goal7
    
    let todo21 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo21.todo = "Goal 7, ToDo 3"
    todo21.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*184)
    todo21.todoCompleted = false
    todo21.goal = goal7
    
    // Goal 6
    let goal6 = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: managedContext) as! Goal
    goal6.goal = "Sixth Goal"
    goal6.goalDateCreated = Date(timeIntervalSinceNow: -60*60*24*90)
    goal6.goalCompleted = false
    
    let todo16 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo16.todo = "Goal 6, ToDo 1"
    todo16.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*91)
    todo16.todoCompleted = false
    todo16.goal = goal6
    
    let todo17 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo17.todo = "Goal 6, ToDo 2"
    todo17.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*92)
    todo17.todoCompleted = false
    todo17.goal = goal6
    
    let todo18 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo18.todo = "Goal 6, ToDo 3"
    todo18.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*93)
    todo18.todoCompleted = false
    todo18.goal = goal6
    
    // Goal 5
    let goal5 = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: managedContext) as! Goal
    goal5.goal = "Fifth Goal"
    goal5.goalDateCreated = Date(timeIntervalSinceNow: -60*60*24*32)
    goal5.goalCompleted = false
    
    let todo13 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo13.todo = "Goal 5, ToDo 1"
    todo13.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*33)
    todo13.todoCompleted = false
    todo13.goal = goal5
    
    let todo14 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo14.todo = "Goal 5, ToDo 2"
    todo14.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*34)
    todo14.todoCompleted = false
    todo14.goal = goal5
    
    let todo15 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo15.todo = "Goal 5, ToDo 3"
    todo15.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*35)
    todo15.todoCompleted = false
    todo15.goal = goal5
    
    // Goal 4
    let goal4 = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: managedContext) as! Goal
    goal4.goal = "Fourth Goal"
    goal4.goalDateCreated = Date(timeIntervalSinceNow: -60*60*24*16)
    goal4.goalCompleted = false
    
    let todo1 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo1.todo = "Goal 4, ToDo 1"
    todo1.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*17)
    todo1.todoCompleted = false
    todo1.goal = goal4
    
    let todo2 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo2.todo = "Goal 4, ToDo 2"
    todo2.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*18)
    todo2.todoCompleted = false
    todo2.goal = goal4
    
    let todo3 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo3.todo = "Goal 4, ToDo 3"
    todo3.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*19)
    todo3.todoCompleted = false
    todo3.goal = goal4
    
    // Goal 3
    let goal3 = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: managedContext) as! Goal
    goal3.goal = "Third Goal"
    goal3.goalDateCreated = Date(timeIntervalSinceNow: -60*60*24*12)
    goal3.goalCompleted = false
    
    let todo4 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo4.todo = "Goal 3, ToDo 1"
    todo4.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*13)
    todo4.todoCompleted = false
    todo4.goal = goal3
    
    let todo5 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo5.todo = "Goal 3, ToDo 2"
    todo5.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*14)
    todo5.todoCompleted = true
    todo5.goal = goal3
    
    let todo6 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo6.todo = "Goal 3, ToDo 3"
    todo6.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*15)
    todo6.todoCompleted = false
    todo6.goal = goal3
    
    // Goal 2
    let goal2 = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: managedContext) as! Goal
    goal2.goal = "Second Goal"
    goal2.goalDateCreated = Date(timeIntervalSinceNow: -60*60*24*8)
    goal2.goalCompleted = true
    goal2.goalDateCompleted = Date(timeIntervalSinceNow: -60*60*24*7)
    
    let todo7 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo7.todo = "Goal 2, ToDo 1"
    todo7.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*9)
    todo7.todoCompleted = true
    todo7.todoDateCompleted = Date(timeIntervalSinceNow: -60*60*24*8)
    todo7.goal = goal2
    
    let todo8 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo8.todo = "Goal 2, ToDo 2"
    todo8.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*10)
    todo8.todoCompleted = true
    todo8.todoDateCompleted = Date(timeIntervalSinceNow: -60*60*24*9)
    todo8.goal = goal2
    
    let todo9 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo9.todo = "Goal 2, ToDo 3"
    todo9.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*11)
    todo9.todoCompleted = true
    todo9.todoDateCompleted = Date(timeIntervalSinceNow: -60*60*24*8)
    todo9.goal = goal2
    
    // Goal 1
    let goal1 = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: managedContext) as! Goal
    goal1.goal = "First Goal"
    goal1.goalDateCreated = Date(timeIntervalSinceNow: -60*60*24*1)
    goal1.goalCompleted = false
    
    let todo10 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo10.todo = "Goal 1, ToDo 1"
    todo10.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*1)
    todo10.todoCompleted = true
    todo10.todoDateCompleted = Date(timeIntervalSinceNow: -60*60*24*2)
    todo10.goal = goal1
    
    let todo11 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo11.todo = "Goal 1, ToDo 2"
    todo11.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*2)
    todo11.todoCompleted = false
    todo11.goal = goal1
    
    let todo12 = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: managedContext) as! ToDo
    todo12.todo = "Goal 1, ToDo 3"
    todo12.todoDateCreated = Date(timeIntervalSinceNow: -60*60*24*3)
    todo12.todoCompleted = false
    todo12.goal = goal1
    
    saveContext()
  }
}
