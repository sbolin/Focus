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
  
  // closure for creating new Focus item
//  typealias StateHandler = (Bool) -> Void
  var handler: ((Bool) -> Void)?
  
  //MARK: - Notification when Tasks/Goal is completed
  func manageLocalNotification() {
    print("NS: manageLocalNotification")
    
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
  
  //MARK: - Check Notification Status, user could have changed it.
  private func checkNotificationStatus() {
    print("NS: checkNotificationStatus")
    let center = UNUserNotificationCenter.current()
    
    // print any pending requests (for testing only - not needed)
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
            print("Notifications Granted. You can always change notification settings later in the Settings App.")
          }
          else {
            print("Without Notifications Focus cannot send you reminders. You can always change notification settings later in the Settings App.")
          }
        }
      }
    }
  }
 
  //MARK: - Schedule Notification
  private func setupNotification(title: String?, subtitle: String?, body: String?, notificationType: NotificationType) {
print("NS: setupNotification")
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
    let trigger2 = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    #endif
    
    // set up notification content
    if let newTitle = title, let newBody = body, let subtitle = subtitle {
      //create content
      let content = UNMutableNotificationContent()
      content.title = newTitle
      content.subtitle = subtitle
      content.body = newBody
      content.badge = (UIApplication.shared.applicationIconBadgeNumber + 1) as NSNumber // Increment not specifically needed in this app (as only 1 notification exists at a time).
      content.categoryIdentifier = identifier
//      content.userInfo = ["customData": "Custom Data"] // not used

      content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "Cheer.caf"))

      /*
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
      */
      
      
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
          print("Request 1 Scheduled notification")
        }
      }
      #if DEBUG
      center.add(request2) { (error) in
        if let error = error {
          print("Request 2 Error: \(error.localizedDescription)")
        } else {
          print("Request 2 Scheduled notification")
        }
      }
      #endif
    }
  }
  
  func registerCategory(notificationType: NotificationType) {
    print("NS: registerCategory")
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
      print("Default identifier")
      
    case "CREATE_GOAL":
      // call closure handler to create goal
      handler?(true)
      print("Create new Goal")
      break
      
    case "USE_PREVIOUS":
      // user tapped "Use Previous Goal"
      print("Use Previous Goal")
      break
      
    default:
      break
    }
    // call the completion handler
    completionHandler()
    UIApplication.shared.applicationIconBadgeNumber = 0
  }
}
