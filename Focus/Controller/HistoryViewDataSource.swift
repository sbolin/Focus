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
  func configureHistorySummaryCell(at indexPath: IndexPath, _ cell: HistorySummaryCell, statistics: Statistics)
}

class HistoryViewDataSource<Result: NSFetchRequestResult, Delegate: HistoryViewDataSourceDelegate>: NSObject, UITableViewDataSource, NSFetchedResultsControllerDelegate {
  
  // MARK:- Private Parameters
  fileprivate let tableView: UITableView
  fileprivate var fetchedResultsController: NSFetchedResultsController<Result>
  fileprivate weak var delegate: Delegate!
  
  fileprivate var todoRowsInSection: Int?
  fileprivate var goalRowsInSection: Int?
  
  var statistics = Statistics()
  
 // fileprivate var todoObject: ToDo?
//  fileprivate var goalObject: Goal?
  
//  var goalFetch = [ToDo]()
  
//  var undoneGoalCount = 0
//  var doneGoalCount = 0
//  var undoneToDoCount = 0
//  var doneToDoCount = 0
  
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
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    todoRowsInSection = fetchedResultsController.sections?[section].numberOfObjects
    if var numberOfRows = todoRowsInSection {
      goalRowsInSection = numberOfRows / 3
      numberOfRows += goalRowsInSection ?? 0
      return (numberOfRows + 1) // +1 for summaryCell
    } else {
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0 {
      let summaryCell = tableView.dequeueReusableCell(withIdentifier: HistorySummaryCell.reuseIdentifier, for: indexPath) as! HistorySummaryCell
      delegate?.configureHistorySummaryCell(at: indexPath, summaryCell, statistics: statistics)
      return summaryCell
    } else if (indexPath.row - 1) % 4 == 0 {
      let offset: Int = indexPath.row / 4 + 1
      let previousIndex = IndexPath(row: indexPath.row - offset, section: indexPath.section)
      let todoObject = self.fetchedResultsController.object(at: previousIndex) as! ToDo
      let goalObject = todoObject.goal
      let goalCell = tableView.dequeueReusableCell(withIdentifier: HistoryGoalCell.reuseIdentifier, for: indexPath) as! HistoryGoalCell
      delegate?.configureHistoryGoalCell(at: indexPath, goalCell, for: goalObject)
      return goalCell
    } else {
      let offset: Int = indexPath.row / 4 + 2
      let previousIndex = IndexPath(row: indexPath.row - offset, section: indexPath.section)
      let todoObject = self.fetchedResultsController.object(at: previousIndex) as! ToDo
      let noteCell = tableView.dequeueReusableCell(withIdentifier: HistoryTaskCell.reuseIdentifier, for: indexPath) as! HistoryTaskCell
      delegate?.configureHistoryTaskCell(at: indexPath, noteCell, for: todoObject)
      return noteCell
    }
  }
}
