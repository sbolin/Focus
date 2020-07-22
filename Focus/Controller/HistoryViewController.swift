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
  
  var fetchedToDoByMonthResultsController = CoreDataController.shared.fetchedToDoByMonthController
  var fetchedGoalByMonthResultsController = CoreDataController.shared.fetchedGoalByMonthController
  
/*
  var predicate: NSPredicate?
  var statistics = Statistics()
  
  //MARK: - Date setup for Predicates
  let lastDay = Date().addingTimeInterval(-60 * 60 * 24) as NSDate
  let lastWeek = Date().addingTimeInterval(-60 * 60 * 24 * 7) as NSDate
  let lastMonth = Date().addingTimeInterval(-60 * 60 * 24 * 30) as NSDate
  let last6Month = Date().addingTimeInterval(-60 * 60 * 24 * 183) as NSDate
  let lastYear = Date().addingTimeInterval(-60 * 60 * 24 * 365) as NSDate
  let allTime = Date().addingTimeInterval(-60 * 60 * 24 * 365 * 10) as NSDate // 10 year to show all todos.
  
  
  //MARK: - Predicates
  //MARK: Date Goal Predicates
  lazy var allGoalPredicate: NSPredicate = {
    return NSPredicate(format: "%K > %@", #keyPath(Goal.goalDateCreated), allTime)
  }()
  
  lazy var pastWeekGoalPredicate: NSPredicate = {
    return NSPredicate(format: "%K > %@", #keyPath(Goal.goalDateCreated), lastWeek)
  }()
  
  lazy var pastMonthGoalPredicate: NSPredicate = {
    return NSPredicate(format: "%K > %@", #keyPath(Goal.goalDateCreated), lastMonth)
  }()
  
  lazy var past6MonthGoalPredicate: NSPredicate = {
    return NSPredicate(format: "%K > %@", #keyPath(Goal.goalDateCreated), last6Month)
  }()
  
  lazy var pastYearGoalPredicate: NSPredicate = {
    return NSPredicate(format: "%K > %@", #keyPath(Goal.goalDateCreated), lastYear)
  }()
  
  
  //MARK: Date ToDo Predicates
  lazy var allToDoPredicate: NSPredicate = {
    return NSPredicate(format: "%K > %@", #keyPath(ToDo.todoDateCreated), allTime)
  }()
  
  lazy var pastWeekToDoPredicate: NSPredicate = {
    return NSPredicate(format: "%K > %@", #keyPath(ToDo.todoDateCreated), lastWeek)
  }()
  
  lazy var pastMonthToDoPredicate: NSPredicate = {
    return NSPredicate(format: "%K > %@", #keyPath(ToDo.todoDateCreated), lastMonth)
  }()
  
  lazy var past6MonthToDoPredicate: NSPredicate = {
    return NSPredicate(format: "%K > %@", #keyPath(ToDo.todoDateCreated), last6Month)
  }()
  
  lazy var pastYearToDoPredicate: NSPredicate = {
    return NSPredicate(format: "%K > %@", #keyPath(ToDo.todoDateCreated), allTime)
  }()
*/
  
  //MARK:- IBOutlets
  @IBOutlet weak var historyTableView: UITableView!
  
  //MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    historyTableView.delegate = delegate
    setupTableView()
//    statisticsSetup()
    historyTableView.reloadData()
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
  
  /*
  func statisticsSetup() {
    print("statisticsSetup")
    fetchedToDoByMonthResultsController.delegate = self  //
    fetchedToDoByMonthResultsController.fetchRequest.predicate = allToDoPredicate  //
    fetchedGoalByMonthResultsController.delegate = self  //
    fetchedGoalByMonthResultsController.fetchRequest.predicate = allGoalPredicate  //
    
    let frc1 = fetchedToDoByMonthResultsController
    let frc2 = fetchedGoalByMonthResultsController
    
    do {
      try frc1.performFetch()
    } catch {
      print("Fetch frc1 failed")
    }
    
    do {
      try frc2.performFetch()
    } catch {
      print("Fetch frc2 failed")
    }
    
    guard let todoSections = frc1.sections?.count else { return }
    for section in 0...(todoSections - 1) {
      statistics.todoDuration.append(0)
      guard let todoSectionObject = frc1.sections?[section].objects as? [ToDo] else { return }
      statistics.todoCount.append(todoSectionObject.count)
      let tempCount = todoSectionObject.filter { (todo) -> Bool in
        todo.todoCompleted == true
      }.count
      statistics.todoComplete.append(tempCount)
      for todo in todoSectionObject {
        if todo.todoCompleted {
          let diffComponents = Calendar.current.dateComponents([.day], from: todo.todoDateCreated, to: todo.todoDateCompleted!)
          statistics.todoDuration[section] += diffComponents.day!
        }
      }
      statistics.todoIncomplete.append(statistics.todoCount[section] - statistics.todoComplete[section])
      print("    \(section)        \(statistics.todoCount[section])           \(statistics.todoComplete[section])          \(statistics.todoIncomplete[section])          \(statistics.todoDuration[section])")
    }
    
    
    
    guard let goalSections = frc2.sections?.count else { return }
    for section in 0...(goalSections - 1) {
      statistics.goalDuration.append(0)
      guard let goalSectionObject = frc2.sections?[section].objects as? [Goal] else { return }
      statistics.goalCount.append(goalSectionObject.count)
      let tempCount = goalSectionObject.filter { (goal) -> Bool in
        goal.goalCompleted == true
      }.count
      statistics.goalComplete.append(tempCount)
      for goal in goalSectionObject {
        if goal.goalCompleted {
          let diffComponents = Calendar.current.dateComponents([.day], from: goal.goalDateCreated, to: goal.goalDateCompleted!)
          statistics.goalDuration[section] += diffComponents.day!
        }
      }
      statistics.goalIncomplete.append(statistics.goalCount[section] - statistics.goalComplete[section])
      print("    \(section)        \(statistics.goalCount[section])           \(statistics.goalComplete[section])          \(statistics.goalIncomplete[section])           \(statistics.goalDuration[section])")
    }
  }
 */
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
  func configureHistorySection0HeaderView(_ view: HistorySection0HeaderView, at section: Int, headerLabel: String?) {
    let label = headerLabel ?? "No Section"
    view.configureHistorySection0View(at: section, with: label)
  }
}

