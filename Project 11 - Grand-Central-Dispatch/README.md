# Grand-Central-Dispatch

#### Grand-Central-Dispatch is a technique project where we will solve a problem in the Whitehouse Petitions project to get the data form the API in the background thread using "DispatchQueue.global(qos: ).async" so we don't lock our User Interface for the user, and than send the parsed data back to the main thread where we want to update the User Interface using "DispatchQueue.main.async".  

## Main Points:

* DispatchQueue ( .main - run code in the main thread to update your UI )
* DispatchQueue ( .global(qos: ) - to run code on the background thread based on the QoS )
* QoS ( will decide what level of service will be given to the code )
* QoS ( User Interactive, User Initiated, Default, Utility, Background )
* Closure ( with capture list [ weak self ] in)
* UIViewController
* UITableViewController
* UITabBarController
* UITabBarItem
* UINavigationController
* WebKit framework ( WKWebView )
* UIBarButtonItem
* UITextField
* URL
* Data
* Codable protocol ( Decodable & Encodable )
* JSON ( JSONDecoder( ) )
* Structures
* Alerts ( UIAlertController, UIAlertAction )
* Actions using @objc to expose a method to Objective-C
* Storyboard


## App Demo:

<img src="demo.gif?raw=true" width="325px" height="650">
