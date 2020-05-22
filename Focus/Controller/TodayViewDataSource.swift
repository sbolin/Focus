//
//  TodayViewDataSource.swift
//  Focus
//
//  Created by Scott Bolin on 5/15/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit
import CoreData

class TodayViewDataSource: NSObject, UITableViewDataSource,  NSFetchedResultsControllerDelegate {

  lazy var coreDataStack = CoreDataStack(modelName: "Focus")
//  let goals = [Goal]()
//  var goal = Goal()
//  let allTodos = [[ToDo]]()
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    } else {
      return 3
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let section = indexPath.section
    let goalObject = coreDataStack.fetchTodayTodoGoal().object(at: indexPath)
    let todos = goalObject.todos.allObjects as? [ToDo]
    if section == 0 {
      // section 0 is for Today's goal:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: TodayGoalCell.reuseIdentifier, for: indexPath) as? TodayGoalCell else {
        fatalError("Wrong cell type dequeued")
      }
      cell.todayGoal.text = goalObject.goal
      return cell
    } else {
      // section 1 is for Today's tasks:
      let cell = tableView.dequeueReusableCell(withIdentifier: TodayTaskCell.reuseIdentifier, for: indexPath) as! TodayTaskCell
      guard let todoObject = todos?[indexPath.row] else {
        fatalError("Attempt to configure cell without a managed object")
      }
      cell.todayTask.text = todoObject.todo
      return cell
    }
  }
}

//MARK: - Cell delegate methods
extension TodayViewDataSource: TodayTaskCellDelegate, TodayGoalCellDelegate {
  
  //MARK: TodayGoalCellDelegate Methods
  func todayGoal(_ cell: TodayGoalCell, newGoalCreated newGoal: String) {
    
  }
  
  func todayGoal(_ cell: TodayGoalCell) -> Bool {
    return false
  }
  
  //MARK: TodayTaskCellDelegate Methods
  func todayTask(_ cell: TodayTaskCell, newTaskCreated newTask: String) {
    guard let tableViewContainer = cell.tableView else { return }
    guard let indexPath = tableViewContainer.indexPath(for: cell) else { return }
    let newTask = coreDataStack.createTodo(todoName: newTask)
    newTask?.todoDateCreated = Date()
    newTask?.todoCompleted = false
    tableViewContainer.insertRows(at: [indexPath], with: .automatic)
    coreDataStack.saveContext()
  }
  
  func todayTask(_ cell: TodayTaskCell, completionChanged completion: Bool) {
    guard let tableViewContainer = cell.tableView else { return }
    guard let indexPath = tableViewContainer.indexPath(for: cell) else { return }
    let goalObject = coreDataStack.fetchTodayTodoGoal().object(at: indexPath)
    guard let todos = goalObject.todos.allObjects as? [ToDo] else { return }
    let task = todos[indexPath.row]
    task.todoCompleted = completion
    task.todoDateCompleted = Date()
    coreDataStack.saveContext()
  }
}
