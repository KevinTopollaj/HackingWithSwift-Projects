# Notes App

#### Notes App is a challenge project where I recreate the iOS Notes app. The project it is all created in code from Setup, UI, AutoLayout using Anchors, UITableView, UITableViewCell, UILabels, UITextView and UIStackView. The user can add a note by tapping the compose button on the ToolBar and than a UITextView will be displayed where they can add the note and tap Done when they finish, then they can edit a note by tapping on it, or delete a note using swipe to delete. This app also contains two most used communication patterns in iOS the Delegation and Notification Center. The Delegation pattern is used to add a new note and to update an existing note in the app. The NotificationCenter is used so that iOS can notifie us when the keyboard was shown or hidden in the UITextView. I also used the UserDefaults to save the notes localy in the device and UIActivityViewController to allow users to share their notes. 


## Main Points:

* UIView ( addSubview( ) )
* UINavigationController
* UITableView ( Delegate, DataSource )
* UITableViewCell
* UIBarButtonItem
* UIToolBar
* UILabel
* UITextView
* UIStackView
* Date
* Delegation Pattern
* NotificationCenter
* Codable Protocol
* JSONEncoder( )
* JSONDecoder( )
* UserDefaults
* UIActivityViewController
* Auto Layout using Anchors ( widthAnchor, heightAnchor, trailingAnchor, leadingAnchor, topAnchor, bottomAnchor, leftAnchor, rightAnchor, centerXAnchor, centerYAnchor)
* NSLayoutConstraint


## App Demo:

<img src="demo.gif?raw=true" width="325px" height="650">
