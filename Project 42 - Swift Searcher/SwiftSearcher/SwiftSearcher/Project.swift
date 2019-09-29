//
//  Project.swift
//  SwiftSearcher
//
//  Created by Mr.Kevin on 25/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import Foundation

class Project: Codable {
  var title: String
  var subtitle: String
  
  init(title: String, subtitle: String) {
    self.title = title
    self.subtitle = subtitle
  }
}
