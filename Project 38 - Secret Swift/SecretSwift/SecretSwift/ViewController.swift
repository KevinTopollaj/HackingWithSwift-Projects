//
//  ViewController.swift
//  SecretSwift
//
//  Created by Mr.Kevin on 17/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import LocalAuthentication
import UIKit

class ViewController: UIViewController {
  
  @IBOutlet var secretTextView: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Nothing to see here"
    
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    
    // create a notification that will notify us when our app is in the background and save the text in the secretTextView
    notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
    
    KeychainWrapper.standard.set("pass", forKey: "password")
    
  }
  
  @objc func adjustForKeyboard(notification: Notification) {
    guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    // will take in consideration only the screen size
    let keyboardScreenEndFrame = keyboardValue.cgRectValue
    // // will take in consideration the view size and the rotation
    let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
    
    if notification.name == UIResponder.keyboardWillHideNotification {
      secretTextView.contentInset = .zero
    } else {
      secretTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
    }
    // scroll view will match the size of the text view
    secretTextView.scrollIndicatorInsets = secretTextView.contentInset
    let selectedRange = secretTextView.selectedRange
    secretTextView.scrollRangeToVisible(selectedRange)
  }
  
  
  @IBAction func authenticateTapped(_ sender: Any) {
    // create a location authentication context object
    let context = LAContext()
    var error: NSError?
    
    // Check whether the device is capable of supporting biometric authentication
    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
      let reason = "Identify yourself using Touch ID!"
      // If so, request that the biometry system begin a check now
      context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
        DispatchQueue.main.async {
          if success {
            self?.unlockSecretMessage()
          } else {
            let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified, please try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(ac, animated: true)
          }
        }
      }
    } else {
      // no biomerty
      let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication. Enter the password to gain access!", preferredStyle: .alert)
      ac.addTextField()
      
      ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] action in
        guard !(ac.textFields?[0].text?.isEmpty)! else {
          let ac = UIAlertController(title: "Please enter a valid password!", message: nil, preferredStyle: .alert)
          ac.addAction(UIAlertAction(title: "OK", style: .default))
          self?.present(ac, animated: true)
          return
        }
        guard let textFieldPassword = ac.textFields?[0].text else { return }
        
        DispatchQueue.main.async {
          if textFieldPassword == KeychainWrapper.standard.string(forKey: "password") {
            self?.unlockSecretMessage()
          } else {
            let ac = UIAlertController(title: "Wrong Password!", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(ac, animated: true)
          }
        }
        
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        self.present(ac, animated: true)
    }
  }
  
  /// A method that will load the message into the text view
  func unlockSecretMessage() {
    // show the text view
    secretTextView.isHidden = false
    // change the title
    title = "Secret stuff!"
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveSecretMessage))
    // read the keychain's text into the secretTextView
    if let text = KeychainWrapper.standard.string(forKey: "SecretMessage") {
      secretTextView.text = text
    }
  }
  
  /// A method that will save the text view's text to the keychain
  @objc func saveSecretMessage() {
    // make sure the secretTextView is not hidden
    guard secretTextView.isHidden == false else { return }
    // write the text view's text to the keychain
    KeychainWrapper.standard.set(secretTextView.text, forKey: "SecretMessage")
    // tell our text view that we're finished editing it, so the keyboard can be hidden
    secretTextView.resignFirstResponder()
    // hide the secretTextView
    secretTextView.isHidden = true

    // change the title
    title = "Nothing to see here"
    
    navigationItem.rightBarButtonItem = .none
  }
  
}

