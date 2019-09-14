//
//  CountryDetailViewController.swift
//  CountryFacts
//
//  Created by Mr.Kevin on 14/09/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit

class CountryDetailViewController: UIViewController {
  
  var identifier = "Cell"
  var country: Country!
  
  var countryDetail = [String]()
  
  var name: String!
  var capital: String!
  var region: String!
  var population: String!
  var demonym: String!
  var nativeName: String!
  var subregion: String!
  var currencieCode: String!
  var currencieName: String!
  var currencieSymbol: String!
  
  /// TableView
  lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
    tableView.estimatedRowHeight = CountryCell.Metrics.height
    tableView.rowHeight = CountryCell.Metrics.height
    tableView.dataSource = self
    tableView.delegate = self
    return tableView
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpNavigation()
    setUpTableView()
    countryDetailData()
    
  }
  
  fileprivate func countryDetailData() {
    let currencyData = country.flatMap { $0.currencies } ?? []
    
    name = "Name: \(country.name ?? "----")"
    capital = "Capital: \(country.capital ?? "----")"
    region = "Region: \(country.region ?? "----")"
    subregion = "Subregion: \(country.subregion ?? "----")"
    population = "Population: \(country.population ?? 000)"
    demonym = "Demonym: \(country.demonym ?? "----")"
    nativeName = "Native Name: \(country.nativeName ?? "----")"
    
    for currency in currencyData {
      currencieCode = "Currency Code: \(currency.code ?? "----")"
      currencieName = "Currency Name: \(currency.name ?? "----")"
      currencieSymbol = "Currency Symbol: \(currency.symbol ?? "----")"
    }
    
    countryDetail = [name, capital, region, subregion, population, demonym, nativeName, currencieCode, currencieName, currencieSymbol]
  }
  
  
  func setUpNavigation() {
    title = country.name
    navigationItem.largeTitleDisplayMode = .never
    view.backgroundColor = .white
  }
  
  func setUpTableView() {
    view.addSubview(tableView)
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
      ])
  }
  
}

extension CountryDetailViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return countryDetail.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    cell.textLabel?.text = countryDetail[indexPath.row]
//    cell.textLabel?.numberOfLines = 0
    cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
    return cell
  }
}

extension CountryDetailViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
