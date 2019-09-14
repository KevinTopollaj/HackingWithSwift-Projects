//
//  ViewController.swift
//  CountryFacts
//
//  Created by Mr.Kevin on 14/09/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  /// Properties
  public var identifier = "CountryCell"
  var countries = [Country]()
  
  /// TableView
  lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(CountryCell.self, forCellReuseIdentifier: CountryCell.identifier)
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
    getCountryData()
    
  }
  
  fileprivate func getCountryData() {
    let urlString = "https://restcountries.eu/rest/v2/all?fields=name;capital;region;subregion;population;demonym;nativeName;currencies"
    
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      if let url = URL(string: urlString) {
        if let data = try? Data(contentsOf: url) {
          self?.parse(json: data)
          return
        }
      }
      print("problem loading from the url")
    }
  }
  
  func parse(json: Data) {
    let decoder = JSONDecoder()
    if let decodedCountries = try? decoder.decode([Country].self, from: json) {
      
      countries = decodedCountries
      
      DispatchQueue.main.async { [weak self] in
        self?.tableView.reloadData()
      }
    }
  }
  
  func setUpNavigation() {
    title = "Countries"
    navigationController?.navigationBar.prefersLargeTitles = true
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

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return countries.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryCell.identifier, for: indexPath) as? CountryCell else { fatalError("Cell not found") }
    let country = countries[indexPath.row]
    cell.countryLabel.text = country.name
    cell.regionLabel.text = country.region
    cell.accessoryType = .disclosureIndicator
    return cell
  }
}

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let countryDetailVC = CountryDetailViewController()
    countryDetailVC.country = countries[indexPath.row]
    navigationController?.pushViewController(countryDetailVC, animated: true)
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

