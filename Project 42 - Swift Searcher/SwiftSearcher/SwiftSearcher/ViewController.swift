//
//  ViewController.swift
//  SwiftSearcher
//
//  Created by Mr.Kevin on 25/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import CoreSpotlight
import MobileCoreServices

import SafariServices
import UIKit

class ViewController: UITableViewController {
  
  // an array inside an array that will store projects
  var projects = [Project]()
  // an array that will store favourite projects
  var favorites = [Int]()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    projects.append(Project(title: "Project 1: Storm Viewer", subtitle: "Constants and variables, UITableView, UIImageView, FileManager, storyboards"))
    projects.append(Project(title: "Project 2: Guess the Flag", subtitle: "@2x and @3x images, asset catalogs, integers, doubles, floats, operators (+= and -=), UIButton, enums, CALayer, UIColor, random numbers, actions, string interpolation, UIAlertController"))
    projects.append(Project(title: "Project 3: Social Media", subtitle: "UIBarButtonItem, UIActivityViewController, the Social framework, URL"))
    projects.append(Project(title: "Project 4: Easy Browser", subtitle: "loadView(), WKWebView, delegation, classes and structs, URLRequest, UIToolbar, UIProgressView., key-value observing"))
    projects.append(Project(title: "Project 5: Word Scramble", subtitle: "Closures, method return values, booleans, NSRange"))
    projects.append(Project(title: "Project 6: Auto Layout", subtitle: "Get to grips with Auto Layout using practical examples and code"))
    projects.append(Project(title: "Project 7: Whitehouse Petitions", subtitle: "JSON, Data, UITabBarController"))
    projects.append(Project(title: "Project 8: 7 Swifty Words", subtitle: "addTarget(), enumerated(), count, index(of:), property observers, range operators."))
    
    // get the favourites from the user defaults
    let defaults = UserDefaults.standard
    if let savedFavorites = defaults.object(forKey: "favorites") as? [Int] {
      favorites = savedFavorites
    }
    
    // set the table view to be in editing mode, and tell it to let users tap on rows to select them.
    tableView.isEditing = true
    tableView.allowsSelectionDuringEditing = true
  }
  
  /// A method that will use NSAttributedString to design the text in the cells
  func makeAttributedString(title: String, subtitle: String) -> NSAttributedString {
    // create attributes
    let titleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline),
                           NSAttributedString.Key.foregroundColor: UIColor.red
                           ]
    let subtitleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline)]
    
    // create attributed string for title and subtitle
    let titleString = NSMutableAttributedString(string: "\(title)\n", attributes: titleAttributes)
    let subtitleString = NSAttributedString(string: subtitle, attributes: subtitleAttributes)
    
    // add the subtitle to the title
    titleString.append(subtitleString)
    
    return titleString
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return projects.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let project = projects[indexPath.row]
    cell.textLabel?.attributedText = makeAttributedString(title: project.title, subtitle: project.subtitle)
    // will make each cell to have as many space as it needs for its content
    cell.textLabel?.numberOfLines = 0
    
    if favorites.contains(indexPath.row) {
      cell.editingAccessoryType = .checkmark
    } else {
      cell.editingAccessoryType = .none
    }
    
    return cell
  }
  
  /// A method that will create and present a safari vc
  func showTutorial(_ which: Int) {
    // create a url
    if let url = URL(string: "https://www.hackingwithswift.com/read/\(which + 1)") {
      // create a configuration for safari
      let config = SFSafariViewController.Configuration()
      config.entersReaderIfAvailable = true
      // create a safari vc using the url and configuration
      let vc = SFSafariViewController(url: url, configuration: config)
      // present the safari vc
      present(vc, animated: true)
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    showTutorial(indexPath.row)
  }
  
  override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    if favorites.contains(indexPath.row) {
      return .delete
    } else {
      return .insert
    }
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
    if editingStyle == .insert {
      // add it to the favourite array
      favorites.append(indexPath.row)
      // will handle adding items to Core Spotlight.
      index(item: indexPath.row)
    } else {
      // find the index of the item in the array
      if let index = favorites.firstIndex(of: indexPath.row) {
        // remove it from the favourites array
        favorites.remove(at: index)
        // will handle removeing items from Core Spotlight.
        deindex(item: indexPath.row)
      }
    }
    
    // save the favourites to the userdefaults
    let defaults = UserDefaults.standard
    defaults.set(favorites, forKey: "favorites")
    
    // reload the specifed rows in the table
    tableView.reloadRows(at: [indexPath], with: .none)
    
  }
  
  // will handle adding items to Core Spotlight.
  func index(item: Int) {
    // identifies the project that has been marked as favourite
    let project = projects[item]
    // create a attributeSet that stores info for the favourite project
    let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
    attributeSet.title = project.title
    attributeSet.contentDescription = project.subtitle
    // the item that is being searched
    let item = CSSearchableItem(uniqueIdentifier: "\(item)", domainIdentifier: "com.hackingwithswift", attributeSet: attributeSet)
    item.expirationDate = Date.distantFuture
    // index the search item
    CSSearchableIndex.default().indexSearchableItems([item]) { (error) in
      if let error = error {
        print("Indexing error: \(error.localizedDescription)")
      } else {
        print("Search item successfully indexed!")
      }
    }
  }
  
  // will handle removing items to Core Spotlight.
  func deindex(item: Int) {
    // delete the item for that search index
    CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: ["\(item)"]) { error in
      if let error = error {
        print("Deindexing error: \(error.localizedDescription)")
      } else {
        print("Search item successfully removed!")
      }
    }
  }
  
}

