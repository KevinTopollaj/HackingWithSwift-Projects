//
//  DetailViewController.swift
//  PhotoOfThings
//
//  Created by Mr.Kevin on 24/07/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
  
  @IBOutlet var imageView: UIImageView!
  var selectedImage: UIImage?
  var selectedImageTitle: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never
    title = selectedImageTitle
    
    if let image = selectedImage {
      imageView.image = image
    }
  }
  
}
