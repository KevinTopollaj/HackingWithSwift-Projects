# Local Notifications

#### Local Notifications is a technique project where I learned about UserNotifications framework. This app will allow us to set reminders to the user lock screen to show information when the app is not running.


## Main Points:

* UserNotifications Framework
* UNUserNotificationCenter ( .current( ), .requestAuthorization(options: , completionHandler: ), .add( ) )
* UNUserNotificationCenterDelegate
* UNMutableNotificationContent  
* UNNotificationSound ( .default )
* UNTimeIntervalNotificationTrigger(timeInterval: , repeats: )
* TimeInterval
* UNNotificationRequest(identifier: , content: , trigger: )
* UUID() ( .uuidString )
* UNNotificationAction ( creates a button on the notification for the user to tap )
* UNNotificationCategory ( groups multiple buttons together under a single identifier )
* UNNotificationResponse ( .actionIdentifier )
* UNNotificationDefaultActionIdentifier



## App Demo:

<img src="demo.gif?raw=true" width="325px" height="650">
