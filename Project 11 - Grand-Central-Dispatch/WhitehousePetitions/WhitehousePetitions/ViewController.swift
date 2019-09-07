//
//  ViewController.swift
//  WhitehousePetitions
//
//  Created by Mr.Kevin on 14/07/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

  var petitions = [Petition]()
  var filteredPetitions = [Petition]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
    
    // Start by updating the viewDidLoad() method so that it downloads the data from the Whitehouse petitions server, converts it to a Swift Data object, then tries to convert it to an array of Petition instances.
    
    // create a URL String
    let urlString: String
    let tag = navigationController?.tabBarItem.tag
    
    switch tag {
    case 0:
      urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
    case 1:
      urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
    default:
      urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchPetitions))
    }
    
    // Use GCD to run this code on the background thread asynchronously with a quality of service (QoS) User Initiated.
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      // check if it is a valid URL
      if let url = URL(string: urlString) {
        // check if the Data object is created from the url
        if let data = try? Data(contentsOf: url) {
          self?.parse(json: data)
          return
        }
      }
      // To stop showError() being called regardless of the result of our fetch call, we need to move it inside the call to DispatchQueue.global()
      self?.showError(errorTitle: "Loading error", errorMessage: "There was a problem loading the feed; please check your connection and try again.")
    }
  }
  
  // method that will parse the JSON data
  func parse(json: Data) {
    // create a decoder instance
    let decoder = JSONDecoder()
    // decode the json data using the decoder
    if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
      petitions = jsonPetitions.results
      filteredPetitions = petitions
      // Use GCD to reload the data on the main thread that is used specificaly for UI
      DispatchQueue.main.async { [weak self] in
        self?.tableView.reloadData()
      }
    }
  }
  
  @objc func showCredits() {
    let ac = UIAlertController(title: "Data comes from the We The People API of the Whitehouse", message: nil, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default))
    present(ac, animated: true)
  }
  
  @objc func searchPetitions() {
    let ac = UIAlertController(title: "Search Petition", message: nil, preferredStyle: .alert)
    ac.addTextField()
    
    let searchAction = UIAlertAction(title: "Search", style: .default) {
      [weak self] (_) in
      guard let petitionTitle = ac.textFields?[0].text else { return }
      if !petitionTitle.isEmpty {
        self?.search(petitionTitle)
      } else {
        self?.showError(errorTitle: "No petition found!", errorMessage: "Please eneter a valid petition.")
      }
    }
    
    ac.addAction(searchAction)
    present(ac, animated: true)
  }
  
  func search(_ petitionTitle: String) {
    // use GCD to do the filtering in backdround
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      let filtered = self?.petitions.filter { (petition) -> Bool in
        if petition.title.contains(petitionTitle) {
          return true
        }
        return false
      }
      
      self?.filteredPetitions = filtered!
    }
    
    // Use GCD to reload the data on the main thread
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }

  func showError(errorTitle: String, errorMessage: String) {
    // Use GCD to run the alert on the main thread sice it is part of the UI
    DispatchQueue.main.async { [weak self] in
      let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK", style: .default))
      self?.present(ac, animated: true)
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredPetitions.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let petition = filteredPetitions[indexPath.row]
    cell.textLabel?.text = petition.title
    cell.detailTextLabel?.text = petition.body
    return cell
  }
  
  // will show the detail vc when a row is selected
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let detailVC = DetailViewController()
    detailVC.detailItem = filteredPetitions[indexPath.row]
    navigationController?.pushViewController(detailVC, animated: true)
  }
}

