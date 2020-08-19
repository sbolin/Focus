//
//  StatisticsTests.swift
//  FocusTests
//
//  Created by Scott Bolin on 8/18/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import XCTest
import CoreData
@testable import Focus


final class StatisticsTests: XCTestCase {
  
  //MARK: - Properties
  // Time
  let all: StatTimePeriod = .all
  let allByMonth: StatTimePeriod = .allByMonth
  let lastDay: StatTimePeriod = .lastday
  let lastMonth: StatTimePeriod = .lastmonth
  let lastSixMonths: StatTimePeriod = .lastSixMonths
  let lastWeek: StatTimePeriod = .lastweek
  let lastYear: StatTimePeriod = .lastYear
  
  // Statistics
  let statFactory = StatisticsFactory()
  var statistics = Statistics()
  
  // Stat results
  var totalGoals: Int = 0
  var totalToDos: Int = 0
  var totalCompleteGoals: Int = 0
  var totalCompleteTodos: Int = 0
  var totalIncompleteGoals: Int = 0
  var totalIncompleteTodos: Int = 0
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
    zeroData()
  }
  
  func getTotals(timePeriod: StatTimePeriod) {
    statistics = statFactory.stats(statType: timePeriod)
    
    totalGoals = (statistics.goalCount).reduce(0, +)
    totalToDos = (statistics.todoCount).reduce(0, +)
    totalCompleteGoals = (statistics.goalComplete).reduce(0, +)
    totalCompleteTodos = (statistics.todoComplete).reduce(0, +)
    totalIncompleteGoals = (statistics.goalIncomplete).reduce(0, +)
    totalIncompleteTodos = (statistics.todoIncomplete).reduce(0, +)
  }
  
  func zeroData() {
    
    totalGoals = 0
    totalToDos = 0
    totalCompleteGoals = 0
    totalCompleteTodos = 0
    totalIncompleteGoals = 0
    totalIncompleteTodos = 0
    
  }
  
  //MARK: - Tests
  func test_allStatistics() {
    getTotals(timePeriod: StatTimePeriod.all)
    
    // based on default goal/todo created
    XCTAssertEqual(totalGoals, 101)
    XCTAssertEqual(totalToDos, 303)
    XCTAssertEqual(totalCompleteGoals, 71)
    XCTAssertEqual(totalCompleteTodos, 267)
    XCTAssertEqual(totalIncompleteGoals, 30)
    XCTAssertEqual(totalIncompleteTodos, 36)
  }
  
  func test_allByMonthStatistics() {
    getTotals(timePeriod: StatTimePeriod.allByMonth)
    
    // based on default goal/todo created
    XCTAssertEqual(totalGoals, 101)
    XCTAssertEqual(totalToDos, 303)
    XCTAssertEqual(totalCompleteGoals, 71)
    XCTAssertEqual(totalCompleteTodos, 267)
    XCTAssertEqual(totalIncompleteGoals, 30)
    XCTAssertEqual(totalIncompleteTodos, 36)
  }
  
  func test_lastYearStatistics() {
    getTotals(timePeriod: StatTimePeriod.lastYear)
    
    // based on default goal/todo created
    XCTAssertEqual(totalGoals, 101)
    XCTAssertEqual(totalToDos, 303)
    XCTAssertEqual(totalCompleteGoals, 71)
    XCTAssertEqual(totalCompleteTodos, 267)
    XCTAssertEqual(totalIncompleteGoals, 30)
    XCTAssertEqual(totalIncompleteTodos, 36)
  }
  
  func test_lastSixMonthsStatistics() {
    getTotals(timePeriod: StatTimePeriod.lastSixMonths)
    
    // based on default goal/todo created
    XCTAssertEqual(totalGoals, 91)
    XCTAssertEqual(totalToDos, 273)
    XCTAssertEqual(totalCompleteGoals, 65)
    XCTAssertEqual(totalCompleteTodos, 241)
    XCTAssertEqual(totalIncompleteGoals, 26)
    XCTAssertEqual(totalIncompleteTodos, 32)
  }
  
  func test_lastMonthStatistics() {
    getTotals(timePeriod: StatTimePeriod.lastmonth)
    
    // based on default goal/todo created
    XCTAssertEqual(totalGoals, 31)
    XCTAssertEqual(totalToDos, 93)
    XCTAssertEqual(totalCompleteGoals, 20)
    XCTAssertEqual(totalCompleteTodos, 79)
    XCTAssertEqual(totalIncompleteGoals, 11)
    XCTAssertEqual(totalIncompleteTodos, 14)
  }
  
  func test_lastWeekStatistics() {
    getTotals(timePeriod: StatTimePeriod.lastweek)
    
    // based on default goal/todo created
    XCTAssertEqual(totalGoals, 8)
    XCTAssertEqual(totalToDos, 24)
    XCTAssertEqual(totalCompleteGoals, 6)
    XCTAssertEqual(totalCompleteTodos, 20)
    XCTAssertEqual(totalIncompleteGoals, 2)
    XCTAssertEqual(totalIncompleteTodos, 4)
  }
  
  func test_lastDayStatistics() {
    getTotals(timePeriod: StatTimePeriod.lastday)
    
    // based on default goal/todo created
    XCTAssertEqual(totalGoals, 2)
    XCTAssertEqual(totalToDos, 6)
    XCTAssertEqual(totalCompleteGoals, 1)
    XCTAssertEqual(totalCompleteTodos, 3)
    XCTAssertEqual(totalIncompleteGoals, 1)
    XCTAssertEqual(totalIncompleteTodos, 3)
  }
}
