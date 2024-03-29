//
//  DetailViewController.swift
//  WhitehousePetitions
//
//  Created by Mr.Kevin on 14/07/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
  
  var webView: WKWebView!
  var detailItem: Petition?
  
  // will load a web view into the main view
  override func loadView() {
    webView = WKWebView()
    view = webView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = detailItem?.title
    guard let detailItem = detailItem else { return }
    
    // create the html that will represent the data the web view
    let html = """
      <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <style> body { font-size: 170%; } </style>
        </head>
        <body>
          \(detailItem.body)
        </body>
      </html>
    """
    // load the html into the web view
    webView.loadHTMLString(html, baseURL: nil)
    
  }

  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
