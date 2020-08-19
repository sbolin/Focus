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
  
  let all: StatTimePeriod = .all
  let allByMonth: StatTimePeriod = .allByMonth
  let lastDay: StatTimePeriod = .lastday
  let lastMonth: StatTimePeriod = .lastmonth
  let lastSixMonths: StatTimePeriod = .lastSixMonths
  let lastWeek: StatTimePeriod = .lastweek
  let lastYear: StatTimePeriod = .lastYear
  
  var statistics = Statistics()
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  
  
}
