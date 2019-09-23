# Selfie Share

#### Selfie Share is a project where I learned about the MultipeerConnectivity framework and also reviewed the UICollectionViewController, UIImagePickerController and GCD. The main purpose of the app is to connect two devices using the MultipeerConnectivity framework by createing a session wich will enable other users to join and send images and messages between each other.

## Main Points:


* UINavigationController
* UICollectionViewController ( Delegate, DataSource )
* UICollectionViewCell
* UIImagePickerController ( isSourceTypeAvailable( ), sourceType )
* UIImagePickerControllerDelegate
* UINavigationControllerDelegate
* UIImageView
* UIImage
* UIBarButtonItem
* GCD
* MultipeerConnectivity Framework
* MCSession ( the manager class that handles all multipeer connectivity )
* MCSessionDelegate
* MCPeerID ( identifies each user uniquely in a session )
* MCAdvertiserAssistant ( used when creating a session, telling others that we exist and handling invitations )
* MCBrowserViewController ( used when looking for sessions, shows users who is nearby and letting them join )
* MCBrowserViewControllerDelegate
* AutoLayout
* MCPeerID
* Type casting ( as? )
* Using Closures and breaking Strong-Reference-Cycles using 'weak'
* Alerts ( UIAlertController, UIAlertAction )
* Actions using @objc to expose a method to Objective-C


## App Demo:

<img src="demo.gif?raw=true" width="680px" height="690">
