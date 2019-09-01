//
//  ViewController.swift
//  WorldFlags
//
//  Created by Mr.Kevin on 07/07/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit

class ViewController: UITableViewController{
  
  var flags = [String]()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Flags"
    navigationController?.navigationBar.prefersLargeTitles = true
    
    flags += ["russia", "france", "germany", "ireland", "us", "nigeria", "spain", "poland", "estonia", "monaco", "uk", "italy"]

  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return flags.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Flag", for: indexPath)
    let flag = flags[indexPath.row]
    cell.textLabel?.text = flag.uppercased()
    cell.imageView?.image = UIImage(named: flag)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let detailsVC = storyboard?.instantiateViewController(withIdentifier: "Details") as? DetailsViewController {
      detailsVC.selectedFlag = flags[indexPath.row]
      navigationController?.pushViewController(detailsVC, animated: true)
    }
  }

}

