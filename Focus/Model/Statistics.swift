//
//  Statistics.swift
//  Focus
//
//  Created by Scott Bolin on 7/17/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import Foundation

enum StatTimePeriod {
  case lastweek
  case lastmonth
  case lastSixMonths
  case lastYear
  case allByMonth
  case all
}

struct Statistics {
  var todoCount: [Int]
  var todoComplete: [Int]
  var todoIncomplete: [Int]
  var todoDuration: [Int]
  var goalCount: [Int]
  var goalComplete: [Int]
  var goalIncomplete: [Int]
  var goalDuration: [Int]
  
  init() {
    todoCount = []
    todoComplete = []
    todoIncomplete = []
    todoDuration = []
    goalCount = []
    goalComplete = []
    goalIncomplete = []
    goalDuration = []
  }
}
