//
//  Person.swift
//  NameToFaces
//
//  Created by Mr.Kevin on 20/07/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import  UIKit

// A class to hold data for our app.
// NSObject is what's called a universal base class for all Cocoa Touch classes. That means all UIKit classes ultimately come from NSObject, including all of UIKit.
class Person: NSObject, NSCoding {
  var name: String
  var image: String
  
  init(name: String, image: String) {
    self.name = name
    self.image = image
  }
  
  /// Required Methods since we are using the NSCoding protocol
  
  // will encode(write) data with a specific key
  func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: "name")
    aCoder.encode(image, forKey: "image")
  }
  
  // will decode(read) the data using the encode key
  required init?(coder aDecoder: NSCoder) {
    name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
    image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
  }
  
}
