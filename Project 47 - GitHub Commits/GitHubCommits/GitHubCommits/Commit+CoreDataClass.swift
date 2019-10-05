//
//  Commit+CoreDataClass.swift
//  GitHubCommits
//
//  Created by Mr.Kevin on 30/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Commit)
public class Commit: NSManagedObject {
  public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
    super.init(entity: entity, insertInto: context)
    print("Init called!")
  }
}
