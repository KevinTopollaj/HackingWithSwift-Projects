//
//  ViewController.swift
//  GitHubCommits
//
//  Created by Mr.Kevin on 29/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import CoreData
import UIKit

class ViewController: UITableViewController, NSFetchedResultsControllerDelegate {
  
  /// Properties
  
  // A container that encapsulates the Core Data stack in your application.
  var container: NSPersistentContainer!
  
  // an array that will contain commits
//  var commits = [Commit]()
  
  // declare a NSPredicate property
  var commitPredicate: NSPredicate?
  
  // property that will hold the fetched results controller for commits
  var fetchedResultsController: NSFetchedResultsController<Commit>!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "GitHub Commits"
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "All Commits", style: .plain, target: nil, action: nil)
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(changeFilter))
    
    // initialize the NSPersistentContainer
    container = NSPersistentContainer(name: "Project38")
    // loads the saved database if it exists, or creates it otherwise.
    container.loadPersistentStores { (storeDescription, error) in
      
      // instructs Core Data to allow updates to objects: if an object exists in its data store with message A, and an object with the same unique constraint ("sha" attribute) exists in memory with message B, the in-memory version "trumps" (overwrites) the data store version.
      self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
      
      if let error = error {
        print("Unresolved error: \(error)")
      }
    }
    
    // will run a method on the background thread
    performSelector(inBackground: #selector(fetchCommits), with: nil)
    
    loadSavedData()
  }
  
  @objc func changeFilter() {
    let ac = UIAlertController(title: "Filter commits...", message: nil, preferredStyle: .actionSheet)
    
    // 1. first predicate
    ac.addAction(UIAlertAction(title: "Show only fixes", style: .default, handler: {[unowned self] _ in
      let str = "fix"
      self.commitPredicate = NSPredicate(format: "message CONTAINS[c] %@", str)
      self.loadSavedData()
    }))
    
    // 2.
    ac.addAction(UIAlertAction(title: "Ignore Pull Requests", style: .default, handler: { [unowned self] _ in
      let str = "Merge pull request"
      self.commitPredicate = NSPredicate(format: "NOT message BEGINSWITH %@", str)
      self.loadSavedData()
    }))
    
    // 3.
    ac.addAction(UIAlertAction(title: "Show only recent", style: .default) { [unowned self] _ in
      let twelveHoursAgo = Date().addingTimeInterval(-43200)
      self.commitPredicate = NSPredicate(format: "date > %@", twelveHoursAgo as NSDate)
      self.loadSavedData()
    })
    
    // predicate that will filter all Joe Groff commits
    let name = "Joe Groff"
    ac.addAction(UIAlertAction(title: "Show only \(name) commits", style: .default, handler: { [unowned self] _ in
      self.commitPredicate = NSPredicate(format: "author.name == %@", name)
      self.loadSavedData()
    }))
    
    // 4.
    ac.addAction(UIAlertAction(title: "Show all commits", style: .default) { [unowned self] _ in
      self.commitPredicate = nil
      self.loadSavedData()
    })
    
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(ac, animated: true)
  }
  
  // When you finished your changes and want to write them permanently to disk
  func saveContext() {
    if container.viewContext.hasChanges {
      do {
        try container.viewContext.save()
      } catch {
        print("An error ocurred while saving: \(error)")
      }
    }
  }
  
  @objc func fetchCommits() {
    
    let newestCommitData = getNewestCommitDate()
    
    // create a url
    guard let url = URL(string: "https://api.github.com/repos/apple/swift/commits?per_page=100&since=\(newestCommitData)") else { return }
    
    // try to get the data form that url
    if let data = try? String(contentsOf: url) {
      
      // give the data to SwiftyJSON to parse
      let jsonCommits = JSON(parseJSON: data)
      
      // read the commits back out and put them into an array
      let jsonCommitArray = jsonCommits.arrayValue
      
      print("Received \(jsonCommitArray.count) new commits.")
      
      // go back to the main thread to loop over the array of GitHub commits and save the managed object context when we're done.
      DispatchQueue.main.async { [unowned self] in
        for jsonCommit in jsonCommitArray {
          // creates a Commit object inside the managed object context
          let commit = Commit(context: self.container.viewContext)
          
          self.configure(commit: commit, usingJSON: jsonCommit)
        }
        
        self.saveContext()
        self.loadSavedData()
      }
    }
  }
  
  // will add all the parsed json data to the Commit attributes
  func configure(commit: Commit, usingJSON json: JSON) {
    commit.sha = json["sha"].stringValue
    commit.message = json["commit"]["message"].stringValue
    commit.url = json["html_url"].stringValue
    
    // will create a formatter to format the date in the correct Date format
    let formatter = ISO8601DateFormatter()
    commit.date = formatter.date(from: json["commit"]["committer"]["date"].stringValue) ?? Date()
    
    
    // declare an author property
    var commitAuthor: Author!
    
    // see if this author exists already
    let authorRequest = Author.createFetchRequest()
    authorRequest.predicate = NSPredicate(format: "name == %@", json["commit"]["committer"]["name"].stringValue)
    
    if let authors = try? container.viewContext.fetch(authorRequest) {
      if authors.count > 0 {
        // we have this author already
        commitAuthor = authors[0]
      }
    }
    
    if commitAuthor == nil {
      // we didn't find a saved author, create a new one
      let author = Author(context: container.viewContext)
      author.name = json["commit"]["committer"]["name"].stringValue
      author.email = json["commit"]["committer"]["email"].stringValue
      commitAuthor = author
    }
    
    // use the author, either saved or new
    commit.author = commitAuthor
    
  }
  
  func getNewestCommitDate() -> String {
    let formatter = ISO8601DateFormatter()
    
    let newestCommits = Commit.createFetchRequest()
    let sort = NSSortDescriptor(key: "date", ascending: false)
    newestCommits.sortDescriptors = [sort]
    // tells Core Data how many items you want it to return.
    newestCommits.fetchLimit = 1
    
    if let commits = try? container.viewContext.fetch(newestCommits) {
      if commits.count > 0 {
        // addingTimeInterval() is used to add one second to the time from the previous commit, otherwise GitHub will return the newest commit again.
        return formatter.string(from: commits[0].date.addingTimeInterval(1))
      }
    }
    
    return formatter.string(from: Date(timeIntervalSince1970: 0))
  }
  
  /// TableView methods
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return fetchedResultsController.sections?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return commits.count
    let sectionInfo = fetchedResultsController.sections![section]
    return sectionInfo.numberOfObjects
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Commit", for: indexPath)
    
//    let commit = commits[indexPath.row]
    let commit = fetchedResultsController.object(at: indexPath)
    cell.textLabel?.text = commit.message
    cell.detailTextLabel?.text = "By \(commit.author.name) on \(commit.date.description)"
//    cell.textLabel?.numberOfLines = 0
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let detailVC = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
//      detailVC.detailItem = commits[indexPath.row]
      detailVC.detailItem = fetchedResultsController.object(at: indexPath)
      navigationController?.pushViewController(detailVC, animated: true)
    }
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
    if editingStyle == .delete {
      // get a commit a the specified row
//      let commit = commits[indexPath.row]
      let commit = fetchedResultsController.object(at: indexPath)
      
      // use manged object context to delete that comit from core data
      container.viewContext.delete(commit)
      
      // remove it from the array
//      commits.remove(at: indexPath.row)
      // remove it from the table view
//      tableView.deleteRows(at: [indexPath], with: .fade)
      
      // save the manged object context data after removing the commit to persist the data
      saveContext()
    }
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return fetchedResultsController.sections![section].name
  }

  
  /// Will load saved data from the persistent store
  func loadSavedData() {
    
    if fetchedResultsController == nil {
      // create a fetch request for all Commit objects
      let request = Commit.createFetchRequest()
      // create an NSSortDescriptor and apply it on the request
      let sort = NSSortDescriptor(key: "author.name", ascending: false)
      request.sortDescriptors = [sort]
      // fetch only 20 obj at a time
      request.fetchBatchSize = 20
      
      // initialize the fetchedResultsController
      fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: container.viewContext, sectionNameKeyPath: "author.name", cacheName: nil)
      // set our VC to be the delegate of the fetchedResultsController
      fetchedResultsController.delegate = self
    }
    
    fetchedResultsController.fetchRequest.predicate = commitPredicate
    
    do {
      // run the request on the ManagedObjectContext fetch method and add the result on the commits array
//      commits = try container.viewContext.fetch(request)
      // test that we got the data
      
      // use the fetchedResultsController to fetch the data
      try fetchedResultsController.performFetch()
//      print("Got \(commits.count) commits")
      tableView.reloadData()
    } catch {
      print("Fetching data failed")
    }
  }
  
  
  /// A NSFetchedResultsControllerDelegate method that gets called by the fetched results controller when an object changes.
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    
    switch type {
    case .delete:
      tableView.deleteRows(at: [indexPath!], with: .automatic)
    default:
      break
    }
    
  }
  

}

