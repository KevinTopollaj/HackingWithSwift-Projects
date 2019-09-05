//
//  ViewController.swift
//  ShoppingList
//
//  Created by Mr.Kevin on 13/07/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
  
  var shoppingList = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Shopping List"
    
    let addNavButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
    let shareNavButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareShoppingList))
    navigationItem.rightBarButtonItems = [addNavButton, shareNavButton]
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeAllItems))
    
  }
  
  @objc func removeAllItems() {
    let ac = UIAlertController(title: "Do you want to delete all items?", message: nil, preferredStyle: .alert)
    let removeItems = UIAlertAction(title: "Delete", style: .destructive) {
      [weak self] _ in
      self?.shoppingList.removeAll()
      self?.tableView.reloadData()
    }
    ac.addAction(removeItems)
    present(ac, animated: true)
  }
  
  @objc func shareShoppingList() {
    // will create a string from the shoppingList array and put each item in a new line
    let list = shoppingList.joined(separator: "\n")
    let activityVC = UIActivityViewController(activityItems: [list], applicationActivities: [])
    activityVC.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    present(activityVC, animated: true)
  }
  
  @objc func addItem() {
    let alertController = UIAlertController(title: "Add an item to the shopping list", message: nil, preferredStyle: .alert)
    alertController.addTextField()
    
    let addItemInShoppingList = UIAlertAction(title: "Add Item", style: .default) {
      [weak self, weak alertController] _ in
      guard let item = alertController?.textFields?[0].text else { return }
      self?.insertShoppingList(item)
    }
    
    alertController.addAction(addItemInShoppingList)
    present(alertController, animated: true)
  }
  
  // method that will insert an item in to the shopping list
  func insertShoppingList(_ item: String) {
    let lowerCaseItem = item.lowercased()
    if !lowerCaseItem.isEmpty {
      shoppingList.insert(lowerCaseItem, at: 0)
      let indexPath = IndexPath(row: 0, section: 0)
      tableView.insertRows(at: [indexPath], with: .right)
    } else {
      handleError(errorTitle: "No Item Found !", errorMessage: "Please insert an item to the shopping list!")
    }
  }
  
  func handleError(errorTitle: String, errorMessage: String) {
    let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default))
    present(ac, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return shoppingList.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
    cell.textLabel?.text = shoppingList[indexPath.row]
    return cell
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      shoppingList.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }
}
