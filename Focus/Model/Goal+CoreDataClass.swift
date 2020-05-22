//
//  Goal+CoreDataClass.swift
//  Focus
//
//  Created by Scott Bolin on 5/9/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//
//

import Foundation
import CoreData


public class Goal: NSManagedObject {
  
 @objc var groupByMonth: String {
    get {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "MMM yyyy"
      return dateFormatter.string(from: self.goalDateCreated)
    }
  }
 @objc var groupByWeek: String {
    get {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "w Y"
      return dateFormatter.string(from: self.goalDateCreated)
    }
  }
}
