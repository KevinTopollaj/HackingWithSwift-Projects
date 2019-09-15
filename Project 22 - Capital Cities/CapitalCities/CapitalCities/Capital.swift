//
//  Capital.swift
//  CapitalCities
//
//  Created by Mr.Kevin on 28/07/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import MapKit
import UIKit

// With map annotations, you can't use structs, and you must inherit from NSObject because it needs to be interactive with Apple's Objective-C code.

/// A class that will create an Annotation for each Capital city
class Capital: NSObject, MKAnnotation {
  
  var title: String?
  var coordinate: CLLocationCoordinate2D
  var info: String
  
  init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
    self.title = title
    self.coordinate = coordinate
    self.info = info
  }
}
