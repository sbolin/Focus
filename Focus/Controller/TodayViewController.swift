//
//  TodayViewController.swift
//  Focus
//
//  Created by Scott Bolin on 4/30/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit
import CoreData

class TodayViewController: UIViewController, CreateNewGoalControllerDelegate {

  //MARK: - Properties
  let todayViewdelegate = TodayViewDelegate()
  var dataSource: TodayViewDataSource<ToDo, TodayViewController>!
  var fetchedResultsController: NSFetchedResultsController<ToDo>!
  private let notification = NotificationController()
  
  //MARK:- IBOutlets
  @IBOutlet weak var todayTableView: UITableView!
  @IBOutlet weak var taskToAchieveLabel: UILabel!
  
  
  //MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    // for initial checks of App, will be deleted in final app.
    CoreDataController.shared.createToDosIfNeeded(managedContext: CoreDataController.shared.managedContext)
    todayTableView.delegate = todayViewdelegate
    setupToDoTableView()
    registerForKeyboardNotifications()
    notification.manageLocalNotification()
    
    // closure method:
    notification.handler = { [weak self] bool in
      print("in notification handler, \(bool)")
      if bool {
        let createFocusGoal = CreateNewGoalController()
        createFocusGoal.delegate = self
        createFocusGoal.setupNavBar()
        let navController = UINavigationController(rootViewController: createFocusGoal)
        self?.present(navController, animated: true, completion: nil)
      }
    }
  }

  //MARK: - Setup tableview to show last note
  func setupToDoTableView() {
    // setup fetchrequest
    if fetchedResultsController == nil {
      fetchedResultsController = CoreDataController.shared.fetchedToDoResultsController
    }
    fetchedResultsController.fetchRequest.fetchLimit = 0
    let todoCreatedAtDescriptor = NSSortDescriptor(keyPath: \ToDo.todoDateCreated, ascending: false)
    let todoDescriptor = NSSortDescriptor(keyPath: \ToDo.todo, ascending: true)
    fetchedResultsController.fetchRequest.sortDescriptors = [todoCreatedAtDescriptor, todoDescriptor]
    fetchedResultsController.fetchRequest.fetchLimit = globalState.numberofTasks
    
    do {
      try fetchedResultsController.performFetch()
      todayTableView.reloadData()
    } catch {
      print("Fetch failed")
    }
    dataSource = TodayViewDataSource(tableView: todayTableView, fetchedResultsController: fetchedResultsController, delegate: self)
  }
  
  //MARK:- Notification Functions for keyboard
  func registerForKeyboardNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  @objc func keyboardWillShow(notification: NSNotification) {
    let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
    adjustLayoutForKeyboard(targetHeight: keyboardFrame.size.height)
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    adjustLayoutForKeyboard(targetHeight: 0)
  }
  
  func adjustLayoutForKeyboard(targetHeight: CGFloat) {
//    no need to adjust keyboard in TodayView, enough space below table
//    todayTableView.contentInset.bottom = targetHeight
  }
}

//MARK: - Delegate Methods
extension TodayViewController: TodayViewDataSourceDelegate {
  func configureTodayTask(at indexPath: IndexPath, _ cell: TodayToDoCell, for object: ToDo) {
    cell.configureTodayTaskCell(at: indexPath, for: object)
  }
  
  func configureTodayGoal(at indexPath: IndexPath, _ cell: TodayGoalCell, for object: Goal) {
    cell.configureTodayGoalCell(at: indexPath, for: object)
  }
}

//MARK: - UNUserNotificationCenterDelegate methods
extension TodayViewController: UNUserNotificationCenterDelegate {
  //CreateNewGoalController Delegate method
  func goalPassBack(goal: String, todo1: String, todo2: String, todo3: String) {
    CoreDataController.shared.addNewGoal(goal: goal, firstTask: todo1, secondTask: todo2, thirdTask: todo3)
    todayTableView.reloadData()
  }
}
