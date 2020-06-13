//
//  ProgressViewController.swift
//  Focus
//
//  Created by Scott Bolin on 4/30/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit
import CoreData

class ProgressViewController: UIViewController {
  
  let goal = [Goal]()
  
  @IBOutlet weak var progressView: UIView!
  @IBOutlet weak var weekMonthSwitch: UISegmentedControl!
  
  var fetchedYearResultsController = CoreDataController.shared.fetchedToDoByYearController
  var fetchedMonthResultsController = CoreDataController.shared.fetchedToDoByMonthController
  var fetchedWeekResultsController = CoreDataController.shared.fetchedToDoByWeekController

  
  let lastDay = Date().addingTimeInterval(-60 * 60 * 24) as NSDate
  let lastWeek = Date().addingTimeInterval(-60 * 60 * 24 * 7) as NSDate
  let lastMonth = Date().addingTimeInterval(-60 * 60 * 24 * 30) as NSDate
  let last6Month = Date().addingTimeInterval(-60 * 60 * 24 * 183) as NSDate
  let lastYear = Date().addingTimeInterval(-60 * 60 * 24 * 365) as NSDate
  let allTime = Date().addingTimeInterval(-60 * 60 * 24 * 365 * 10) as NSDate // 10 year to show all notes.
  
  //MARK: - Predicates
  lazy var allGoalPredicate: NSPredicate = {
    return NSPredicate(format: "%K > %@", #keyPath(Goal.goalDateCreated), allTime)
  }()
  
  lazy var goalCompletedPredicate: NSPredicate = {
    return NSPredicate(format: "%K = %d", #keyPath(Goal.goalCompleted), true)
  }()
  
  lazy var allToDoPredicate: NSPredicate = {
    return NSPredicate(format: "%K > %@", #keyPath(ToDo.todoDateCreated), allTime)
  }()
  
  lazy var todoCompletedPredicate: NSPredicate = {
    return NSPredicate(format: "%K = %d", #keyPath(ToDo.todoCompleted), true)
  }()
  
  
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let request: NSFetchRequest<ToDo> = ToDo.todoFetchRequest()
    let defaultTime = weekMonthSwitch.titleForSegment(at: 0)!
    
    
    // Do any additional setup after loading the view.
  }
  
  
  @IBAction func weekMonthToggled(_ sender: UISegmentedControl) {
    guard let selectedValue = sender.titleForSegment(at: sender.selectedSegmentIndex) else { return }
    var predicate = ""
    
    switch sender.selectedSegmentIndex {
    case 0:
      print("Week Selected")
      predicate = "week"
    case 1:
      print("Month Selected")
      predicate = "month"
    case 2:
      print("Year Selected")
      predicate = "year"
    default:
      break
    }
    
    
  }
  
  //MARK: - Counting Methods
  func getEntityCount(for entityName: String, with predicate: NSPredicate) -> Int? {
    let goalFetchRequest = NSFetchRequest<NSNumber>(entityName: entityName)
    
    goalFetchRequest.predicate = nil
    goalFetchRequest.fetchLimit = 0
    
    goalFetchRequest.resultType = .countResultType
    goalFetchRequest.predicate = predicate
    
    do {
      let countResult = try CoreDataController.shared.managedContext.fetch(goalFetchRequest)
      return countResult.first!.intValue
    } catch let error as NSError {
      print("count not fetched \(error), \(error.userInfo)")
      return nil
    }
  }
  
  // Goal count label
  func makeLabel(count: Int, quantifier: String) -> String {
    let quantifierPluralized = count == 1 ? quantifier : "\(quantifier)s"
    return "\(count) \(quantifierPluralized)"
  }
  
  // Note count label
  func makeContinuingLabel(firstLabel: String, count: Int, quantifier: String) -> String {
    let quantifierPluralized = count == 1 ? quantifier : "\(quantifier)s"
    return firstLabel + " / \(count) \(quantifierPluralized)"
  }
  
}
