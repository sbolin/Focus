//
//  HistoryViewController.swift
//  Focus
//
//  Created by Scott Bolin on 4/30/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController {
    
    //MARK: - Properties
  let delegate = HistoryViewDelegate()
  var dataSource: HistoryViewDataSource<ToDo, HistoryViewController>!
  var fetchedResultsController: NSFetchedResultsController<ToDo>!
  var predicate: NSPredicate?
  var statistics = Statistics()

  
//  var fetchRequest: NSFetchRequest<Goal>?
//  var goals: [Goal] = []
//  var asyncFetchRequest: NSAsynchronousFetchResult<Goal>?
    
    
    //MARK:- IBOutlets
    @IBOutlet weak var historyTableView: UITableView!
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTableView.delegate = delegate
        setupTableView()
    }
  func setupTableView() {
    print("setupTableView")
    if fetchedResultsController == nil {
      fetchedResultsController = CoreDataController.shared.fetchedToDoByMonthController
    }
    do {
      try fetchedResultsController.performFetch()
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

extension HistoryViewController: HistorySection0HeaderDelegate {
  func configureHistorySection0HeaderView(at section: Int, _ view: HistorySection0HeaderView, headerLabel: String?) {
    let label = headerLabel ?? "No Section"
    view.configureHistorySection0View(at: section, with: label)
  }
}

