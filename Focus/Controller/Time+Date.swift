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
  
  func dateCaption(for date: Date) -> String {
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "dd MMM yyyy"
    dateformatter.timeStyle = .none
    dateformatter.timeZone = TimeZone.current
    
    return dateformatter.string(from: date)
  }
}
