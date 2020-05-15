//
//  TodayViewController.swift
//  Focus
//
//  Created by Scott Bolin on 4/30/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController {
  
  //MARK: - Properties
  fileprivate var goalCell = "TodayGoalCell"
  fileprivate let todoCell = "TodayTaskCell"
  fileprivate let dateFormatter = DateFormatter()
  var goals = [Goal]()
  
  //MARK:- IBOutlets
  @IBOutlet weak var todayTableView: UITableView!
  
  //MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let dataSource = SectionedTableViewDataSource(dataSources: [ TableViewDataSource.make(for: goals) ])
    
//    let sections = dataSource.numberOfSections(in: todayTableView)
    let goalRows = dataSource.tableView(todayTableView, numberOfRowsInSection: 0)
    let todoRows = dataSource.tableView(todayTableView, numberOfRowsInSection: 1)
    for  row in 0...goalRows {
      let cell = dataSource.tableView(todayTableView, cellForRowAt: IndexPath(row: row, section: 0))
    }
    for  row in 0...todoRows {
      let cell = dataSource.tableView(todayTableView, cellForRowAt: IndexPath(row: row, section: 1))
      
    }
    registerForKeyboardNotifications()
    manageLocalNotifications()
    
    // Do any additional setup after loading the view.
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
    todayTableView.contentInset.bottom = targetHeight
  }
  
  //MARK: - Notification when Tasks/Goal is completed
  func manageLocalNotifications() {
    
    //TODO: - Fix notifications
    // prepare content
    let totalTasks = goals.count
    let completedTasks = goals.filter { (goal) -> Bool in
      return goal.goalCompleted == true
    }.count
    
    var title: String?
    var body: String?

    if totalTasks == 0 { // no tasks
      title = "Nothing to do?"
      body = "Add some tasks 🙂"
    }
    else if completedTasks == 0 { // nothing completed
      title = "Time to get started!"
      body = "You have \(totalTasks) hot tasks to go!"
    }
    else if completedTasks < totalTasks { // some tasks remain
      title = "Progress in Action!"
      body = "\(completedTasks) down, \(totalTasks - completedTasks) to go!"
    }
    
    // schedule (or remove) reminders
    scheduleNotifications(title: title, body: body)
  }
  
  func scheduleNotifications(title: String?, body: String?) {
    let identifier = "ToDoSummary"
    let notificationCenter = UNUserNotificationCenter.current()
    
    var dateComponents = DateComponents()
    dateComponents.hour = 8
    dateComponents.minute = 30
    
    
    //remove previously scheduled notifications
    notificationCenter.removeDeliveredNotifications(withIdentifiers: [identifier])
    
    if let newTitle = title, let newBody = body {
      //create content
      let content = UNMutableNotificationContent()
      content.title = newTitle
      content.subtitle = "- To Do -"
      content.categoryIdentifier = "notification"
      content.body = newBody
      content.sound = UNNotificationSound.default
      
      // create trigger
      let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
      //      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 120, repeats: true)
      
      // create request
      let request = UNNotificationRequest(identifier: "ToDoSummary", content: content, trigger: trigger)
      
      // schedule notification
      UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
  }
  @IBAction func addTodayTask(_ sender: UIButton) {
    
  }
  
}
