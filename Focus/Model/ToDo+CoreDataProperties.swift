//
//  ToDo+CoreDataProperties.swift
//  Focus
//
//  Created by Scott Bolin on 6/27/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//
//

import Foundation
import CoreData


extension ToDo {
  
  @nonobjc public class func todoFetchRequest() -> NSFetchRequest<ToDo> {
    return NSFetchRequest<ToDo>(entityName: "ToDo")
  }
  
  @NSManaged public var id: UUID
  @NSManaged public var todo: String
  @NSManaged public var todoCompleted: Bool
  @NSManaged public var todoDateCreated: Date
  @NSManaged public var todoDateCompleted: Date?
  @NSManaged public var goal: Goal
  
  @objc var groupByYear: String {
    get {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy"
      return dateFormatter.string(from: todoDateCreated)
    }
  }
  
  @objc var groupByMonth: String {
    get {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "MMM yyyy"
      return dateFormatter.string(from: todoDateCreated)
    }
  }
  
  @objc var groupByWeek: String {
    get {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "w Y"
      return dateFormatter.string(from: todoDateCreated)
    }
  }
  
  @objc var groupByDay: String {
    get {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "d MMM"
      return dateFormatter.string(from: todoDateCreated)
    }
  }
}
