//
//  ViewController.swift
//  Multibrowser
//
//  Created by Mr.Kevin on 24/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {

  /// Outlets
  @IBOutlet var addressTextView: UITextField!
  @IBOutlet var stackView: UIStackView!
  
  /// Properties
  weak var activeWebView: WKWebView?   // will contain the selected web view
  
  override func viewDidLoad() {
    super.viewDidLoad()

    setDefaultTitle()
    
    let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWebView))
    let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteWebView))
    navigationItem.rightBarButtonItems = [delete, add]
  }
  
  /// A method that will set the title of the selected webview
  func setDefaultTitle() {
    title = "Multibrowser"
  }
  
  @objc func addWebView() {
    // create an instance of the webview
    let webView = WKWebView()
    // set our vc to be the web view delegate
    webView.navigationDelegate = self
    // add the web view in the stack view
    stackView.addArrangedSubview(webView)
    
    // add an example url to load
    let url = URL(string: "https://www.hackingwithswift.com")!
    webView.load(URLRequest(url: url))
    
    // add a border to the selected web view
    webView.layer.borderColor = UIColor.blue.cgColor
    selectWebView(webView)
    
    // create a tap gesture recognizer
    let recognizer = UITapGestureRecognizer(target: self, action: #selector(webViewTapped))
    recognizer.delegate = self
    // add it to the web view
    webView.addGestureRecognizer(recognizer)
  }
  
  func selectWebView(_ webView: WKWebView){
    // iterate over all views in the stackview
    for view in stackView.arrangedSubviews {
      view.layer.borderWidth = 0
    }
    
    // set the activeWebView to be the webView and to have a border width of three points
    activeWebView = webView
    webView.layer.borderWidth = 3
    updateUI(for: webView)
  }
  
  /// A method that will be used by the UITapGestureRecognizer
  @objc func webViewTapped(_ recognizer: UITapGestureRecognizer) {
    // get the selected web view and apply the border
    if let selectedWebView = recognizer.view as? WKWebView {
      selectWebView(selectedWebView)
    }
    
  }
  
  /// A UIGestureRecognizerDelegate method
  // will tell iOS we want these gesture recognizers to trigger alongside the recognizers built into the WKWebView:
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
  
  /// A delegate method that will detect when a user enters a link in the textField and press return on the keyboard
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // get the activeWebView and the text in the textField
    if let webView = activeWebView,
      let address = addressTextView.text {
      // create a url from the text in the textField
      if let url = URL(string: "https://\(address)"){
        // load that url in the web view
        webView.load(URLRequest(url: url))
      }
    }
    
    // hide the keyboard
    textField.resignFirstResponder()
    return true
  }
  
  
  @objc func deleteWebView() {
    // get the activeWebView
    if let webView = activeWebView {
      // find it's index in the stackView
      if let index = stackView.arrangedSubviews.firstIndex(of: webView) {
        // remove the webView from the stack view
        stackView.removeArrangedSubview(webView)
        // and remove it from the view hierarchy
        webView.removeFromSuperview()
        
        if stackView.arrangedSubviews.count == 0 {
          setDefaultTitle()
        } else {
          // convert the Index value into an integer
          var currentIndex = Int(index)
          
          // if that was the last web view in the stack, go back one
          if currentIndex == stackView.arrangedSubviews.count {
            currentIndex = stackView.arrangedSubviews.count - 1
          }
          
          // find the web view at the new index and select it
          if let newSelectedWebView = stackView.arrangedSubviews[currentIndex] as? WKWebView {
            selectWebView(newSelectedWebView)
          }
        }
        
      }
    }
  }
  
  
  // When we have a regular horizontal size class we'll use horizontal stacking, and when we have a compact size class we'll use vertical stacking.
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    if traitCollection.horizontalSizeClass == .compact {
      stackView.axis = .vertical
    } else {
      stackView.axis = .horizontal
    }
  }
  
  /// A method that updates the navigation bar to show the page title from the active web view when it changes.
  func updateUI(for webView: WKWebView) {
    title = webView.title
    addressTextView.text = webView.url?.absoluteString ?? ""
  }

  /// A delegate method triggerd when a web view finished loading
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    if webView == activeWebView {
      updateUI(for: webView)
    }
  }
}
