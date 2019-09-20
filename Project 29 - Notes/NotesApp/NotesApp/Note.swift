//
//  Note.swift
//  NotesApp
//
//  Created by Mr.Kevin on 10/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import Foundation
import UIKit

class Note: Codable {
  var content: String
  var date: String
  
  init(content: String, date: String) {
    self.content = content
    self.date = date
  }
}
