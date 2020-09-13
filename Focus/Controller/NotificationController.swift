//
//  NotificationController.swift
//  Focus
//
//  Created by Scott Bolin on 5/17/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit
import UserNotifications

enum NotificationType {
  case completeGoal
  case incompleteGoal
}

// original inherited from NSObject, change to UIViewController so can present new goal view
class NotificationController: NSObject, UNUserNotificationCenterDelegate {
 
  //MARK: - Properties
  private let identifier = "FocusNotification"
  
// Get Goal statistics
//  let statTimePeriod = StatTimePeriod.lastday
//  let statFactory = StatisticsFactory()
//  var statistics: Statistics = {
//    StatisticsFactory().stats(statType: StatTimePeriod.lastday)
//  }()
//
//  // ToDo Statistics properties
//  var todoTotal: Int = {
//    StatisticsFactory().stats(statType: StatTimePeriod.lastday).todoCount[0]
//  }()
//
//  var todoIncomplete: Int = {
//    StatisticsFactory().stats(statType: StatTimePeriod.lastday).todoIncomplete[0]
//  }()
//
  
// closure for creating new Focus item (true) or presenting previous (false)
  var handleGoalTapped: ((Bool) -> Void)?
  
  //MARK: - Notification when Tasks/Goal is completed
  func manageLocalNotification() {
    
    // Get Goal statistics
    let statTimePeriod = StatTimePeriod.lastday
    let statFactory = StatisticsFactory()
    let statistics = statFactory.stats(statType: statTimePeriod)
    
    // ToDo Statistics properties
    let todoTotal = statistics.todoCount[0]
    let todoIncomplete = statistics.todoIncomplete[0]
    let todoComplete = todoTotal - todoIncomplete
    
    // notification setup
    var title = String()
    var subtitle = String()
    var body = String()
    let type: NotificationType
    
    if todoIncomplete == 0 { // Focus goal completed
      type = NotificationType.completeGoal
      title = "Focus Goal Complete 🎉"
      subtitle = "Congratulations! Today's Focus Goal and Tasks were completed."
      body = "Add a new Focus Goal and Tasks 🙂"

    } else { // tasks remain
      type = NotificationType.incompleteGoal
      title = "Focus Goal not completed yet 🥺"
      subtitle = "Keep trying 👊! Add a new Focus or use yesterdays?"
      body = "You completed \(todoComplete) out of \(todoTotal) tasks!"
    }
    // schedule (or remove) reminders
    setupNotification(title: title, subtitle: subtitle, body: body, notificationType: type)
  }
 
  //MARK: - Schedule Notification
  private func setupNotification(title: String?, subtitle: String?, body: String?, notificationType: NotificationType) {
    registerCategory(notificationType: notificationType)
    let center = UNUserNotificationCenter.current()
    //remove previously scheduled notifications
    center.removeDeliveredNotifications(withIdentifiers: [identifier])
    
    // need to set so goes off at 8am each day
    var dateComponents = DateComponents()
    dateComponents.hour = 8
    dateComponents.minute = 00
    
    // create trigger
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    
    #if DEBUG
    let trigger2 = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)
    #endif
    
    // set up notification content
    if let newTitle = title, let newBody = body, let subtitle = subtitle {
      //create content
      let content = UNMutableNotificationContent()
      content.title = newTitle
      content.subtitle = subtitle
      content.body = newBody
      content.badge = 1 as NSNumber // Increment not specifically needed in this app (as only 1 notification exists at a time).
      content.categoryIdentifier = identifier
      content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "Cheer.caf"))
  
      // create request
      let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
      
      #if DEBUG
      let request2 = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger2)
      #endif
      
      // schedule notification
      center.add(request) { (error) in
        if let error = error {
          print("Request 1 Error: \(error.localizedDescription)")
        } else {
          print("Request 1 notification scheduled")
        }
      }
      #if DEBUG
      center.add(request2) { (error) in
        if let error = error {
          print("Request 2 Error: \(error.localizedDescription)")
        } else {
          print("Request 2 notification scheduled")
        }
      }
      #endif
    }
  }
  
  func registerCategory(notificationType: NotificationType) {
    let center = UNUserNotificationCenter.current()
    center.delegate = self
    switch notificationType {
    case .completeGoal:
      let newGoal = UNNotificationAction(identifier: "CREATE_GOAL",
                                         title: "Create New Focus Goal and Tasks",
                                         options: .foreground)
      let category = UNNotificationCategory(identifier: identifier,
                                            actions: [newGoal],
                                            intentIdentifiers: [],
                                            options: .customDismissAction)
      center.setNotificationCategories([category])
    
    case .incompleteGoal:
      let newGoal = UNNotificationAction(identifier: "CREATE_GOAL",
                                         title: "Create New Focus Goal and Tasks",
                                         options: .foreground)
      let oldGoal = UNNotificationAction(identifier: "USE_PREVIOUS",
                                         title: "Contiue using previous Focus",
                                         options: .foreground)
      let category = UNNotificationCategory(identifier: identifier,
                                            actions: [oldGoal, newGoal],
                                            intentIdentifiers: [],
                                            options: .customDismissAction)
      center.setNotificationCategories([category])
    }
  }
  // Show notification when Focus.app is active
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    // Show the banner in-app
    completionHandler([.alert, .sound])
  }
  
  // handle notifications
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    
    switch response.actionIdentifier {
      
    case UNNotificationDefaultActionIdentifier:
      // the user swiped to unlock
      handleGoalTapped?(false)
      print("Default identifier")
      
    case "CREATE_GOAL":
      // call closure handler to create goal
      handleGoalTapped?(true)
      break
      
    case "USE_PREVIOUS":
      // user tapped "Use Previous Goal"
      handleGoalTapped?(false)
      break
      
    default:
      break
    }
    // call the completion handler
    completionHandler()
    UIApplication.shared.applicationIconBadgeNumber = 0
  }
}
