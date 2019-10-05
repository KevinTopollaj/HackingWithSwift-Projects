//
//  ViewController.swift
//  UnitTestingWithXCTest
//
//  Created by Mr.Kevin on 30/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
  
  var playData = PlayData()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Words"
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filterWords))
  }
  
  @objc func filterWords() {
    let ac = UIAlertController(title: "Filter by Word or Number", message: nil, preferredStyle: .alert)
    ac.addTextField()
    
    ac.addAction(UIAlertAction(title: "Filter", style: .default, handler: { [unowned self] _ in
      let userInput = ac.textFields?[0].text ?? "0"
      self.playData.applyUserFilter(userInput)
      self.tableView.reloadData()
    }))
    
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    
    present(ac, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return playData.filteredWords.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let word = playData.filteredWords[indexPath.row]
    cell.textLabel?.text = word
    // use the count(for:) method to find out how often a word was used:
    cell.detailTextLabel?.text = "\(playData.wordsCount.count(for: word))"
    return cell
  }


}

