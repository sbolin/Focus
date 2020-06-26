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
  func configureTodayTask(at indexPath: IndexPath, _ cell: TodayToDoCell, for object: ToDo)
  func configureTodayGoal(at indexPath: IndexPath, _ cell: TodayGoalCell, for object: Goal)
}

class TodayViewDataSource<Result: NSFetchRequestResult, Delegate: TodayViewDataSourceDelegate>: NSObject, UITableViewDataSource, NSFetchedResultsControllerDelegate {

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
    
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let fetchedSection = self.fetchedResultsController.sections?[section] else { return 0 }
    let numberOfRows = fetchedSection.numberOfObjects + 1 // account for added goal cell
    return numberOfRows
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0 {
      let todoObject = self.fetchedResultsController.object(at: indexPath) as! ToDo
      let goalObject = todoObject.goal
      let goalCell = tableView.dequeueReusableCell(withIdentifier: TodayGoalCell.reuseIdentifier , for: indexPath) as! TodayGoalCell
      goalCell.delegate = self
      delegate?.configureTodayGoal(at: indexPath, goalCell, for: goalObject)
      return goalCell
    }
    let previousIndex = IndexPath(row: indexPath.row - 1, section: indexPath.section)
    let todoObject = self.fetchedResultsController.object(at: previousIndex) as! ToDo
    let todoCell = tableView.dequeueReusableCell(withIdentifier: TodayToDoCell.reuseIdentifier, for: indexPath) as! TodayToDoCell
    todoCell.delegate = self
    delegate?.configureTodayTask(at: indexPath, todoCell, for: todoObject)
    return todoCell
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    switch editingStyle {
    case .delete:
      let todo = fetchedResultsController.object(at: indexPath)
      CoreDataController.shared.deleteToDo(todo: todo as! ToDo)
      CoreDataController.shared.saveContext()
    // delete data
    case .insert:
      let _ = CoreDataController.shared.addToDo(text: "New ToDo", at: indexPath)
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


//MARK: - Cell delegate methods
extension TodayViewDataSource: TodayTaskCellDelegate, TodayGoalCellDelegate {
  
  //MARK: TodayTaskCellDelegate Methods
  func todayToDoUpdated(_ cell: TodayToDoCell, toDoUpdated updatedToDo: String) {
    guard let tableViewContainer = cell.tableView else { return }
    guard let indexPath = tableViewContainer.indexPath(for: cell) else { return }
    let previousIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
    print("Indexpath: \(indexPath.section), \(indexPath.row)")
    print("PreviousIndexpath: \(previousIndexPath.section), \(previousIndexPath.row)")
//    CoreDataController.shared.addToDo(text: updatedToDo, at: indexPath)
    CoreDataController.shared.modifyToDo(updatedToDoText: updatedToDo, at: previousIndexPath)
    tableView.reloadData()
 //   tableViewContainer.reloadRows(at: [indexPath], with: .automatic)
//    tableViewContainer.insertRows(at: [indexPath], with: .automatic)
  }
  
  func todayTaskCompletion(_ cell: TodayToDoCell, completionChanged completion: Bool) {
    guard let indexPath = tableView.indexPath(for: cell) else { return }
    let previousIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
    let note = CoreDataController.shared.fetchedToDoResultsController.object(at: previousIndexPath)
    CoreDataController.shared.markToDoCompleted(completed: completion, todo: note)
//    tableView.reloadRows(at: [indexPath], with: .none)
    tableView.reloadData()
  }
  
  //MARK: TodayGoalCellDelegate Methods
  func todayGoal(_ cell: TodayGoalCell, todayGoalText goalText: String) {
    guard let tableViewContainer = cell.tableView else { return }
    guard let indexPath = tableViewContainer.indexPath(for: cell) else { return }
    CoreDataController.shared.addModifyGoal(title: goalText, at: indexPath)
//    tableViewContainer.reloadRows(at: [indexPath], with: .automatic)
//    tableViewContainer.insertRows(at: [indexPath], with: .automatic)
    tableView.reloadData()
  }
  
}
