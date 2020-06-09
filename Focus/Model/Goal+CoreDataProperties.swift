//
//  Goal+CoreDataProperties.swift
//  Focus
//
//  Created by Scott Bolin on 6/10/20.
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
    @NSManaged public var goalDateCompleted: Date?
    @NSManaged public var goalDateCreated: Date
    @NSManaged public var todos: Set<ToDo>

}

// MARK: Generated accessors for todos
extension Goal {

    @objc(addTodosObject:)
    @NSManaged public func addToTodos(_ value: ToDo)

    @objc(removeTodosObject:)
    @NSManaged public func removeFromTodos(_ value: ToDo)

    @objc(addTodos:)
    @NSManaged public func addToTodos(_ values: NSSet)

    @objc(removeTodos:)
    @NSManaged public func removeFromTodos(_ values: NSSet)

}
