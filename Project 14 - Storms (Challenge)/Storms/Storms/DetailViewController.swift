//
//  DetailViewController.swift
//  Storms
//
//  Created by Mr.Kevin on 08/09/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  
  @IBOutlet var imageView: UIImageView!
  var selectedImage: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // make the title in the Detail to look normal
    navigationItem.largeTitleDisplayMode = .never
    // set a title for the navigation controller in each image
    title = selectedImage
    // if the property has a value use it as the image name to load the image in the ImageView
    if let imageToLoad = selectedImage {
      imageView.image = UIImage(named: imageToLoad)
    }
  }
  
  
}
