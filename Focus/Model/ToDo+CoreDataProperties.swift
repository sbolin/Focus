//
//  ToDo+CoreDataProperties.swift
//  Focus
//
//  Created by Scott Bolin on 5/9/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//
//

import Foundation
import CoreData


extension ToDo {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDo> {
    return NSFetchRequest<ToDo>(entityName: "ToDo")
  }
  
  @NSManaged public var todo: String
  @NSManaged public var todoDateCreated: Date
  @NSManaged public var todoDateCompleted: Date?
  @NSManaged public var todoCompleted: Bool
  @NSManaged public var goal: Goal
  
}
