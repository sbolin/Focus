//
//  TodayViewDataSource.swift
//  Focus
//
//  Created by Scott Bolin on 5/15/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit
import CoreData

protocol TodayViewDataSourceDelegate: class {
  func configureTodayToDoCell(at indexPath: IndexPath, _ cell: TodayTaskCell, for object: ToDo)
  func configureTodayGoalCell(at indexPath: IndexPath, _ cell: TodayGoalCell, for object: Goal)
}

class TodayViewDataSource<Result: NSFetchRequestResult, Delegate: TodayViewDataSourceDelegate>: NSObject, UITableViewDataSource {

  // MARK:- Private Parameters
  fileprivate let tableView: UITableView
  fileprivate var fetchedResultsController: NSFetchedResultsController<Result>
  fileprivate weak var delegate: Delegate!
  
  //MARK: - Initializer
  required init(tableView: UITableView, fetchedResultsController: NSFetchedResultsController<Result>, delegate: Delegate) {
    self.tableView = tableView
    self.fetchedResultsController = fetchedResultsController
    self.delegate = delegate
    
    super.init()
    fetchedResultsController.delegate = self
    try! fetchedResultsController.performFetch()
    tableView.dataSource = self
    tableView.reloadData()
  }
  
  //MARK: - UITableViewDataSource methods

  func numberOfSections(in tableView: UITableView) -> Int {
    return fetchedResultsController.sections?.count ?? 0
  }
  
  // no section titles
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let fetchedSection = self.fetchedResultsController.sections?[section] else { return 0 }
    let numberOfRows = fetchedSection.numberOfObjects + 1 // account for added goal cell
    return numberOfRows
    
//    if section == 0 {
//      return 1
//    } else {
//      return 3
//    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if indexPath.row == 0 {
      let todoObject = self.fetchedResultsController.object(at: indexPath) as! ToDo
      let goalObject = todoObject.goal
      let goalCell = tableView.dequeueReusableCell(withIdentifier: TodayGoalCell.reuseIdentifier , for: indexPath) as! TodayGoalCell
      delegate?.configureTodayGoalCell(at: indexPath, goalCell, for: goalObject)
      return goalCell
    }
    let previousIndex = IndexPath(row: indexPath.row - 1, section: indexPath.section)
    let todoObject = self.fetchedResultsController.object(at: previousIndex) as! ToDo
    let todoCell = tableView.dequeueReusableCell(withIdentifier: TodayTaskCell.reuseIdentifier, for: indexPath) as! TodayTaskCell
    delegate?.configureTodayToDoCell(at: indexPath, todoCell, for: todoObject)
    return todoCell
    
//    let section = indexPath.section
//    let goalObjectController = coreDataStack.fetchAllGoals()
//    do {
//      try goalObjectController.performFetch()
//    } catch {
//      print("Cannot fetch goals")
//      fatalError()
//    }
//    let goalObject = goalObjectController.object(at: indexPath)
//
//    let todos = goalObject.todos.allObjects as? [ToDo]
//    if section == 0 {
//      // section 0 is for Today's goal:
//      guard let cell = tableView.dequeueReusableCell(withIdentifier: TodayGoalCell.reuseIdentifier, for: indexPath) as? TodayGoalCell else {
//        fatalError("Wrong cell type dequeued")
//      }
//      cell.todayGoal.text = goalObject.goal
//      return cell
//    } else {
//      // section 1 is for Today's tasks:
//      let cell = tableView.dequeueReusableCell(withIdentifier: TodayTaskCell.reuseIdentifier, for: indexPath) as! TodayTaskCell
//      guard let todoObject = todos?[indexPath.row] else {
//        fatalError("Attempt to configure cell without a managed object")
//      }
//      cell.todayTask.text = todoObject.todo
//      return cell
//    }
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    switch editingStyle {
    case .delete:
      let todo = fetchedResultsController.object(at: indexPath)
      CoreDataController.shared.deleteToDo(todo: todo as! ToDo)
      CoreDataController.shared.saveContext()
    // delete data
    case .insert:
      CoreDataController.shared.addToDo(text: "New ToDo", at: indexPath)
      tableView.beginUpdates()
      let rowToInsertAt = IndexPath.init(row: indexPath.row - 1, section: indexPath.section)
      tableView.insertRows(at: [rowToInsertAt], with: .automatic)
      tableView.endUpdates()
    // insert data
    case .none:
      break
    // do nothing
    @unknown default:
      break
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
      
      let editAction = UIContextualAction(style: .normal, title:  "Edit", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
          success(true)
      })
      editAction.backgroundColor = .systemGreen
      return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
      
      let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
          success(true)
      })
      deleteAction.backgroundColor = .systemRed
      
      return UISwipeActionsConfiguration(actions: [deleteAction])
    }
  }
  
  
  //MARK: - NSFetchedResultsControllerDelegate delegate methods
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    
    let indexSet = IndexSet(integer: sectionIndex)
    
    switch type {
    case .insert:
      tableView.insertSections(indexSet, with: .automatic)
    case .delete:
      tableView.deleteSections(indexSet, with: .automatic)
    case .move:
      break
    case .update:
      break
    @unknown default:
      break
    }
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    
    switch type {
    case .insert:
      tableView.insertRows(at: [newIndexPath!], with: .automatic)
    case .delete:
      tableView.deleteRows(at: [indexPath!], with: .automatic)
    case .move:
      tableView.moveRow(at: indexPath!, to: newIndexPath!)
    case .update:
      tableView.reloadRows(at: [indexPath!], with: .automatic)
    @unknown default:
      break
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
}

/*
//MARK: - Cell delegate methods
extension TodayViewDataSource: TodayTaskCellDelegate, TodayGoalCellDelegate {
  
  //MARK: TodayGoalCellDelegate Methods
  func todayGoal(_ cell: TodayGoalCell, newGoalCreated newGoal: String) {
    guard let tableViewContainer = cell.tableView else { return }
    guard let indexPath = tableViewContainer.indexPath(for: cell) else { return }
    let newGoal = coreDataStack.createGoals(goalName: newGoal)
    newGoal?.goalDateCreated = Date()
    newGoal?.goalCompleted = false
    tableViewContainer.reloadRows(at: [indexPath], with: .automatic)
//    tableViewContainer.insertRows(at: [indexPath], with: .automatic)
    coreDataStack.saveContext()
  }
  
  func todayGoal(_ cell: TodayGoalCell) -> Bool {
    // check if all tasks completed or not
    //TODO: returning false isn't correct, not sure what it should be?
    guard let tableViewContainer = cell.tableView else { return false }
    guard let indexPath = tableViewContainer.indexPath(for: cell) else { return false }
    let goalObject = coreDataStack.fetchTodayGoals().object(at: indexPath)
    guard let todos = goalObject.todos.allObjects as? [ToDo] else { return false }
    
    let todosCount = todos.count
    let todosDoneCount = todos.filter { (task) -> Bool in
      return task.todoCompleted == true
    }.count
    return todosDoneCount == todosCount
  }
  
  //MARK: TodayTaskCellDelegate Methods
  func todayTask(_ cell: TodayTaskCell, newTaskCreated newTask: String) {
    //TODO: Check if tasks already exists, if so update task else create new task
    guard let tableViewContainer = cell.tableView else { return }
    guard let indexPath = tableViewContainer.indexPath(for: cell) else { return }
    let newTask = coreDataStack.createToDo(todoName: newTask)
    newTask?.todoDateCreated = Date()
    newTask?.todoCompleted = false
    tableViewContainer.reloadRows(at: [indexPath], with: .automatic)
//    tableViewContainer.insertRows(at: [indexPath], with: .automatic)
    coreDataStack.saveContext()
  }
  
  func todayTask(_ cell: TodayTaskCell, completionChanged completion: Bool) {
    guard let tableViewContainer = cell.tableView else { return }
    guard let indexPath = tableViewContainer.indexPath(for: cell) else { return }
    let goalObject = coreDataStack.fetchTodayGoals().object(at: indexPath)
    guard let todos = goalObject.todos.allObjects as? [ToDo] else { return }
    let task = todos[indexPath.row]
    task.todoCompleted = completion
    if completion {
    task.todoDateCompleted = Date()
    }
    coreDataStack.saveContext()
  }
}
*/
