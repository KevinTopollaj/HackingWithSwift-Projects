//
//  ViewController.swift
//  StromViewer
//
//  Created by Mr.Kevin on 04/07/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
  
  // create an empty array that will containi our images
  var pictures = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // set a title for the navigation controller
    title = "Storm Viewer"
    // use the large title
    navigationController?.navigationBar.prefersLargeTitles = true
    
    // create an instance of File Manager that lets us work with the file system
    let fm = FileManager.default
    // path is set to the resource path of our app's bundle.
    // bundle is a directory containing our compiled program and all our assets.
    // this line says, "tell me where I can find all those images I added to my app."
    let path = Bundle.main.resourcePath!
    // items constant will be an array of strings containing filenames.
    let items = try! fm.contentsOfDirectory(atPath: path)
    
    // than it will loop all the file names and will find those whos name starts with "nssl"
    for item in items {
      if item.hasPrefix("nssl") {
        // add them all in the pictures array
        pictures.append(item)
      }
    }
    
    // sort all the pictures and add them back to the array
    pictures = pictures.sorted()
  }
  
  // a method that will display the number of rows in the table based on the number of elements we have in the pictures array
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pictures.count
  }
  
  // a method that will specify how each row will look like
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // create a cell instance with the Identifier that we provide
    let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
    // asign a text label to the cell by using the pictures array
    cell.textLabel?.text = pictures[indexPath.row]
    // return the cell
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // 1- Load an instance of DetailViewController from the stryboard
    if let detailVC = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
      // 2- set the instance property value
      detailVC.selectedImage = pictures[indexPath.row]
      detailVC.totalNumberOfPictures = pictures.count
      detailVC.selectedPicturePosition = indexPath.row + 1
      // 3- push it to the navigation controller
      navigationController?.pushViewController(detailVC, animated: true)
    }
  }
  
}

