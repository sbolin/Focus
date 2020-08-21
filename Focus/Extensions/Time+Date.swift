//
//  Time+Date.swift
//  Focus
//
//  Created by Scott Bolin on 5/23/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import Foundation

extension Date {
  
  //MARK: -  Date Functions
  func startOfDay(for date: Date) -> Date {
    var calendar = Calendar.current
    calendar.timeZone = TimeZone.current
    return calendar.startOfDay(for: date)
  }
  
  func endOfDay(for date: Date) -> Date {
    var calendar = Calendar.current
    calendar.timeZone = TimeZone.current
    return calendar.startOfDay(for: date).advanced(by: TimeInterval(12 * 60 * 60))
  }
}
