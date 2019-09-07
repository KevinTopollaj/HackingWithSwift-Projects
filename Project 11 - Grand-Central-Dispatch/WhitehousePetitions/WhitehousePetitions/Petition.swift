//
//  Petition.swift
//  WhitehousePetitions
//
//  Created by Mr.Kevin on 14/07/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import Foundation

struct Petition: Codable {
  var title: String
  var body: String
  var signatureCount: Int
}
