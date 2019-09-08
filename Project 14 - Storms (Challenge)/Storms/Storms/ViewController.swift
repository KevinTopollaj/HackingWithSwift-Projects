//
//  ViewController.swift
//  Storms
//
//  Created by Mr.Kevin on 21/07/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
  
  var storms = [String]()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // set a title for the navigation controller
    title = "Storms"
    // use the large title
    navigationController?.navigationBar.prefersLargeTitles = true
    
    // Get images on the background
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      let fileMenager = FileManager.default
      let path = Bundle.main.resourcePath!
      let items = try! fileMenager.contentsOfDirectory(atPath: path)
      
      for item in items {
        if item.hasPrefix("nssl"){
          self?.storms.append(item)
        }
      }
      
      DispatchQueue.main.async {
        self?.storms = self?.storms.sorted() ?? []
        self?.collectionView.reloadData()
      }
    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return storms.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Storm", for: indexPath) as? StormCell else {
      fatalError("Can't find the Storm cell")
    }
    let storm = storms[indexPath.item]
    cell.stormImageName.text = storm
    cell.stormImage.image = UIImage(named: storm)
    
    cell.stormImage.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
    cell.stormImage.layer.borderWidth = 2
    cell.stormImage.layer.cornerRadius = 3
    cell.layer.cornerRadius = 7
    
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    let cell = collectionView.cellForItem(at: indexPath) as! StormCell
    let storm = storms[indexPath.item]
    let detailVC = storyboard?.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
    detailVC.selectedImage = storm
//    detailVC.selectedImage = cell.stormImageName.text
    navigationController?.pushViewController(detailVC, animated: true)
    
  }

}

