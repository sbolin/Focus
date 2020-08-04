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
}


//MARK: - Cell delegate methods
extension TodayViewDataSource: TodayTaskCellDelegate, TodayGoalCellDelegate {
  func todayTaskCompletion(cell: TodayToDoCell, completionStatus completion: Bool) {
    guard let indexPath = tableView.indexPath(for: cell) else { return }
    let previousIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
    let note = CoreDataController.shared.fetchedToDoResultsController.object(at: previousIndexPath) 
    CoreDataController.shared.markToDoCompleted(completed: completion, todo: note)
    tableView.reloadData()
  }

  //MARK: TodayTaskCellDelegate Methods
  func todayTaskNew(_ cell: TodayToDoCell, newTask: String) {
    guard let tableViewContainer = cell.tableView else { return }
    guard let indexPath = tableViewContainer.indexPath(for: cell) else { return }
    let previousIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
    CoreDataController.shared.addToDo(text: newTask, at: previousIndexPath)
    tableView.reloadData()
  }
  
  func todayTaskUpdated(_ cell: TodayToDoCell, updatedTask: String) {
    guard let tableViewContainer = cell.tableView else { return }
    guard let indexPath = tableViewContainer.indexPath(for: cell) else { return }
    let previousIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
    CoreDataController.shared.modifyToDo(updatedToDoText: updatedTask, at: previousIndexPath)
    tableView.reloadData()
  }
  
  //MARK: TodayGoalCellDelegate Methods
  func todayGoalUpdated(_ cell: TodayGoalCell, updatedGoal goalText: String) {
    guard let tableViewContainer = cell.tableView else { return }
    guard let indexPath = tableViewContainer.indexPath(for: cell) else { return }
    CoreDataController.shared.modifyGoal(updatedGoalText: goalText, at: indexPath)
    tableView.reloadData()
  }
  
  func todayGoalNew(_ cell: TodayGoalCell, newGoal goalText: String) {
    guard let tableViewContainer = cell.tableView else { return }
    guard let indexPath = tableViewContainer.indexPath(for: cell) else { return }
    CoreDataController.shared.addGoal(title: goalText, at: indexPath)
    tableView.reloadData()
  }
}
