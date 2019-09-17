//
//  ActionViewController.swift
//  Extension
//
//  Created by Mr.Kevin on 31/07/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
  
  @IBOutlet var scriptTextView: UITextView!
  /// Properties to store the data that are transmited from Safari
  var pageTitle = ""
  var pageURL = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    
    // When our extension is created, its extensionContext lets us control how it interacts with the parent app. In the case of inputItems this will be an array of data the parent app is sending to our extension to use. We only care about this first item in this project, and even then it might not exist, so we conditionally typecast using if let and as?.
    if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
      // Our input item contains an array of attachments, which are given to us wrapped up as an NSItemProvider. Our code pulls out the first attachment from the first input item.
      if let itemProvider = inputItem.attachments?.first {
        // loadItem(forTypeIdentifier: ) ask the item provider to actually provide us with its item, but you'll notice it uses a closure so this code executes asynchronously. That is, the method will carry on executing while the item provider is busy loading and sending us its data.
        itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
          // a dictionary of data that contains all the information Apple wants us to have, and we put that into itemDictionary.
          guard let itemDictionary = dict as? NSDictionary else { return }
          // We sent a dictionary of data from JavaScript, so we typecast javaScriptValues as an NSDictionary again so that we can pull out values using keys.
          guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
//          print(javaScriptValues)
          self?.pageTitle = javaScriptValues["title"] as? String ?? ""
          self?.pageURL = javaScriptValues["URL"] as? String ?? ""
          
          DispatchQueue.main.async {
            self?.title = self?.pageTitle
          }
        }
      }
    }
    
    // Create a new NotificationCenter object
    let notificationCenter = NotificationCenter.default
    // add observers when a notification is triggerd
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(selectScript))
  }
  
  // A method that will send data back to safari
  @objc func done() {
    // Create a new NSExtensionItem object that will host our items.
    let item = NSExtensionItem()
    // Create a dictionary containing the key "customJavaScript" and the value of our script.
    let argument: NSDictionary = ["customJavaScript": scriptTextView.text]
    // Put that dictionary into another dictionary with the key NSExtensionJavaScriptFinalizeArgumentKey.
    let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
    // Wrap the big dictionary inside an NSItemProvider object with the type identifier kUTTypePropertyList.
    let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
    // Place that NSItemProvider into our NSExtensionItem as its attachments.
    item.attachments = [customJavaScript]
    // Call completeRequest(returningItems:), returning our NSExtensionItem.
    extensionContext?.completeRequest(returningItems: [item])
  }
  
  @objc func adjustForKeyboard(notification: Notification) {
    
    guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    // pull out the correct frame of the keyboard.
    let keyboardScreenEndFrame = keyboardValue.cgRectValue
    // convert the rectangle to our view's co-ordinates
    let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
    //
    if notification.name == UIResponder.keyboardWillHideNotification {
      scriptTextView.contentInset = .zero
    } else {
      scriptTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
    }
    // indent the edges of our text view so that it appears to occupy less space even though its constraints are still edge to edge in the view.
    scriptTextView.scrollIndicatorInsets = scriptTextView.contentInset
    
    let selectedRange = scriptTextView.selectedRange
    scriptTextView.scrollRangeToVisible(selectedRange)
  }
  
  @objc func selectScript() {
    let ac = UIAlertController(title: "Select a Script:", message: nil, preferredStyle: .actionSheet)
    ac.addAction(UIAlertAction(title: "Replace Heading", style: .default, handler: { [weak self] _ in
      self?.scriptTextView.text = """
       document.querySelector("h1").innerHTML = "Title was updated with JavaScript injection :)";
      """
    }))
    ac.addAction(UIAlertAction(title: "Page Title", style: .default, handler: { [weak self] _ in
      self?.scriptTextView.text = "alert(document.title);"
    }))
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(ac, animated: true)
  }
  
}
