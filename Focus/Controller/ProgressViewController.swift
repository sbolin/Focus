//
//  ProgressViewController.swift
//  Focus
//
//  Created by Scott Bolin on 4/30/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit
import CoreData
import Charts


class ProgressViewController: UIViewController, ChartViewDelegate {
  
  @IBOutlet weak var progressView: BarChartView!
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
    setupChart()
    updateChart()

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
    updateChart()
  }
  
  func setupChart() {
    progressView.delegate = self
    progressView.drawBarShadowEnabled = false
    progressView.drawValueAboveBarEnabled = true
    progressView.fitBars = true
    progressView.drawBordersEnabled = true
    progressView.drawGridBackgroundEnabled = true
    progressView.borderColor = .systemOrange
    progressView.gridBackgroundColor = .white
    progressView.chartDescription?.text = "Progress Summary"
    

  }
  
  func updateChart() {
    // dummy data for now...
    let todoCompletedDataEntry1 = BarChartDataEntry(x: 1.0, y: 5.0)
    let todoTotalDataEntry1 = BarChartDataEntry(x: 2.0, y: 7.0)
    let todoCompletedDataEntry2 = BarChartDataEntry(x: 3.0, y: 4.0)
    let todoTotalDataEntry2 = BarChartDataEntry(x: 4.0, y: 6.0)
    let todoCompletedDataEntry3 = BarChartDataEntry(x: 5.0, y: 7.0)
    let todoTotalDataEntry3 = BarChartDataEntry(x: 6.0, y: 10.0)
    
    let goalCompletedDataEntry1 = BarChartDataEntry(x: 1.0, y: 2.0)
    let goalTotalDataEntry1 = BarChartDataEntry(x: 2.0, y: 3.0)
    let goalCompletedDataEntry2 = BarChartDataEntry(x: 3.0, y: 3.0)
    let goalTotalDataEntry2 = BarChartDataEntry(x: 4.0, y: 8.0)
    let goalCompletedDataEntry3 = BarChartDataEntry(x: 5.0, y: 5.0)
    let goalTotalDataEntry3 = BarChartDataEntry(x: 6.0, y: 9.0)
    
    let todoCompleteDataSet = BarChartDataSet(entries: [todoCompletedDataEntry1, todoCompletedDataEntry2, todoCompletedDataEntry3], label: "To Do Complete")
    let todoTotalDataSet = BarChartDataSet(entries: [todoTotalDataEntry1, todoTotalDataEntry2, todoTotalDataEntry3], label: "To Do Total")
    let goalCompleteDataSet = BarChartDataSet(entries: [goalCompletedDataEntry1, goalCompletedDataEntry2, goalCompletedDataEntry3], label: "Goal Complete")
    let goalTotalDataSet = BarChartDataSet(entries: [goalTotalDataEntry1, goalTotalDataEntry2, goalTotalDataEntry3], label: "Goal Total")
    let data = BarChartData(dataSets: [todoCompleteDataSet, todoTotalDataSet, goalCompleteDataSet, goalTotalDataSet])
    data.barWidth = 0.9
//    data.groupBars(fromX: 0, groupSpace: 100, barSpace: 20)
    progressView.data = data
    progressView.notifyDataSetChanged()
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
      print("Section Title \(statistics.sectionName[section])")

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
