//
//  NoteCell.swift
//  NotesApp
//
//  Created by Mr.Kevin on 07/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import Foundation
import UIKit

final class NoteCell: UITableViewCell {
  enum Metrics {
    static let height: CGFloat = 60
  }
  
  static let identifier = String(describing: NoteCell.self)
  
  lazy var noteLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.preferredFont(forTextStyle: .title3)
    return label
  }()
  
  lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = NSTextAlignment.right
    label.font = UIFont.preferredFont(forTextStyle: .subheadline)
    return label
  }()
  
  lazy var cellStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [noteLabel, dateLabel])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.alignment = .leading
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
