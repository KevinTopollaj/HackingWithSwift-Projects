//
//  DetailViewController.swift
//  CapitalCities
//
//  Created by Mr.Kevin on 28/07/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
  
  var webView: WKWebView!
  var cityName: String?
  
  override func loadView() {
    webView = WKWebView()
    view = webView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let city = cityName else { return }
    title = city
    guard let url = URL(string: "https://www.wikipedia.org/wiki/\(city)") else { return }
    self.webView.load(URLRequest(url: url))
    webView.allowsBackForwardNavigationGestures = true
    
  }
}

