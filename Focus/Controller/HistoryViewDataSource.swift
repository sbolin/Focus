//
//  HistoryViewDataSource.swift
//  Focus
//
//  Created by Scott Bolin on 5/16/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit
import CoreData

protocol HistoryViewDataSourceDelegate: class {
  func configureHistoryTaskCell(at indexPath: IndexPath, _ cell: HistoryTaskCell, for object: ToDo)
  func configureHistoryGoalCell(at indexPath: IndexPath, _ cell: HistoryGoalCell, for object: Goal)
  func configureHistorySummaryCell(at indexPath: IndexPath, _ cell: HistorySummaryCell, undoneGoalCount: Int, doneGoalCount: Int, undoneToDoCount: Int, doneToDoCount: Int)
}

class HistoryViewDataSource<Result: NSFetchRequestResult, Delegate: HistoryViewDataSourceDelegate>: NSObject, UITableViewDataSource, NSFetchedResultsControllerDelegate {
  
  // MARK:- Private Parameters
  fileprivate let tableView: UITableView
  fileprivate var fetchedResultsController: NSFetchedResultsController<Result>
  fileprivate weak var delegate: Delegate!
  
  var goalFetch = [ToDo]()
  
  var undoneGoalCount = 0
  var doneGoalCount = 0
  var undoneToDoCount = 0
  var doneToDoCount = 0
  
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
  // # Sections
  func numberOfSections(in tableView: UITableView) -> Int {
    return fetchedResultsController.sections?.count ?? 0
  }
  
  // Title of section
  //  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
  //    guard let sectionInfo = self.fetchedResultsController.sections?[section] else {
  //      return nil
  //    }
  //    return sectionInfo.name
  //  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let fetchedSection = self.fetchedResultsController.sections?[section] else { return 0 }
    let numberOfRows = fetchedSection.numberOfObjects + 1 // account for added history summary and goal cell
    return numberOfRows
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
//    if indexPath.row == 0 {
    if (indexPath.row % 4) == 0 {
      let todoObject = self.fetchedResultsController.object(at: indexPath) as! ToDo
      let goalObject = todoObject.goal
      let goalCell = tableView.dequeueReusableCell(withIdentifier: HistoryGoalCell.reuseIdentifier, for: indexPath) as! HistoryGoalCell
      delegate?.configureHistoryGoalCell(at: indexPath, goalCell, for: goalObject)
      return goalCell
    }
    let offset: Int = indexPath.row / 4 + 1
    let previousIndex = IndexPath(row: indexPath.row - offset, section: indexPath.section)
    let noteObject = self.fetchedResultsController.object(at: previousIndex) as! ToDo
    let noteCell = tableView.dequeueReusableCell(withIdentifier: HistoryTaskCell.reuseIdentifier, for: indexPath) as! HistoryTaskCell
    delegate?.configureHistoryTaskCell(at: indexPath, noteCell, for: noteObject)
    return noteCell
    
/*
     if indexPath.row == 0 {
     let todoObject = self.fetchedResultsController.object(at: indexPath) as! ToDo
     let goalObject = todoObject.goal
     let summaryCell = tableView.dequeueReusableCell(withIdentifier: HistorySummaryCell.reuseIdentifier, for: indexPath) as! HistorySummaryCell
     delegate?.configureHistorySummaryCell(at: indexPath, summaryCell, undoneGoalCount: undoneGoalCount, doneGoalCount: doneGoalCount, undoneToDoCount: undoneToDoCount, doneToDoCount: doneToDoCount)
     return summaryCell
     
     } else if indexPath.row == 1 {
     let historyGoalCellIndex = IndexPath(row: indexPath.row - 1, section: indexPath.section)
     let todoObject = self.fetchedResultsController.object(at: historyGoalCellIndex) as! ToDo
     let goalObject = todoObject.goal
     let goalCell = tableView.dequeueReusableCell(withIdentifier: HistoryGoalCell.reuseIdentifier, for: indexPath) as! HistoryGoalCell
     delegate?.configureHistoryGoalCell(at: indexPath, goalCell, for: goalObject)
     }
     let historyTaskCellIndex = IndexPath(row: indexPath.row - 1, section: indexPath.section)
     let todoObject = self.fetchedResultsController.object(at: historyTaskCellIndex) as! ToDo
     let todoCell = tableView.dequeueReusableCell(withIdentifier: HistoryTaskCell.reuseIdentifier, for: indexPath) as! HistoryTaskCell
     delegate?.configureHistoryTaskCell(at: indexPath, todoCell, for: todoObject)
     return todoCell
*/
  }
}
