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
  
  fileprivate var todoRowsInSection: Int?
  fileprivate var goalRowsInSection: Int?
  
  fileprivate var todoObject: ToDo?
  fileprivate var goalObject: Goal?
  
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
    // working
    /*
    print("section: \(section)")
    todoRowsInSection = fetchedResultsController.sections?[section].numberOfObjects
    print("todoRowsInSection: \(todoRowsInSection)")
    if var numberOfRows = todoRowsInSection {
      goalRowsInSection = (numberOfRows - 1) / 3 + 1
      print("goalRowsInSection: \(goalRowsInSection)")
      numberOfRows += goalRowsInSection ?? 1
      return numberOfRows
    } else {
      return 0
    }
    */
    // old working:

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
//    let offset: Int = 1
    let previousIndex = IndexPath(row: indexPath.row - offset, section: indexPath.section)
    let noteObject = self.fetchedResultsController.object(at: previousIndex) as! ToDo
    let noteCell = tableView.dequeueReusableCell(withIdentifier: HistoryTaskCell.reuseIdentifier, for: indexPath) as! HistoryTaskCell
    delegate?.configureHistoryTaskCell(at: indexPath, noteCell, for: noteObject)
    return noteCell
/*
// get counts from search
    let counts = getResultsCounts(indexPath: indexPath)
    let totalGoalCount = counts[0]
    let doneGoalCount = counts[1]
    let undoneGoalCount = totalGoalCount - doneGoalCount
    let totalToDoCount = counts[2]
    let doneToDoCount = counts[4]
    let undoneToDoCount = totalToDoCount - doneToDoCount
    
    print("\(doneGoalCount) out of \(totalGoalCount) goals completed")
    let summaryCell = tableView.dequeueReusableCell(withIdentifier: HistorySummaryCell.reuseIdentifier, for: indexPath) as! HistorySummaryCell
    delegate?.configureHistorySummaryCell(at: indexPath, summaryCell, undoneGoalCount: undoneGoalCount, doneGoalCount: doneGoalCount, undoneToDoCount: undoneToDoCount, doneToDoCount: doneToDoCount)
    return summaryCell
*/
  }
  
  func getResultsCounts(indexPath: IndexPath) -> [Int] {
    let todos = self.fetchedResultsController.fetchedObjects as! [ToDo]
    let counts = [3,2,3,2]
    
    
    return counts
  }
}
