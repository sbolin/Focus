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
  let notification = NotificationController()
  
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
  
  func createFocusGoal() {
    let createFocusGoal = CreateNewGoalController()
    createFocusGoal.delegate = self
    let navController = UINavigationController(rootViewController: createFocusGoal)
    present(navController, animated: true, completion: nil)
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
  
  // Show notification when Focus.app is active
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    // To show the banner in-app
    completionHandler([.badge, .alert, .sound])
  }
  
  // handle notifications
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    
    switch response.actionIdentifier {
      
    case UNNotificationDefaultActionIdentifier:
      // the user swiped to unlock
      print("Default identifier")
      
    case "New Goal":
      createFocusGoal()
      
      // try to present controller instead
//      let createFocusGoal = CreateNewGoalController()
//      createFocusGoal.delegate = self
//      let navController = UINavigationController(rootViewController: createFocusGoal)
//      present(navController, animated: true, completion: nil)
      
    case "Previous Goal":
      // user tapped "Use Previous Goal"
      print("Use Previous Goal")
      
    default:
      break
    }
    //    }
    // call the completion handler
    completionHandler()
    UIApplication.shared.applicationIconBadgeNumber = 0
  }
  
  //CreateNewGoalController Delegate method
  func didAddGoal(success: Bool) {
    print("Goal added: \(success)")
  }
  
}
