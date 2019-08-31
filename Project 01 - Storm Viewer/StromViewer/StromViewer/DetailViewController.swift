//
//  DetailViewController.swift
//  StromViewer
//
//  Created by Mr.Kevin on 05/07/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  
  // create an outlet for the image view
  @IBOutlet var imageView: UIImageView!
  // a property that will hold the name of the image that will be loaded
  var selectedImage: String?
  var totalNumberOfPictures = 0
  var selectedPicturePosition = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // set a title for the navigation controller in each image
    title = "Picture \(selectedPicturePosition) of \(totalNumberOfPictures)"
    // make the title in the Detail to look normal
    navigationItem.largeTitleDisplayMode = .never

    // make sure that selectedImage is not nil otherwise cause a crash.
    assert(selectedImage != nil, "selected image has no image")
    
    // if the property has a value use it as the image name to load the image in the ImageView
    if let imageToLoad = selectedImage {
      imageView.image = UIImage(named: imageToLoad)
    }
  }
  
  // hide the bar on tap when the view will appear
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.hidesBarsOnTap = true
  }
  
  // show the bar when the view will disapper
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.hidesBarsOnTap = false
  }
  
}
