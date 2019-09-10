# Photo Of Things

#### Photo Of Things is a challenge project where we will display a Photo and a Description  using UITableViewController to display the information in rows, where each row will contain a UIImageView and a UILabel. When the user tapps the UIBarButtonItem to add a Photo the Photo Library will open using UIImagePickerController so they can select an image and add it, than by tapping to the row they have the option to see a biger version of the Photo, Rename it or Delete the row using Alert and TextField. It also has persistence using UserDefaults, Codable protocol with JSONDecoder( ) and JSONEncoder( ) to convert our custom data into Data Object that can be written to disck and read back in to the app to make data that the user adds, renames or deletes to persist in our application.

## Main Points:

* UserDefaults
* Codable
* JSONDecoder( )
* JSONEncoder( )
* UINavigationController
* UITableViewController ( Delegate, DataSource )
* UIImagePickerController ( isSourceTypeAvailable( ), sourceType )
* UIImagePickerControllerDelegate
* UINavigationControllerDelegate
* UIImageView
* UILabel
* NSObject
* UUID()
* FileManager
* UITextField
* UIBarButtonItem
* AutoLayout
* DocumentDirectory
* Type casting ( as? )
* fatalError( )
* Using Closures and breaking Strong-Reference-Cycles using 'weak'
* Alerts ( UIAlertController, UIAlertAction )
* Actions using @objc to expose a method to Objective-C


## App Demo:

<img src="demo.gif?raw=true" width="325px" height="650">
