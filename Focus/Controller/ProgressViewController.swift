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
  
  @IBOutlet weak var progressView: UIView!
  @IBOutlet weak var timeSwitch: UISegmentedControl!
  
  var fetchedYearResultsController = CoreDataController.shared.fetchedToDoByYearController
  var fetchedMonthResultsController = CoreDataController.shared.fetchedToDoByMonthController
  var fetchedWeekResultsController = CoreDataController.shared.fetchedToDoByWeekController

  fileprivate var statTimePeriod = StatTimePeriod.all
  let statFactory = StatisticsFactory()
  var statistics = Statistics()

  
  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
//    let request: NSFetchRequest<ToDo> = ToDo.todoFetchRequest()
//    let defaultTime = timeSwitch.titleForSegment(at: 0)!
    
    
  }
  
  
  @IBAction func weekMonthToggled(_ sender: UISegmentedControl) {
//    guard let selectedValue = sender.titleForSegment(at: sender.selectedSegmentIndex) else { return }
    
    switch sender.selectedSegmentIndex {
    case 0:
      print("Week Selected")
      statTimePeriod = StatTimePeriod.lastweek
      statistics = statFactory.stats(statType: statTimePeriod)
      
    case 1:
      print("Month Selected")
      statTimePeriod = StatTimePeriod.lastmonth
      statistics = statFactory.stats(statType: statTimePeriod)
      
    case 2:
      print("6 Month Selected")
      statTimePeriod = StatTimePeriod.lastSixMonths
      statistics = statFactory.stats(statType: statTimePeriod)

    case 3:
      print("Year Selected")
      statTimePeriod = StatTimePeriod.lastYear
      statistics = statFactory.stats(statType: statTimePeriod)

    default:
      break
    }
    setupData(statistics: statistics)
    
  }
  
  //MARK: - Get Statistics
  func setupData(statistics: Statistics) {
    let sectionCount = statistics.goalCount.count
    let totalGoals = (statistics.goalCount).reduce(0, +)
    let totalToDos = (statistics.todoCount).reduce(0, +)
    print("Total Goals: \(totalGoals)")
    print("Total ToDos: \(totalToDos)")
    for section in 0...(sectionCount - 1) {
      let goalsInSection = statistics.goalCount[section]
      let todosInSection = statistics.todoCount[section]
      print("Section \(section)")
      print("Goals in section: \(goalsInSection)")
      print("Completed goals: \(statistics.goalComplete[section])")
      print("Incomplete goals: \(statistics.goalIncomplete[section])")
      print("Goal duration: \(statistics.goalDuration[section])")
      print("\n")
      print("ToDos in section: \(todosInSection)")
      print("Completed todos: \(statistics.todoComplete[section])")
      print("Incomplete todos: \(statistics.todoIncomplete[section])")
      print("ToDo duration: \(statistics.todoDuration[section])")
      print("\n")
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
