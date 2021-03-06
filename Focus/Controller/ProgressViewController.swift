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

  fileprivate var statTimePeriod = StatTimePeriod.all
  let statFactory = StatisticsFactory()
  var statistics = Statistics()
  
  // Statistics properties
  var timePeriod = [String]()
  
  var todoTotalData = [Double]()
  var todoCompletedData = [Double]()
  var todoIncompleteDate = [Double]()
  var todoDurationData = [Double]()
  
  var goalTotalData = [Double]()
  var goalCompletedData = [Double]()
  var goalIncompleteData = [Double]()
  var goalDurationData = [Double]()
    
  lazy var formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 1
    
    return formatter
  }()

  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    statTimePeriod = StatTimePeriod.lastweek
    statistics = getStats(timePeriod: statTimePeriod)
    setupData(statistics: statistics)
    setupChart()
    updateChart()
    
  }
// MARK: - Get time period from UISegmented Control
  @IBAction func weekMonthToggled(_ sender: UISegmentedControl) {
    
    switch sender.selectedSegmentIndex {
    case 0:
      statTimePeriod = StatTimePeriod.lastweek
      
    case 1:
      statTimePeriod = StatTimePeriod.lastmonth
      
    case 2:
      statTimePeriod = StatTimePeriod.lastSixMonths

    case 3:
      statTimePeriod = StatTimePeriod.lastYear
      
    case 4:
      statTimePeriod = StatTimePeriod.all

    default:
      break

    }
    // setup data and chart
    statistics = getStats(timePeriod: statTimePeriod)
    zeroData()
    setupData(statistics: statistics)
    setupChart()
    updateChart()
  }
  
  // MARK: - ChartView setup
  func setupChart() {
    chartView.delegate = self
    
    // behavior
    chartView.pinchZoomEnabled = false
    chartView.dragEnabled = false
    chartView.noDataText = "Loading Data"
    chartView.noDataTextColor = .systemOrange
    
    // design
    chartView.chartDescription?.enabled = false
    chartView.drawBarShadowEnabled = false
    chartView.drawValueAboveBarEnabled = true
    
    chartView.drawGridBackgroundEnabled = true
    chartView.drawBordersEnabled = true
    chartView.borderColor = .systemOrange
    chartView.borderLineWidth = 2
    chartView.gridBackgroundColor = .white
    chartView.backgroundColor = .white
    chartView.highlightFullBarEnabled = true
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
    legend.yOffset = 2
    legend.xOffset = 10
    legend.xEntrySpace = 12
    legend.yEntrySpace = 0
    
    // x-axis
    let xAxis = chartView.xAxis
    xAxis.labelFont = .systemFont(ofSize: 9, weight: .light)
    xAxis.centerAxisLabelsEnabled = true
    xAxis.drawAxisLineEnabled = false
    xAxis.valueFormatter = IndexAxisValueFormatter(values: timePeriod)
    xAxis.forceLabelsEnabled = false
    xAxis.xOffset = 0
    xAxis.yOffset = 4
    
    // y-axis
    let leftAxisFormatter = NumberFormatter()
    leftAxisFormatter.maximumFractionDigits = 1
    
    let leftAxis = chartView.leftAxis
    leftAxis.labelFont = .systemFont(ofSize: 9, weight: .light)
    leftAxis.spaceTop = 0.1
    leftAxis.axisMinimum = 0
    leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
    leftAxis.drawAxisLineEnabled = false
    
    chartView.rightAxis.enabled = false
  }
  
  // Update chart based on time period selected
  func updateChart() {
    
    // set up group spacing
    let groupSpace = 0.1
    let barSpace = 0.025
    let barWidth = 0.2
    // (0.2 + 0.025) * 4 + 0.10 = 1.00 -> interval per "group"
    
    let groupCount = timePeriod.count
    let timeStart = 0
    
    var todoCompletedDataEntry: [BarChartDataEntry] = []
    var todoTotalDataEntry: [BarChartDataEntry] = []
    var todoDurationDataEntry: [BarChartDataEntry] = []

    var goalCompletedDataEntry: [BarChartDataEntry] = []
    var goalTotalDataEntry: [BarChartDataEntry] = []
    var goalDurationDataEntry: [BarChartDataEntry] = []

    for time in 0..<groupCount {
      
      let todoCompletedEntry = BarChartDataEntry(x: Double(time), y: todoCompletedData[time])
      let todoTotalEntry = BarChartDataEntry(x: Double(time), y: todoTotalData[time])
      let todoDurationEntry = BarChartDataEntry(x: Double(time), y: todoDurationData[time])
      let goalCompletedEntry = BarChartDataEntry(x: Double(time), y: goalCompletedData[time])
      let goalTotalEntry = BarChartDataEntry(x: Double(time), y: goalTotalData[time])
      let goalDurationEntry = BarChartDataEntry(x: Double(time), y: goalDurationData[time])
    
      todoCompletedDataEntry.append(todoCompletedEntry)
      todoTotalDataEntry.append(todoTotalEntry)
      todoDurationDataEntry.append(todoDurationEntry)
      goalCompletedDataEntry.append(goalCompletedEntry)
      goalTotalDataEntry.append(goalTotalEntry)
      goalDurationDataEntry.append(goalDurationEntry)
    }
    
    let todoCompleteDataSet = BarChartDataSet(entries: todoCompletedDataEntry, label: "To Do Complete")
    todoCompleteDataSet.setColor(UIColor(named: "LightBlue") ?? UIColor.cyan)

    let todoTotalDataSet = BarChartDataSet(entries: todoTotalDataEntry, label: "To Do Total")
    todoTotalDataSet.setColor(UIColor(named: "LightPurple") ?? UIColor.systemPurple)
    
    let todoDurationDataSet = LineChartDataSet(entries: todoTotalDataEntry, label: "ToDo Duration")
    todoDurationDataSet.setColor(UIColor(named: "LightPurple") ?? UIColor.systemPurple)

    let goalCompleteDataSet = BarChartDataSet(entries: goalCompletedDataEntry, label: "Goal Complete")
    goalCompleteDataSet.setColor(UIColor(named: "LightOrange") ?? UIColor.systemOrange)

    let goalTotalDataSet = BarChartDataSet(entries: goalTotalDataEntry, label: "Goal Total")
    goalTotalDataSet.setColor(UIColor(named: "LightRed") ?? UIColor.systemRed)
    
    let goalDurationDataSet = LineChartDataSet(entries: goalTotalDataEntry, label: "Goal Duration")
    goalDurationDataSet.setColor(UIColor(named: "LightRed") ?? UIColor.systemRed)

    let barData = BarChartData(dataSets: [todoCompleteDataSet, todoTotalDataSet, goalCompleteDataSet, goalTotalDataSet])
    barData.setValueFont(.systemFont(ofSize: 10, weight: .light))
    barData.setValueFormatter(DataValueFormatter())
    
    barData.barWidth = barWidth
    
    chartView.xAxis.axisMinimum = Double(timeStart)
    chartView.xAxis.axisMaximum = Double(timeStart) + barData.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(groupCount)
    chartView.xAxis.labelCount = groupCount
    
    chartView.data = barData
    chartView.groupBars(fromX: Double(timeStart), groupSpace: groupSpace, barSpace: barSpace)
    chartView.animate(yAxisDuration: 1.5, easingOption: ChartEasingOption.easeInOutQuart)
    
    chartView.notifyDataSetChanged()
  }
  
  //MARK: - Get Statistics
  func setupData(statistics: Statistics) {
    
    let sectionCount = statistics.goalCount.count
    for section in 0..<sectionCount {
      
      timePeriod.append(statistics.sectionName[section])
      todoTotalData.append(Double(statistics.todoCount[section]))
      todoCompletedData.append(Double(statistics.todoComplete[section]))
      todoIncompleteDate.append(Double(statistics.todoIncomplete[section]))
      todoDurationData.append(Double(statistics.todoDuration[section]))
      
      goalTotalData.append(Double(statistics.goalCount[section]))
      goalCompletedData.append(Double(statistics.goalComplete[section]))
      goalIncompleteData.append(Double(statistics.goalIncomplete[section]))
      goalDurationData.append(Double(statistics.goalDuration[section]))
    }
  }
  
  // zero data when switching between time periods
  func zeroData() {
    
    timePeriod = [String]()
    todoTotalData = [Double]()
    todoCompletedData = [Double]()
    todoIncompleteDate = [Double]()
    todoDurationData = [Double]()
    goalTotalData = [Double]()
    goalCompletedData = [Double]()
    goalIncompleteData = [Double]()
    goalDurationData = [Double]()

  }
  // get statistics for given timePeriod
  func getStats(timePeriod: StatTimePeriod) -> Statistics {
    return statFactory.stats(statType: statTimePeriod)
  }
}
