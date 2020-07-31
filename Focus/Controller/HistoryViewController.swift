//
//  HistoryViewController.swift
//  Focus
//
//  Created by Scott Bolin on 4/30/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController, NSFetchedResultsControllerDelegate {
  
  //MARK: - Properties
  let delegate = HistoryViewDelegate()
  var dataSource: HistoryViewDataSource<ToDo, HistoryViewController>!
  var fetchedResultsController: NSFetchedResultsController<ToDo>!
  
  //MARK:- IBOutlets
  @IBOutlet weak var historyTableView: UITableView!
  
  //MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    historyTableView.delegate = delegate
    setupTableView()
    historyTableView.reloadData()
  }
  func setupTableView() {
    if fetchedResultsController == nil {
      fetchedResultsController = CoreDataController.shared.fetchedToDoByMonthController
    }
    do {
      try fetchedResultsController.performFetch()
      // set expanded section to true as default
      for _ in fetchedResultsController.sections! {
        // use SectionExpanded class here
        CoreDataController.shared.sectionExpanded.append(true)
      }
      //
      historyTableView.reloadData()
    } catch {
      print("Fetch failed")
    }
    dataSource = HistoryViewDataSource(tableView: historyTableView, fetchedResultsController: fetchedResultsController, delegate: self)
  }
}

extension HistoryViewController: HistoryViewDataSourceDelegate {
  func configureHistorySummaryCell(at indexPath: IndexPath, _ cell: HistorySummaryCell, statistics: Statistics) {
    cell.configureHistorySummaryCell(at: indexPath, statistics: statistics)
  }
  
  func configureHistoryTaskCell(at indexPath: IndexPath, _ cell: HistoryTaskCell, for object: ToDo) {
    cell.configureHistoryTaskCell(at: indexPath, for: object)
  }
  
  func configureHistoryGoalCell(at indexPath: IndexPath, _ cell: HistoryGoalCell, for object: Goal) {
    cell.configureHistoryGoalCell(at: indexPath, for: object)
  }
}

