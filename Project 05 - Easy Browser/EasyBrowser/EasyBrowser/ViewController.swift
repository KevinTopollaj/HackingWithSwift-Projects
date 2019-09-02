//
//  ViewController.swift
//  EasyBrowser
//
//  Created by Mr.Kevin on 08/07/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
  
  /// Properties
  var webView: WKWebView!
  var progressView: UIProgressView!
  // create an array of websites
  var websites = [String]()
  
  /// creates the view that the controller manages
  override func loadView() {
    // First, create a new instance of WKWebView component and assign it to the webView property.
    webView = WKWebView()
    // Second, set the web view's navigationDelegate property to self, and conform to its protocol
    // "when any web page navigation happens, please tell me – in the current view controller.”
    webView.navigationDelegate = self
    // Third, make our view (the root view of the view controller) that web view.
    view = webView
  }
  
  func getAndLoadWebsites() {
    // get the websites from the website.txt file and add them into the websites array
    if let websitesFileURL = Bundle.main.url(forResource: "website", withExtension: ".txt") {
      if let websiteFileString = try? String(contentsOf: websitesFileURL) {
        websites = websiteFileString.components(separatedBy: "\n")
        websites.removeLast()
      }
    }
    
    // creates a URL and unwrapps it
    let url = URL(string: "https://" + websites[0])!
    // creates a new URLRequest object from that URL, and gives it to our web view to load
    webView.load(URLRequest(url: url))
    // enables a property on the web view that allows users to swipe from the left or right edge to move backward or forward in their web browsing.
    webView.allowsBackForwardNavigationGestures = true
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    getAndLoadWebsites()
    addNavigation()
    
    /// USE KVO:
    // 1- First, we add ourselves as an observer of the property on the web view and the property that we want to observe 'estimatedProgress'
    webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
  }
  
  // 2- Once you have registered as an observer using KVO, you must implement a method called observeValue(). This tells you when an observed value has changed:
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == "estimatedProgress" {
      progressView.progress = Float(webView.estimatedProgress)
    }
  }
  
  func addNavigation() {
    //create a nav bar button
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
    
    // create a instance of progress view
    progressView = UIProgressView(progressViewStyle: .default)
    // tells the progress view to set its layout size so that it fits its contents fully
    progressView.sizeToFit()
    // create a progress button
    let progressButton = UIBarButtonItem(customView: progressView)
    
    // create bar buttons
    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
    let back = UIBarButtonItem(barButtonSystemItem: .rewind, target: webView, action: #selector(webView.goBack))
    let forward = UIBarButtonItem(barButtonSystemItem: .fastForward, target: webView, action: #selector(webView.goForward))
    
    // add them in a toolbarItems array
    toolbarItems = [progressButton, spacer, back, refresh, forward]
    // the toolbar will be shown – and its items will be loaded from our current view.
    navigationController?.isToolbarHidden = false
  }
  
  @objc func openTapped() {
    let alertController = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
    for website in websites {
      alertController.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
    }
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    // for iPad
    alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
    present(alertController, animated: true)
  }
  
  // the handler method whitch takes one parameter, UIAlertAction object that was selected by the user
  func openPage(action: UIAlertAction) {
    guard let actionTitle = action.title else { return }
    guard let url = URL(string: "https://" + actionTitle) else { return }
    webView.load(URLRequest(url: url))
  }
  
  // set the title when the web view has finish loading, a WKNavigationDelegate protocol method
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    title = webView.title
  }
  
  // This delegate callback allows us to decide whether we want to allow navigation to happen or not every time something happens.
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    // So, we need to evaluate the URL to see whether it's in our safe list, then call the decisionHandler with a negative or positive answer.
    
    // get the url from the navigationAction request
    let url = navigationAction.request.url
    
    // allow to load the host if it contains a website that we provide
    if let host = url?.host {
      for website in websites {
        if host.contains(website){
          decisionHandler(.allow)
          return
        }
      }
    }
    
    decisionHandler(.cancel)
  }
}

