//
//  CountryCell.swift
//  CountryFacts
//
//  Created by Mr.Kevin on 14/09/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import Foundation
import UIKit

final class CountryCell: UITableViewCell {
  enum Metrics {
    static let height: CGFloat = 65
  }
  
  static let identifier = String(describing: CountryCell.self)
  
  lazy var countryLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.preferredFont(forTextStyle: .title2)
    return label
  }()
  
  lazy var regionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = NSTextAlignment.right
    label.font = UIFont.preferredFont(forTextStyle: .subheadline)
    return label
  }()
  
  lazy var cellStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [countryLabel, regionLabel])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.distribution = .fillEqually
    stackView.spacing = 0
    stackView.alignment = .center
    return stackView
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setup() {
    contentView.addSubview(cellStackView)
    
    NSLayoutConstraint.activate([
      cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
      cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      cellStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
      ])
  }
}
