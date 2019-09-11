//
//  ViewController.swift
//  Insafilter
//
//  Created by Mr.Kevin on 24/07/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController {
  /// Outlets
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var intensitySlider: UISlider!
  
  /// Properties
  // will contain the image that the user selected from the photo library
  var currentImage: UIImage!
  // is the Core Image component that handles rendering,
  // create it here and use it in our app, because creating a context is computationally expensive
  var context: CIContext!
  // will store whatever filter the user has activated
  var currentFilter: CIFilter!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    title = "INSTAFILTER"
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
    
    // initialize context and currentFilter
    context = CIContext()
    currentFilter = CIFilter(name: "CISepiaTone")
  }
  
  /// Method that will give us acess to the photo library to select an image
  @objc func importPicture() {
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.delegate = self
    present(picker, animated: true)
  }

  /// Actions
  @IBAction func changeFilter(_ sender: UIButton) {
    let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
    ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
    ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
    ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
    ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
    ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
    ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
    ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    
    // code to use the actionSheet in iPad
    if let popoverController = ac.popoverPresentationController {
      // make our button as a source for our popover presentation controller
      popoverController.sourceView = sender
      popoverController.sourceRect = sender.bounds
    }
    
    present(ac, animated: true)
    
  }
  
  // This method should update our currentFilter property with the filter that was chosen, set the kCIInputImageKey key again because we just changed the filter, then call applyProcessing().
  func setFilter(_ action: UIAlertAction) {
    // make sure we have a valid image before continueing
    guard currentImage != nil else { return }
    // read the actionSheet action title
    guard let actionTitle = action.title else { return }
    // create the filter with the actionTitle
    currentFilter = CIFilter(name: actionTitle)
    // create a CIImage from the currentImage
    let beginImage = CIImage(image: currentImage)
    // set the created CIImage inside the currentFilter
    currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
    //
    DispatchQueue.main.async { [weak self] in
      self?.title = "Using: \(actionTitle) filter."
    }
    // apply the filter
    applyProcessing()
  }
  
  @IBAction func save(_ sender: Any) {
    
    if imageView.image == nil {
      let ac = UIAlertController(title: "Please select an image first.", message: "You must select and filter an image before saveing.", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK", style: .default))
      present(ac, animated: true)
    }
    
    // get the filtered image from the imageView
    guard let image = imageView.image else { return }
    
    // call a method that will save our filtered image in the photo library
    UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
  }
  
  // will check if we got back an error from trying to save the filtered image to the photo library
  @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    if let error = error {
      // we got back an error if user denied to give us access to save in photo album
      let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK", style: .default))
      present(ac, animated: true)
    } else {
      // filtered image saved successfully
      let ac = UIAlertController(title: "Saved!", message: "Your filtered image was saved to your photos.", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK", style: .default))
      present(ac, animated: true)
    }
  }
  
  // action that will be triggerd when we start to move the slider up or down
  @IBAction func intensityChanged(_ sender: Any) {
    // a method that will do the CoreImage manipulation
    applyProcessing()
  }
  
  // Method that does the CoreImage manipulation and assigns the filter to the image
  func applyProcessing() {
    // read the output image from the currentFilter
    guard let outputImage = currentFilter.outputImage else { return }
    
    // Each filter has an inputKeys property that returns an array of all the keys it can support. We're going to use this array in conjunction with the contains() method to see if each of our input keys exist, and, if it does, use it.
    let inputKeys = currentFilter.inputKeys
    if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensitySlider.value, forKey: kCIInputIntensityKey) }
    if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(intensitySlider.value * 200, forKey: kCIInputRadiusKey) }
    if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(intensitySlider.value * 10, forKey: kCIInputScaleKey) }
    if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey) }
    
    // creates a new data type called CGImage from the output image of the current filter.
    // and specify which part of the image we want to render, by using image.extent means "all of it."
    if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
      // creates a new UIImage from the CGImage
      let processedImage = UIImage(cgImage: cgImage)
      // asign the processedImage to our imageView image
      imageView.image = processedImage
    }
  }
  
}


// MARK: - Extension to conform to UIImagePickerControllerDelegate, UINavigationControllerDelegate protocols.
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    // get the edited image
    guard let image = info[.editedImage] as? UIImage else { return }
    dismiss(animated: true)
    // asign the image to the currentImage property
    currentImage = image
    
    // initialize a CIImage with our currentImage
    let beginImage = CIImage(image: currentImage)
    // add it to the current filter
    currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
    
    // a method that will do the CoreImage manipulation
    applyProcessing()
  }
}

