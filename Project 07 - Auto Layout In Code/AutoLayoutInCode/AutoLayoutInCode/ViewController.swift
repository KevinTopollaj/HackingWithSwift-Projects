//
//  ViewController.swift
//  AutoLayoutInCode
//
//  Created by Mr.Kevin on 13/07/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Create 5 different labels
    let label1 = UILabel()
    label1.translatesAutoresizingMaskIntoConstraints = false
    label1.backgroundColor = .red
    label1.text = "THESE"
    label1.sizeToFit()
    
    let label2 = UILabel()
    label2.translatesAutoresizingMaskIntoConstraints = false
    label2.backgroundColor = .cyan
    label2.text = "ARE"
    label2.sizeToFit()
    
    let label3 = UILabel()
    label3.translatesAutoresizingMaskIntoConstraints = false
    label3.backgroundColor = .yellow
    label3.text = "SOME"
    label3.sizeToFit()
    
    let label4 = UILabel()
    label4.translatesAutoresizingMaskIntoConstraints = false
    label4.backgroundColor = .green
    label4.text = "AWESOME"
    label4.sizeToFit()
    
    let label5 = UILabel()
    label5.translatesAutoresizingMaskIntoConstraints = false
    label5.backgroundColor = .orange
    label5.text = "LABELS"
    label5.sizeToFit()
    
    // add all the labels in to the view as subview's
    view.addSubview(label1)
    view.addSubview(label2)
    view.addSubview(label3)
    view.addSubview(label4)
    view.addSubview(label5)
    
    // Create a dictionary of the views we want to lay out. The reason this is needed for using a technique called Auto Layout Visual Format Language (VFL), which is kind of like a way of drawing the layout you want with a series of keyboard symbols.
    
//    let viewsDictionary = ["label1": label1, "label2": label2, "label3": label3, "label4": label4, "label5": label5]
    
    // add constraints
//    for label in viewsDictionary.keys {
//      view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(label)]|", options: [], metrics: nil, views: viewsDictionary))
//    }
    
    // The bottom of our last label must be at least 10 points away from the bottom of the view controller's view and we want each of the five labels to be 88 points high.
//    let metrics = ["labelHeight": 88]

//    view.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "V:|-==40-[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]-(>=10)-|", options: [], metrics: metrics, views: viewsDictionary))

    
    /// Auto Layout using Anchors (Best Choise)
    
    var previous: UILabel?
    
    for label in [label1, label2, label3, label4, label5] {
//      label.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
//      label.heightAnchor.constraint(equalToConstant: view.frame.height / 12).isActive = true
      label.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2, constant: -10).isActive = true
      label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
      label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    
      if let previous = previous {
        // we have a previous label – create a height constraint
        label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
      } else {
        // this is for the first label
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
      }
      // set the previous label to the current on for the next iteration
      previous = label
    }
  }
  
  
}

