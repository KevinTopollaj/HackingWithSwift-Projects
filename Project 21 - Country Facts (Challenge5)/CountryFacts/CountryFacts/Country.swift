//
//  Country.swift
//  CountryFacts
//
//  Created by Mr.Kevin on 14/09/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import Foundation

struct Country: Codable {
  var name: String?
  var capital: String?
  var population: Int?
  var currencies: [Currency]?
  var region: String?
  var subregion: String?
  var demonym: String?
  var nativeName: String?
}

struct Currency: Codable {
  var code: String?
  var name: String?
  var symbol: String?
}
