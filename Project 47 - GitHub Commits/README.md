# GitHub Commits

#### GitHub Commits is a project where I learned about Core Data by building an app to fetch and store GitHub commits for Swift. Core Data is Apple's object graph and persistence framework, which reads, writes and queries collections of related objects while also being able to save them to disk. 
There are four steps to implementing Core Data in your app :
1. Designing a Core Data model.
  ( A data model is a description of the data you want Core Data to store, you define entities (like classes) and give them attributes (like properties). Core Data than describes how its entities relate to other entities, as well as adding rules for validation and uniqueness. )
2. Adding the base Core Data functionality to our app so we can load the model we just defined and save any changes we make.
  ( We need to load the model, create a real working database from it, load that database, then prepare what’s called a “managed object context” –
  an environment where we can create, read, update, and delete Core Data objects entirely in memory, before writing them back to the database. )
3. Create objects inside Core Data so we can fetch and store data from GitHub.
  ( By generating the core data files +CoreDataClass.swift and +CoreDataProperties )
4. We need to be able to load and use all those objects we just saved into CoreData, and display them into our UI.


## Main Points:

* Core Data Framework
* NSFetchRequest ( class that performs a query on your data, and returns a list of objects that match. )
* NSManagedObject
* NSPredicate
* NSSortDescriptor
* NSFetchedResultsController
* UIViewController
* UITableViewController
* UIView
* ISO8601DateFormatter (convert Date objects to and from strings)
* Codable protocol
* Entity
* Attributes
* SQLite database
* DispatchQueue


## App Demo:

<img src="demo.gif?raw=true" width="325px" height="650">
