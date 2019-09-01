//
//  DetailsViewController.swift
//  WorldFlags
//
//  Created by Mr.Kevin on 07/07/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
  
  @IBOutlet var flagImageView: UIImageView!
  var selectedFlag: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = selectedFlag?.uppercased()
    navigationItem.largeTitleDisplayMode = .never
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(savePhoto))
    
    if let flag = selectedFlag {
      flagImageView.image = UIImage(named: flag)
    }
  }
  
  @objc func savePhoto() {
    guard let image = flagImageView.image?.jpegData(compressionQuality: 0.8),
          let imageName = selectedFlag else {
      print("No flag image found!")
      return
    }
    
    let activityVC = UIActivityViewController(activityItems: [image, imageName], applicationActivities: [])
    activityVC.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    present(activityVC, animated: true)
  }
}
