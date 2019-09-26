//
//  ViewController.swift
//  MemeGeneration
//
//  Created by Mr.Kevin on 17/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit

enum TextPosition {
  case top, bottom
}

class ViewController: UIViewController {

  @IBOutlet var imageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(selectImage))
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareMeme))
    
    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let topText = UIBarButtonItem(title: "Top Text", style: .plain, target: self, action: #selector(addTopText))
    let bottomText = UIBarButtonItem(title: "Bottom Text", style: .plain, target: self, action: #selector(addBottomText))
    
    toolbarItems = [spacer, topText, bottomText]
    navigationController?.isToolbarHidden = false
  }

  // will open the image picker and select an image
  @objc func selectImage() {
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.allowsEditing = true
    picker.sourceType = .photoLibrary
    present(picker, animated: true)
  }
  
  // will share a meme image
  @objc func shareMeme() {
    guard let image = imageView.image else { return }
    let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: [])
    activityVC.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    present(activityVC, animated: true)
  }

  @objc func addTopText() {
    presentText(on: .top)
  }
  
  @objc func addBottomText() {
    presentText(on: .bottom)
  }
  
  func presentText(on position: TextPosition) {
    if imageView.image != nil {
      let ac = UIAlertController(title: "Caption:", message: nil, preferredStyle: .alert)
      ac.addTextField()
      
      ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] (action) in
        guard let text = ac.textFields?[0].text else { return }
        
        self?.displayRendered(text: text, onPosition: position)
      }))
      ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
      present(ac, animated: true)
      
    } else {
      let ac = UIAlertController(title: "Please select an image first!", message: nil, preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK", style: .default))
      present(ac, animated: true)
    }
  }
  
  func displayRendered(text: String, onPosition: TextPosition){
    
    guard let imageSize = imageView.image?.size else { return }
    // Create the renderer object
    let renderer = UIGraphicsImageRenderer(size: imageSize)
    
    // Create and render an image form the context object
    let image = renderer.image { context in
      // Draw the initial image
      imageView.image?.draw(at: CGPoint(x: 0, y: 0))
      
      // Set the text to be centered
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.alignment = .center
      
      // Set a text shadow
      let shadow = NSShadow()
      shadow.shadowColor = UIColor.white
      shadow.shadowOffset = CGSize(width: 3, height: 4)
      
      // Create a dictionary of attributes
      let attributes: [NSAttributedString.Key: Any] = [
        .backgroundColor: UIColor.white,
        .paragraphStyle: paragraphStyle,
        .font: UIFont(name: "Arial", size: 60)!,
        .shadow: shadow
      ]
      
      // Create the attributed string
      let attributedString = NSAttributedString(string: text, attributes: attributes)
      
      // get the image width and height
      guard let imageWidth = imageView.image?.size.width else { return }
      guard let imageHeight = imageView.image?.size.height else { return }
      
      // position the attributed string inside the image for every case
      if onPosition == .top {
        attributedString.draw(with: CGRect(x: 0, y: 10, width: imageWidth, height: imageHeight), options: .usesLineFragmentOrigin, context: nil)
      } else if onPosition == .bottom {
        attributedString.draw(with: CGRect(x: 0, y: imageHeight - 80, width: imageWidth, height: imageHeight), options: .usesLineFragmentOrigin, context: nil)
      }
      
    }
    
    // Display the rendered image with the attributed string
    imageView.image = image
  }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.editedImage] as? UIImage else { return }
    
    imageView.image = image
    dismiss(animated: true)
  }
}

