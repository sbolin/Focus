//
//  StatisticsFactory.swift
//  Focus
//
//  Created by Scott Bolin on 7/18/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import Foundation
import CoreData


class StatisticsFactory {
    
  var frc1 = CoreDataController.shared.fetchedToDoResultsController
  var frc2 = CoreDataController.shared.fetchedGoalResultsController
  
  //MARK: - Date setup for Predicates
  let lastDay = Date().addingTimeInterval(-60 * 60 * 24) as NSDate
  let lastWeek = Date().addingTimeInterval(-60 * 60 * 24 * 7) as NSDate
  let lastMonth = Date().addingTimeInterval(-60 * 60 * 24 * 30) as NSDate
  let last6Month = Date().addingTimeInterval(-60 * 60 * 24 * 183) as NSDate
  let lastYear = Date().addingTimeInterval(-60 * 60 * 24 * 365) as NSDate
  let allTime = Date().addingTimeInterval(-60 * 60 * 24 * 365 * 10) as NSDate // 10 year to show all todos.
  
  //MARK: - Predicates
  //MARK: Date Goal Predicates
  lazy var allGoalPredicate: NSPredicate = {
    return NSPredicate(format: "%K > %@", #keyPath(Goal.goalDateCreated), allTime)
  }()
  
  lazy var pastWeekGoalPredicate: NSPredicate = {
    return NSPredicate(format: "%K > %@", #keyPath(Goal.goalDateCreated), lastWeek)
  }()
  
  lazy var pastMonthGoalPredicate: NSPredicate = {
    return NSPredicate(format: "%K > %@", #keyPath(Goal.goalDateCreated), lastMonth)
  }()
  
  lazy var past6MonthGoalPredicate: NSPredicate = {
    return NSPredicate(format: "%K > %@", #keyPath(Goal.goalDateCreated), last6Month)
  }()
  
  lazy var pastYearGoalPredicate: NSPredicate = {
    return NSPredicate(format: "%K > %@", #keyPath(Goal.goalDateCreated), lastYear)
  }()
  
  //MARK: Date ToDo Predicates
  lazy var allToDoPredicate: NSPredicate = {
    return NSPredicate(format: "%K > %@", #keyPath(ToDo.todoDateCreated), allTime)
  }()
  
  lazy var pastWeekToDoPredicate: NSPredicate = {
    return NSPredicate(format: "%K > %@", #keyPath(ToDo.todoDateCreated), lastWeek)
  }()
  
  lazy var pastMonthToDoPredicate: NSPredicate = {
    return NSPredicate(format: "%K > %@", #keyPath(ToDo.todoDateCreated), lastMonth)
  }()
  
  lazy var past6MonthToDoPredicate: NSPredicate = {
    return NSPredicate(format: "%K > %@", #keyPath(ToDo.todoDateCreated), last6Month)
  }()
  
  lazy var pastYearToDoPredicate: NSPredicate = {
    return NSPredicate(format: "%K > %@", #keyPath(ToDo.todoDateCreated), allTime)
  }()
  
 
  func stats(statType: StatTimePeriod) -> Statistics {
    
    var statistics = Statistics()
    
    switch statType {
    case .all:
      frc1.fetchRequest.predicate = allToDoPredicate
      frc2.fetchRequest.predicate = allGoalPredicate
    case .allByMonth:
      frc1 = CoreDataController.shared.fetchedToDoByMonthController
      frc1.fetchRequest.predicate = allToDoPredicate
      frc2 = CoreDataController.shared.fetchedGoalByMonthController
      frc2.fetchRequest.predicate = allGoalPredicate
    case .lastYear:
      frc1 = CoreDataController.shared.fetchedToDoByYearController
      frc1.fetchRequest.predicate = pastYearToDoPredicate
      frc2 = CoreDataController.shared.fetchedGoalByYearController
      frc2.fetchRequest.predicate = pastYearGoalPredicate
    case .lastSixMonths:
      frc1 = CoreDataController.shared.fetchedToDoByMonthController
      frc1.fetchRequest.predicate = past6MonthToDoPredicate
      frc2 = CoreDataController.shared.fetchedGoalByMonthController
      frc2.fetchRequest.predicate = past6MonthGoalPredicate
    case .lastmonth:
      frc1 = CoreDataController.shared.fetchedToDoByMonthController
      frc1.fetchRequest.predicate = pastMonthToDoPredicate
      frc2 = CoreDataController.shared.fetchedGoalByMonthController
      frc2.fetchRequest.predicate = pastMonthGoalPredicate
    case .lastweek:
      frc1 = CoreDataController.shared.fetchedToDoByWeekController
      frc1.fetchRequest.predicate = pastWeekToDoPredicate
      frc2 = CoreDataController.shared.fetchedGoalByWeekController
      frc2.fetchRequest.predicate = pastWeekGoalPredicate
    }
    
    do {
      try frc1.performFetch()
    } catch {
      print("Fetch frc1 failed")
    }
    
    do {
      try frc2.performFetch()
    } catch {
      print("Fetch frc2 failed")
    }
    
    let todoSections = frc1.sections?.count ?? 0
    for section in 0...(todoSections - 1) {
      let sectionName = frc1.sections?[section].name ?? "No Section"
      statistics.sectionName.append(sectionName)
      statistics.todoDuration.append(0)
      if let todoSectionObject = frc1.sections?[section].objects as? [ToDo] {
        statistics.todoCount.append(todoSectionObject.count)
        let tempCount = todoSectionObject.filter { (todo) -> Bool in
          todo.todoCompleted == true
        }.count
        statistics.todoComplete.append(tempCount)
        for todo in todoSectionObject {
          if todo.todoCompleted {
            let diffComponents = Calendar.current.dateComponents([.day], from: todo.todoDateCreated, to: todo.todoDateCompleted!)
            statistics.todoDuration[section] += diffComponents.day!
          }
        }
        statistics.todoIncomplete.append(statistics.todoCount[section] - statistics.todoComplete[section])
      }
    }
    
    let goalSections = frc2.sections?.count ?? 0
    for section in 0...(goalSections - 1) {
      statistics.goalDuration.append(0)
      if let goalSectionObject = frc2.sections?[section].objects as? [Goal] {
        statistics.goalCount.append(goalSectionObject.count)
        let tempCount = goalSectionObject.filter { (goal) -> Bool in
          goal.goalCompleted == true
        }.count
        statistics.goalComplete.append(tempCount)
        for goal in goalSectionObject {
          if goal.goalCompleted {
            let diffComponents = Calendar.current.dateComponents([.day], from: goal.goalDateCreated, to: goal.goalDateCompleted!)
            statistics.goalDuration[section] += diffComponents.day!
          }
        }
        statistics.goalIncomplete.append(statistics.goalCount[section] - statistics.goalComplete[section])
      }
    }
      return statistics
  }
}
