//
//  HistoryViewDataSource.swift
//  Focus
//
//  Created by Scott Bolin on 5/16/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewDataSource: NSObject, UITableViewDataSource, NSFetchedResultsControllerDelegate {
  
  lazy var coreDataStack = CoreDataStack(modelName: "Focus")
  
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 10 // hold for now
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    } else {
      return 4
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let section = indexPath.section
    let goalObject = coreDataStack.fetchAllGoals().object(at: indexPath)
    let todos = goalObject.todos.allObjects as? [ToDo]
    if section == 0 {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodayGoalCell", for: indexPath) as? TodayGoalCell else {
        fatalError("Wrong cell type dequeued")
      }
      //      let goal = goals[indexPath.row]
      //      cell.todayGoal.text = goal.goal
      cell.todayGoal.text = goalObject.goal
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "TodayTaskCell", for: indexPath) as! TodayTaskCell
      guard let todoObject = todos?[indexPath.row] else {
        fatalError("Attempt to configure cell without a managed object")
      }
      //      let todos = goal.todos.allObjects as? [ToDo]
      //      let t = todos?[indexPath.row]
      //      print("todo: \(todo)")
      //      print("t: \(String(describing: t))")
      cell.todayTask.text = todoObject.todo
      return cell
    }
  }
}
