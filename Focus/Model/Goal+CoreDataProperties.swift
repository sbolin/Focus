//
//  Goal+CoreDataProperties.swift
//  Focus
//
//  Created by Scott Bolin on 6/27/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//
//

import Foundation
import CoreData


extension Goal {
  
  @nonobjc public class func goalFetchRequest() -> NSFetchRequest<Goal> {
    return NSFetchRequest<Goal>(entityName: "Goal")
  }
  
  @NSManaged public var goal: String
  @NSManaged public var goalCompleted: Bool
  @NSManaged public var goalDateCreated: Date
  @NSManaged public var goalDateCompleted: Date?
  @NSManaged public var todos: Set<ToDo>
  
  @objc public var groupByYear: String {
    get {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy"
      return dateFormatter.string(from: goalDateCreated)
    }
  }
  
  @objc public var groupByMonth: String {
    get {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "MMM yyyy"
      return dateFormatter.string(from: goalDateCreated)
    }
  }
  
  @objc public var groupByWeek: String {
    get {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "w Y"
      return dateFormatter.string(from: goalDateCreated)
    }
  }
  
  @objc public var groupByDay: String {
    get {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "d"
      return dateFormatter.string(from: goalDateCreated)
    }
  }
  
}

// MARK: Generated accessors for todos
extension Goal {
  
  @objc(addTodosObject:)
  @NSManaged public func addToTodos(_ value: ToDo)
  
  @objc(removeTodosObject:)
  @NSManaged public func removeFromTodos(_ value: ToDo)
  
  @objc(addTodos:)
  @NSManaged public func addToTodos(_ values: Set<ToDo>)
  
  @objc(removeTodos:)
  @NSManaged public func removeFromTodos(_ values: Set<ToDo>)
  
}
