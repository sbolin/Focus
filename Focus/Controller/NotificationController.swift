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
class NotificationController: UIViewController, UNUserNotificationCenterDelegate {
 
  //MARK: - Properties
  let identifier = "FocusNotification"
  
  //MARK: - Notification when Tasks/Goal is completed
  func manageLocalNotification() {
    
    // check if notifications are still authorized
    checkNotificationStatus()
    
    // Get Goal statistics
    let statTimePeriod = StatTimePeriod.lastday
    let statFactory = StatisticsFactory()
    let statistics = statFactory.stats(statType: statTimePeriod)
    
    // ToDo Statistics properties
    let todoTotal = statistics.todoCount[0]
    let todoIncomplete = statistics.todoIncomplete[0]
    
    // notification setup
    var title = String()
    var subtitle = String()
    var body = String()
    let type: NotificationType
    
    if todoIncomplete == 0 { // Focus goal completed
      type = NotificationType.completeGoal
      title = "Focus Goal Complete 🎉"
      subtitle = "Today's Goal and Tasks completed"
      body = "Add a new Focus Goal and Tasks 🙂"

    } else { // tasks remain
      type = NotificationType.incompleteGoal
      title = "Focus Goal not complete"
      subtitle = "Add new Goal or Use Yesterday's?"
      body = "You have \(todoIncomplete) tasks out of \(todoTotal) to go!"
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
//    center.removeAllPendingNotificationRequests()
    
    // need to set so goes off at 8am each day
    var dateComponents = DateComponents()
    dateComponents.hour = 8
    dateComponents.minute = 00
    
    // create trigger
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    
    #if DEBUG
    let trigger2 = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
    #endif
    
    // set up notification content
    if let newTitle = title, let newBody = body {
      //create content
      let content = UNMutableNotificationContent()
      content.title = newTitle
      content.subtitle = "Focus!"
      content.body = newBody
      content.badge = (UIApplication.shared.applicationIconBadgeNumber + 1) as NSNumber // Increment not specifically needed in this app (as only 1 notification exists at a time).
      content.categoryIdentifier = identifier
//      content.userInfo = ["customData": "Custom Data"] // not used
      content.sound = UNNotificationSound.default
      
      // Add logo image as attachment
      if let path = Bundle.main.path(forResource:"Icon", ofType:"png") {
        let url = URL(fileURLWithPath: path)
        do {
          let attachment = try UNNotificationAttachment(identifier: "logo", url: url, options: .none)
          content.attachments = [attachment]
        } catch {
          print("The attachment was not loaded.")
        }
      }
      
      // create request
      let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
      
      #if DEBUG
      let request2 = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger2)
      #endif
      
      // schedule notification
      center.add(request, withCompletionHandler: nil)
      
      #if DEBUG
      center.add(request2, withCompletionHandler: nil)
      #endif
    }
  }
  
  func registerCategory(notificationType: NotificationType) {
    let center = UNUserNotificationCenter.current()
    center.delegate = self
    switch notificationType {
    case .completeGoal:
      let newGoal = UNNotificationAction(identifier: "New Goal", title: "Enter New Goal", options: .foreground)
      let category = UNNotificationCategory(identifier: identifier, actions: [newGoal], intentIdentifiers: [], options: .customDismissAction)
      center.setNotificationCategories([category])
    case .incompleteGoal:
      let newGoal = UNNotificationAction(identifier: "New Goal", title: "Enter Goal", options: .foreground)
      let oldGoal = UNNotificationAction(identifier: "Previous Goal", title: "Use Previous Goal", options: .foreground)
      let category = UNNotificationCategory(identifier: identifier, actions: [oldGoal, newGoal], intentIdentifiers: [], options: .customDismissAction)
      center.setNotificationCategories([category])
    }
  }
  
  //MARK: - Check Notification Status, user could have changed it.
  private func checkNotificationStatus() {
    let center = UNUserNotificationCenter.current()
    
    center.getPendingNotificationRequests { (notifications) in
      print("Notification Count: \(notifications.count)")
      for item in notifications {
        print(item.content)
      }
    }
    
    center.getNotificationSettings { (settings : UNNotificationSettings) in
      if settings.authorizationStatus == .authorized {
        // Still Authorized, no need to do anything
        return
      } else {
        // Not Authorized anymore, request authorization again.
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
          if granted {
            print("Please allow notifications for Focus. You can always change notification settings later in the Settings App.")
          }
          else {
            print("Without Notifications Focus cannot send you reminders. You can always change notification settings later in the Settings App.")
          }
        }
      }
    }
  }
  
  // move UNUserNotificationCenterDelegate methods to TodayViewController

  func didAddGoal(success: Bool) {
    print("New Goal Created")
  }
}
