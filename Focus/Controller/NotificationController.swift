//
//  NotificationController.swift
//  Focus
//
//  Created by Scott Bolin on 5/17/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationController {
  
  //MARK: - Notification when Tasks/Goal is completed
  func manageLocalNotification() {
    
    // Get Goal statistics
    let statTimePeriod = StatTimePeriod.lastday
    let statFactory = StatisticsFactory()
    let statistics = statFactory.stats(statType: statTimePeriod)
    
    // Statistics properties
    var noGoals = true // true -> goal completed, false -> goal incomplete

    
    let todoTotalData = statistics.todoCount[0]
    let todoCompletedData = statistics.todoComplete[0]
    let todoIncompleteDate = statistics.todoIncomplete[0]
    
    let goalTotalData = statistics.goalCount[0]
    let goalCompletedData = statistics.goalComplete[0]
    let goalIncompleteData = statistics.goalIncomplete[0]
    
    // notification setup
    var title = String()
    var body = String()
    
    if goalIncompleteData != 0 {
      noGoals = false
    }
    
    // Check if goal is completed (ie, all todo items completed)
    // or if not completed (todos remain)
    // If todos remain, calulate number
    
    
    if noGoals { // no tasks
      title = "Focus Goal Complete"
      body = "Add a new Focus Goal and Tasks 🙂"
    } else { // tasks remain
      title = "Focus Goal not complete yet"
      body = "You have # tasks to go!" // need to get tasks remain count
    }
    
    // schedule (or remove) reminders
    scheduleNotifications(title: title, body: body)
  }
  
  func scheduleNotifications(title: String?, body: String?) {
    let identifier = "FocusSummary"
    let notificationCenter = UNUserNotificationCenter.current()
    
    // need to set so goes off at 8am each day
    var dateComponents = DateComponents()
    dateComponents.hour = 8
    dateComponents.minute = 00
    
    //remove previously scheduled notifications
    notificationCenter.removeDeliveredNotifications(withIdentifiers: [identifier])
    
    if let newTitle = title, let newBody = body {
      //create content
      let content = UNMutableNotificationContent()
      content.title = newTitle
      content.subtitle = "Focus!"
      content.categoryIdentifier = "notification"
      content.body = newBody
      content.sound = UNNotificationSound.default
      
      // create trigger
      let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
      //      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 120, repeats: true)
      
      // create request
      let request = UNNotificationRequest(identifier: "FocusSummary", content: content, trigger: trigger)
      
      // schedule notification
      UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
  }
  
}
