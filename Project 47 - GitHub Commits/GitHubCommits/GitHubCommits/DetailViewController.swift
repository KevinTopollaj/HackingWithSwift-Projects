//
//  DetailViewController.swift
//  GitHubCommits
//
//  Created by Mr.Kevin on 29/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  
  @IBOutlet var detailLabel: UILabel!
  
  var detailItem: Commit?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "Message", style: .plain, target: nil, action: nil)
    
    if let detail = self.detailItem {
      detailLabel.text = detail.message
      
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Commit 1/\(detail.author.commits.count)", style: .plain, target: self, action: #selector(showAuthorCommits))
    }
    
  }
  
  @objc func showAuthorCommits() {
//    let ac = UIAlertController(title: "This author has \(detailItem?.author.commits.count ?? 0) commits", message: nil, preferredStyle: .alert)
//    ac.addAction(UIAlertAction(title: "OK", style: .default))
//    present(ac, animated: true)
    
    let authorVC = AuthorCommitsTableViewController()
    authorVC.author = detailItem?.author
    navigationController?.pushViewController(authorVC, animated: true)
  }
  
}
