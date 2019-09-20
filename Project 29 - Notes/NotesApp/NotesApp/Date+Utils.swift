//
//  Date+Utils.swift
//  NotesApp
//
//  Created by Mr.Kevin on 10/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import Foundation

extension Date {
  
  static func getCurrentDate() -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy" //  HH:mm:ss
    return dateFormatter.string(from: Date())
    
  }
}
