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
  @IBOutlet weak var createFocus: UIButton!
  
  
  //MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    todayTableView.delegate = todayViewdelegate
    registerForKeyboardNotifications()
    
    // Call CreateNewGoalController using closure:
    notification.handleGoalTapped = { [weak self] bool in
      if bool {
        // bool = true: create new goal
        let createFocusGoal = CreateNewGoalController()
        createFocusGoal.delegate = self
        createFocusGoal.setupNavBar()
        let navController = UINavigationController(rootViewController: createFocusGoal)
        self?.present(navController, animated: true, completion: nil)
      } else {
        // bool = false: reload todayTableView
        self?.todayTableView.reloadData()
      }
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super .viewDidAppear(animated)
    checkFirstRun()
    setupToDoTableView()
    // wait 20 seconds before throwing up the request authorization, so user has time to orient to the Focus list
    DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
      self.checkNotificationStatus()
    }
  }
  
  //MARK: - Check first run status
  func checkFirstRun() {
    let launchedBefore = UserDefaults.standard.bool(forKey: "Launched Before")
    if !launchedBefore  {
      // First launch, set user defaults to true (Launched Before = true)
      UserDefaults.standard.set(true, forKey: "Launched Before")
      
      // run thru onboarding
      let vc = (storyboard?.instantiateViewController(identifier: "firstRun"))! as FirstRunController
      vc.modalPresentationStyle = .fullScreen
      present(vc, animated: true)
      
      // Create blank Focus goal and tasks to start: - make in model!
      let goal = "New Focus Goal"
      let task1 = "First Task"
      let task2 = "Second Task"
      let task3 = "Third Task"
      CoreDataController.shared.addNewGoal(goal: goal, firstTask: task1, secondTask: task2, thirdTask: task3)
      todayTableView.reloadData()
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
    fetchedResultsController.fetchRequest.fetchLimit = globalState.numberOfTasks
    
    do {
      try fetchedResultsController.performFetch()
      todayTableView.reloadData()
    } catch {
      print("Fetch failed")
    }
    dataSource = TodayViewDataSource(tableView: todayTableView, fetchedResultsController: fetchedResultsController, delegate: self)
  }
  
  //MARK: - Check Notification Status, user could have changed it.
  private func checkNotificationStatus() {
    let center = UNUserNotificationCenter.current()
    center.getNotificationSettings { settings in
      if settings.authorizationStatus == .authorized {
        // Authorized, no need to do anything
        return
      } else {
        // Not Authorized, request authorization.
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
          if let error = error {
            print("Error granting notifications, \(error), \(error.localizedDescription)")
          }
        }
      }
    }
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
  
  @IBAction func createFocusTapped(_ sender: UIButton) {
    CoreDataController.shared.createToDosIfNeeded(managedContext: CoreDataController.shared.managedContext)
    todayTableView.reloadData()
  }
}

//MARK: - Delegate Methods
extension TodayViewController: TodayViewDataSourceDelegate {
  func configureTodayTask(at indexPath: IndexPath, _ cell: TodayToDoCell, for object: ToDo) {
    cell.configureTodayTaskCell(at: indexPath, for: object)
    notification.manageLocalNotification()
  }
  
  func configureTodayGoal(at indexPath: IndexPath, _ cell: TodayGoalCell, for object: Goal) {
    cell.configureTodayGoalCell(at: indexPath, for: object)
    notification.manageLocalNotification()
  }
}

//MARK: - UNUserNotificationCenterDelegate methods
extension TodayViewController: UNUserNotificationCenterDelegate {
  //CreateNewGoalController Delegate method
  func goalPassBack(goal: String, todo1: String, todo2: String, todo3: String) {
    CoreDataController.shared.addNewGoal(goal: goal, firstTask: todo1, secondTask: todo2, thirdTask: todo3)
    todayTableView.reloadData()
    notification.manageLocalNotification()
  }
}
