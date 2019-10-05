//
//  AuthorCommitsTableViewController.swift
//  GitHubCommits
//
//  Created by Mr.Kevin on 30/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit

class AuthorCommitsTableViewController: UITableViewController {
  
  var author: Author!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = author.name
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return author.commits.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
    cell.textLabel?.text = (author.commits[indexPath.row] as AnyObject).message
    cell.textLabel?.numberOfLines = 0
    
    return cell
  }
  
}
