//
//  CoreDataStack.swift
//  Focus
//
//  Created by Scott Bolin on 4/30/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {

  private let modelName: String

  init(modelName: String) {
    self.modelName = modelName
  }

  lazy var managedContext: NSManagedObjectContext = {
    return self.persistentContainer.viewContext
  }()

  private lazy var persistentContainer: NSPersistentContainer = {

    let container = NSPersistentContainer(name: self.modelName)
    container.loadPersistentStores { (storeDescription, error) in
      container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
      if let error = error as NSError? {
        print("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()

  func saveContext () {
    guard managedContext.hasChanges else { return }
    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Unresolved error \(error), \(error.localizedDescription)")
    }
  }
  func fetchAllGoals() -> NSFetchedResultsController<Goal> {
    let context = persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
    
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "goalDateCompleted", ascending: false)]
    
    let fetchRequestController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: context,
      sectionNameKeyPath: nil,
      cacheName: nil)
    
    do {
      try fetchRequestController.performFetch()
    } catch let fetchError {
      print("Failed to fetch Goals \(fetchError.localizedDescription)")
    }
    return fetchRequestController
  }
  
  func fetchTodayTodoGoal() -> NSFetchedResultsController<Goal> {
   let context = persistentContainer.viewContext
   let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
    
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "goalDateCompleted", ascending: false)]
    
    let fetchRequestController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: context,
      sectionNameKeyPath: "goalDateCompleted",
      cacheName: nil)
    
    do {
      try fetchRequestController.performFetch()
    } catch let error {
      print("Error fetching TodoGoal \(error.localizedDescription)")
    }
    return fetchRequestController
  }
  
  func createGoals(goalName: String) -> Goal? {
    let context = persistentContainer.viewContext
    
    // create goal
    let goalObject = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: context) as! Goal
    
    goalObject.goal = goalName
    goalObject.goalCompleted = false
    goalObject.goalDateCreated = Date()
    
    do {
      try context.save()
      return goalObject
    } catch let goalError {
      print("Could not create Goal \(goalError.localizedDescription)")
      return nil
    }
  }
  
  //TODO: should be:
  //  func createTodo(todoName: String, for goal: Goal) -> ToDo?
  func createTodo(todoName: String) -> ToDo? {
    let context = persistentContainer.viewContext
    
    // create todo
    let todoObject = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: context) as! ToDo
    
//    todoObject.goal = goal
    todoObject.todo = todoName
    todoObject.todoCompleted = false
    todoObject.todoDateCreated = Date()
    
    do {
      try context.save()
      return todoObject
    } catch let todoError {
      print("Could not create Todo \(todoError.localizedDescription)")
      return nil
    }
  }
  
  
}
