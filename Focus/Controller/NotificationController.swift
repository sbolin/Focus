//
//  NotificationController.swift
//  Focus
//
//  Created by Scott Bolin on 5/17/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit

class NotificationController {
    
    //MARK: - Notification when Tasks/Goal is completed
    func registerNotification() {
        
        //TODO: - Fix notifications
        // prepare content
        var title: String?
        var body: String?
        
        // Check if goal is completed (ie, all todo items completed)
        // or if not completed (todos remain)
        // If todos remain, calulate number
        
        let noGoals = true // true -> no goal set, need to add, false -> goal set
        
        if noGoals { // no tasks
            title = "Nothing to do?"
            body = "Add some Goals and Tasks 🙂"
        } else { // tasks remain
            title = "Keep Going!"
            body = "You have # tasks to go!" // need to get tasks remain count
        }
        
        // schedule (or remove) reminders
        scheduleNotifications(title: title, body: body)
    }
    
    func scheduleNotifications(title: String?, body: String?) {
        let identifier = "GoalSummary"
        let notificationCenter = UNUserNotificationCenter.current()
        
        // need to set so goes off at 8am each day
        var dateComponents = DateComponents()
        dateComponents.hour = 8
        dateComponents.minute = 30
        
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
            let request = UNNotificationRequest(identifier: "ToDoSummary", content: content, trigger: trigger)
            
            // schedule notification
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
        
    }
}
