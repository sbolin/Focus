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
  
  @IBOutlet weak var chartView: BarChartView!
  @IBOutlet weak var timeSwitch: UISegmentedControl!
  
  var fetchedYearResultsController = CoreDataController.shared.fetchedToDoByYearController
  var fetchedMonthResultsController = CoreDataController.shared.fetchedToDoByMonthController
  var fetchedWeekResultsController = CoreDataController.shared.fetchedToDoByWeekController

  fileprivate var statTimePeriod = StatTimePeriod.all
  let statFactory = StatisticsFactory()
  var statistics = Statistics()
  
  var todoCompletedData: [Double]!
  var todoTotalData: [Double]!
  var todoDurationData: [Double]!
  var goalCompletedData: [Double]!
  var goalTotalData: [Double]!
  var goalDurationData: [Double]!
  
  let timePeriod = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
  
  lazy var formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 1
    
    return formatter
  }()


  
  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupChart()
    updateChart()
    chartView.noDataText = "Loading Data"
    chartView.noDataTextColor = .systemOrange

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
    chartView.delegate = self
    
    // behavior
    chartView.pinchZoomEnabled = false
    chartView.dragEnabled = false
    
    // design
    chartView.chartDescription?.enabled = false
    chartView.drawBarShadowEnabled = false
    chartView.drawValueAboveBarEnabled = true
    chartView.drawBordersEnabled = true
    chartView.drawGridBackgroundEnabled = true
    chartView.fitBars = true
    chartView.borderColor = .systemOrange
    chartView.gridBackgroundColor = .white
    chartView.highlightFullBarEnabled = true
    chartView.chartDescription?.text = "Progress Summary"
    chartView.xAxis.labelPosition = .bottom
    
    //legend
    let legend = chartView.legend
    legend.horizontalAlignment = .left
    legend.verticalAlignment = .bottom
    legend.orientation = .horizontal
    legend.form = .circle
    legend.formToTextSpace = 4
    legend.drawInside = false
    legend.font = .systemFont(ofSize: 8, weight: .light)
    legend.yOffset = 0
    legend.xOffset = 10
    legend.xEntrySpace = 12
    legend.yEntrySpace = 0
    
    // x-axis
    let xAxis = chartView.xAxis
    xAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
    xAxis.axisMinimum = 0.0
    xAxis.axisMaximum = 0.0
    xAxis.granularityEnabled = true
    xAxis.granularity = 1
    xAxis.centerAxisLabelsEnabled = true
    xAxis.drawAxisLineEnabled = false
    xAxis.valueFormatter = IndexAxisValueFormatter(values: timePeriod)
    xAxis.forceLabelsEnabled = true
    
    // y-axis
    let leftAxisFormatter = NumberFormatter()
    leftAxisFormatter.maximumFractionDigits = 1
    
    let leftAxis = chartView.leftAxis
    leftAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
    leftAxis.spaceTop = 0.1
    leftAxis.axisMinimum = 0
    leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
    leftAxis.drawAxisLineEnabled = false
    
    chartView.rightAxis.enabled = false
    chartView.rightAxis.drawAxisLineEnabled = false

  }
  
  func updateChart() {
    // dummy data for now...
    
    // set up group spacing
    let groupSpace = 0.08
    let barSpace = 0.03
    let barWidth = 0.2
    // (0.2 + 0.03) * 4 + 0.08 = 1.00 -> interval per "group"
    
    let groupCount = 12 + 1
    let timeStart = 0
    let timeEnd = timeStart + groupCount
    
    todoCompletedData = [5, 7, 4, 6, 7, 4, 0, 8, 7, 3, 5, 9]
    todoTotalData = [6, 9, 6, 6, 9, 6, 3, 9, 9, 3, 6, 9]
    todoDurationData = [1, 3, 2, 2, 3, 2, 1, 3, 3, 1, 2, 3]
    goalCompletedData = [1, 2, 1, 2, 2, 1, 0, 2, 2, 1, 1, 3]
    goalTotalData = [2, 3, 2, 2, 3, 2, 1, 3, 3, 1, 2, 3]
    goalDurationData = [1, 3, 2, 2, 3, 2, 1, 3, 3, 1, 2, 3]

    var todoCompletedDataEntry: [BarChartDataEntry] = []
    var todoTotalDataEntry: [BarChartDataEntry] = []
    var todoDurationDataEntry: [BarChartDataEntry] = []

    var goalCompletedDataEntry: [BarChartDataEntry] = []
    var goalTotalDataEntry: [BarChartDataEntry] = []
    var goalDurationDataEntry: [BarChartDataEntry] = []

    for time in 0..<timePeriod.count {
      
      let todoCompletedEntry = BarChartDataEntry(x: Double(time), y: todoCompletedData[time])
      let todoTotalEntry = BarChartDataEntry(x: Double(time), y: todoTotalData[time])
      let todoDurationEntry = BarChartDataEntry(x: Double(time), y: todoDurationData[time])
      let goalCompletedEntry = BarChartDataEntry(x: Double(time), y: goalCompletedData[time])
      let goalTotalEntry = BarChartDataEntry(x: Double(time), y: goalTotalData[time])
      let goalDurationEntry = BarChartDataEntry(x: Double(time), y: goalDurationData[time])

      //      let todoCompletedEntry = BarChartDataEntry(x: Double(date), y: todoCompletedData[date], data: timePeriod[date])
//      let todoTotalEntry = BarChartDataEntry(x: Double(date), y: todoTotalData[date], data: timePeriod[date])
//      let todoDurationEntry = BarChartDataEntry(x: Double(date), y: todoDurationData[date], data: timePeriod[date])
//      let goalCompletedEntry = BarChartDataEntry(x: Double(date), y: goalCompletedData[date], data: timePeriod[date])
//      let goalTotalEntry = BarChartDataEntry(x: Double(date), y: goalTotalData[date], data: timePeriod[date])
//      let goalDurationEntry = BarChartDataEntry(x: Double(date), y: goalDurationData[date], data: timePeriod[date])
    
      todoCompletedDataEntry.append(todoCompletedEntry)
      todoTotalDataEntry.append(todoTotalEntry)
      todoDurationDataEntry.append(todoDurationEntry)
      goalCompletedDataEntry.append(goalCompletedEntry)
      goalTotalDataEntry.append(goalTotalEntry)
      goalDurationDataEntry.append(goalDurationEntry)
    }
    
    let todoCompleteDataSet = BarChartDataSet(entries: todoCompletedDataEntry, label: "To Do Complete")
    todoCompleteDataSet.setColor(UIColor(red: 104/255, green: 241/255, blue: 175/255, alpha: 1))

    let todoTotalDataSet = BarChartDataSet(entries: todoTotalDataEntry, label: "To Do Total")
    todoTotalDataSet.setColor(UIColor(red: 164/255, green: 228/255, blue: 251/255, alpha: 1))

    let goalCompleteDataSet = BarChartDataSet(entries: goalCompletedDataEntry, label: "Goal Complete")
    goalCompleteDataSet.setColor(UIColor(red: 242/255, green: 247/255, blue: 158/255, alpha: 1))

    let goalTotalDataSet = BarChartDataSet(entries: goalTotalDataEntry, label: "Goal Total")
    goalTotalDataSet.setColor(UIColor(red: 255/255, green: 102/255, blue: 0/255, alpha: 1))
    
    let data = BarChartData(dataSets: [todoCompleteDataSet, todoTotalDataSet, goalCompleteDataSet, goalTotalDataSet])
    data.setValueFont(.systemFont(ofSize: 10, weight: .light))
    
    data.barWidth = barWidth
    
    chartView.xAxis.axisMinimum = Double(timeStart)
    chartView.xAxis.axisMaximum = Double(timeStart) + data.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(groupCount)
    
    chartView.data = data
    chartView.groupBars(fromX: Double(timeStart), groupSpace: groupSpace, barSpace: barSpace)

    
    chartView.fitBars = true
    chartView.notifyDataSetChanged()
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
