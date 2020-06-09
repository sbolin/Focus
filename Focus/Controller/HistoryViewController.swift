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
  
  var fetchRequest: NSFetchRequest<Goal>?
  var goals: [Goal] = []
  var asyncFetchRequest: NSAsynchronousFetchResult<Goal>?
    
    
    //MARK:- IBOutlets
    @IBOutlet weak var historyTableView: UITableView!
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTableView.delegate = delegate
        setupTableView()
        // Do any additional setup after loading the view.
    }
    
  
  func setupTableView() {
    if fetchedResultsController == nil {
      fetchedResultsController = CoreDataController.shared.fetchedToDoGoalResultsController
    }
    
    
    
    
    
    fetchedResultsController.fetchRequest.predicate = predicate
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
  func configureHistoryToDoCell(at indexPath: IndexPath, _ cell: HistoryTaskCell, for object: ToDo) {
    cell.configureHistoryTaskCell(at: indexPath, for: object)

  }
  
  func configureHistoryGoalCell(at indexPath: IndexPath, _ cell: HistoryGoalCell, for object: Goal) {
    cell.configureHistoryGoalCell(at: indexPath, for: object)

  }
}
