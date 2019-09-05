# Whitehouse Petitions

#### Whitehouse Petitions is a project that uses UITableViewControllers that are embeded inside a UITabBarController that has three UITabBarItems ( Most Recent, Top Rated, Search ) where the user can see the most recent petitions, the top rated petitions and to search for a specific petition. To display the Data that we get from a URL we use Structures that conform to the Codable protocol and create a representation of the JSON format that we get from the API, than we decode the data using JSONDecoder( ) and display the text to the user. When a user tapps on a specific row in the table view the content of that row is loaded from the web using the WebKit framework that displays the information to the user.

## Main Points:

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
