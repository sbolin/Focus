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
    
    // ToDo Statistics properties
    let todoTotal = statistics.todoCount[0]
    let todoIncomplete = statistics.todoIncomplete[0]
    
    // notification setup
    var title = String()
    var subtitle = String()
    var body = String()
    
    if todoIncomplete == 0 { // Focus goal completed
      title = "Focus Goal Complete"
      subtitle = "Today's Goal and Tasks completed"
      body = "Add a new Focus Goal and Tasks 🙂"
    } else { // tasks remain
      title = "Focus Goal not complete "
      subtitle = "Add new Goal or Use Yesterday's?"
      body = "You have \(todoIncomplete) tasks out of \(todoTotal) to go!"
    }
    
    // check if notifications are still authorized
    checkNotificationStatus()
    
    // schedule (or remove) reminders
    scheduleNotifications(title: title, subtitle: subtitle, body: body)
  }
  
  //MARK: - Check Notification Status
  func checkNotificationStatus() {
    UNUserNotificationCenter.current().getNotificationSettings { (settings : UNNotificationSettings) in
      if settings.authorizationStatus == .authorized {
        // Still Authorized, no need to do anything
        return
      } else {
        // Not Authorized anymore, request authorization again.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
          if (granted) {
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
  func scheduleNotifications(title: String?, subtitle: String?, body: String?) {
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
      content.body = newBody
      content.badge = (UIApplication.shared.applicationIconBadgeNumber + 1) as NSNumber; // Increment not specifically needed in this app (as only 1 notification exists at a time).
      content.categoryIdentifier = "notification"
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
      
      // create trigger
      let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
      
      // create request
      let request = UNNotificationRequest(identifier: "FocusSummary", content: content, trigger: trigger)
      
      // schedule notification
      UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
  }
}
