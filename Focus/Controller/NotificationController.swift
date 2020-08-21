//
//  NotificationController.swift
//  Focus
//
//  Created by Scott Bolin on 5/17/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit
import UserNotifications

// original inherited from NSObject, change to UIViewController so can present new goal view
class NotificationController: UIViewController, UNUserNotificationCenterDelegate, CreateNewGoalControllerDelegate {
 
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
    let type: Int
    
    if todoIncomplete == 0 { // Focus goal completed
      title = "Focus Goal Complete 🎉"
      subtitle = "Today's Goal and Tasks completed"
      body = "Add a new Focus Goal and Tasks 🙂"
      type = 0
    } else { // tasks remain
      title = "Focus Goal not complete"
      subtitle = "Add new Goal or Use Yesterday's?"
      body = "You have \(todoIncomplete) tasks out of \(todoTotal) to go!"
      type = 1
    }
    // schedule (or remove) reminders
    setupNotification(title: title, subtitle: subtitle, body: body, type: type)
  }
  
  //MARK: - Check Notification Status, user could have changed it.
  private func checkNotificationStatus() {
    let center = UNUserNotificationCenter.current()
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
 
  //MARK: - Schedule Notification
  private func setupNotification(title: String?, subtitle: String?, body: String?, type: Int) {

    registerCategory(type: type)
    let center = UNUserNotificationCenter.current()
    
    //remove previously scheduled notifications
    center.removeDeliveredNotifications(withIdentifiers: [identifier])
    center.removeAllPendingNotificationRequests()
    
    // need to set so goes off at 8am each day
    var dateComponents = DateComponents()
    dateComponents.hour = 8
    dateComponents.minute = 00
    
    // create trigger
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    
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
      
      // schedule notification
      center.add(request, withCompletionHandler: nil)
    }
  }
  
  func registerCategory(type: Int) {
    let center = UNUserNotificationCenter.current()
    center.delegate = self
    if type == 0 {
      let newGoal = UNNotificationAction(identifier: "New Goal", title: "Enter New Goal", options: .foreground)
      let category = UNNotificationCategory(identifier: identifier, actions: [newGoal], intentIdentifiers: [], options: .customDismissAction)
      center.setNotificationCategories([category])
    } else {
      let newGoal = UNNotificationAction(identifier: "New Goal", title: "Enter Goal", options: .foreground)
      let oldGoal = UNNotificationAction(identifier: "Previous Goal", title: "Use Previous Goal", options: .foreground)
      let category = UNNotificationCategory(identifier: identifier, actions: [oldGoal, newGoal], intentIdentifiers: [], options: .customDismissAction)
      center.setNotificationCategories([category])
    }
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

      switch response.actionIdentifier {
        
      case UNNotificationDefaultActionIdentifier:
        // the user swiped to unlock
        print("Default identifier")
        
      case "New Goal":
//        todayViewController?.createFocusGoal()
        // try to present controller instead
        let createFocusGoal = CreateNewGoalController()
        createFocusGoal.delegate = self
        let navController = UINavigationController(rootViewController: createFocusGoal)
        present(navController, animated: true, completion: nil)
        
        
        
      case "Previous Goal":
        // user tapped "Use Previous Goal"
        print("Use Previous Goal")
        
      default:
        break
      }
//    }
    // you must call the completion handler when you're done
    completionHandler()
    UIApplication.shared.applicationIconBadgeNumber = 0
  }
  
  func didAddGoal(success: Bool) {
    print("New Goal Created")
  }
}
