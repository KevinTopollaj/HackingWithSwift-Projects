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
    // make the title in the Detail to look normal
    navigationItem.largeTitleDisplayMode = .never
    // set a title for the navigation controller in each image
    title = "Picture \(selectedPicturePosition) of \(totalNumberOfPictures)"
    
    /// *** 1- add a Navigation Bar Button
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

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
  
  /// *** 2- create the method that will be triggered by the Navigation Bar Button
  @objc func shareTapped() {
    // get the image from the imageView in jpegData that has a Data type
    guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
      print("No image found")
      return
    }
    
    // create an instance of UIActivityViewController, which is the iOS method of sharing content with other apps and services.
    let activityVC = UIActivityViewController(activityItems: [image, selectedImage ?? "No selected image found"], applicationActivities: [])
    // tells iOS to anchor the activity view controller to the right bar button item (our share button), but this only has an effect on iPad – on iPhone it's ignored.
    activityVC.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    // present the UIActivityViewController
    present(activityVC, animated: true)
  }
  
}
