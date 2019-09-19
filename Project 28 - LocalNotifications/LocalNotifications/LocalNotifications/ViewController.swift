//
//  ViewController.swift
//  LocalNotifications
//
//  Created by Mr.Kevin on 05/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocalNotification))
  }
  
  /// A method used to request permission from the user to send local notification in our app.
  @objc func registerLocal() {
    // create an instance of UserNotificationCenter
    let center = UNUserNotificationCenter.current()
    
    // request authorization for an alert, badge and sound
    center.requestAuthorization(options: [.alert,.badge,.sound]) { (granted, error) in
      if granted {
        print("Yesss!")
      } else {
        print("Nooo")
      }
    }
  }
  
  @objc func scheduleLocalNotification() {
    scheduleLocal(timeInterval: 5)
  }
  
  /// A method that will configure all the data needed to schedule a notification, which is three things: content (what to show), a trigger (when to show it), and a request (the combination of content and trigger.)
  func scheduleLocal(timeInterval: TimeInterval) {
    
    registerCategories()
    
    // create a UserNotificationCenter object
    let center = UNUserNotificationCenter.current()
    
    // create a content object and add values to it's properties
    let content = UNMutableNotificationContent()
    content.title = "Local Notifications"
    content.body = "Creating local notifications!"
    content.categoryIdentifier = "alarm"
    content.userInfo = ["customData": "my custom data"]
    content.sound = UNNotificationSound.default
    
    // create a DateComponents object
//    var dateComponents = DateComponents()
//    dateComponents.hour = 10
//    dateComponents.minute = 30
    
    // create a trigger object
//    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    
    // a trigger more easy to test
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
    
    // create a request object with a unique identifier for the content and trigger
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
    // add the request to the UserNotificationCenter
    center.add(request)
    
    // You can cancel pending notifications – i.e., notifications you have scheduled that have yet to be delivered because their trigger hasn’t been met, like this:
//    center.removeAllPendingNotificationRequests()
    
  }
  
  /// A method that will create a button on the UserNotification to open the app
  func registerCategories() {
    // create a UserNotificationCenter object
    let center = UNUserNotificationCenter.current()
    // set the delegate property of the user notification center to be self, meaning that any alert-based messages that get sent will be routed to our view controller to be handled.
    center.delegate = self
    // UNNotificationAction creates an individual button for the user to tap
    let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
    let remindLater = UNNotificationAction(identifier: "remind", title: "Remind me later", options: .foreground)
    // UNNotificationCategory groups multiple buttons together under a single identifier.
    let category = UNNotificationCategory(identifier: "alarm", actions: [show, remindLater], intentIdentifiers: [])
    
    center.setNotificationCategories([category])
  }

  
  /// A UserNotificationCenter delegate method that will notify us when it receives a notification response, and let us handel it.
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    
    // pull out the userInfo dictionary
    let userInfo = response.notification.request.content.userInfo
    
    var content = ""
    
    if let customData = userInfo["customData"] as? String {
      print("Custom data received: \(customData)")
      
      switch response.actionIdentifier {
      case UNNotificationDefaultActionIdentifier:
        // the user swiped to unlock
        print("Default Identifier")
        content = "Default Identifier"
      case "show":
        // user tapped our button 'Tell me more...'
        print("Show more information...")
        content = "Show more information..."
      case "remind":
        // 86400 seconds = 24 hours
        scheduleLocal(timeInterval: 10)
        content = "You will be reminded after 10sek."
      default:
        break
      }
      
      let ac = UIAlertController(title: "Action Identifier", message: content, preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK", style: .default))
      present(ac, animated: true)
    }
    // we need to call the completion handler when we are done
    completionHandler()
  }

}

