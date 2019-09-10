//
//  ViewController.swift
//  PhotoOfThings
//
//  Created by Mr.Kevin on 24/07/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
  
  var places = [Place]()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Your Photos"
    navigationController?.navigationBar.prefersLargeTitles = true
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhoto))
    
    // 3* load the data back from disk when the app runs
    let defaults = UserDefaults.standard
    if let savedPlaces = defaults.object(forKey: "places") as? Data {
      let decoder = JSONDecoder()
      do {
        places = try decoder.decode([Place].self, from: savedPlaces)
      } catch {
        print("Failed to load data!")
      }
    }
    
  }
  
  @objc func addPhoto() {
    let imagePicker = UIImagePickerController()
    
    if UIImagePickerController.isSourceTypeAvailable(.camera){
      imagePicker.sourceType = .camera
    } else {
      imagePicker.sourceType = .photoLibrary
    }
    
    imagePicker.allowsEditing = true
    imagePicker.delegate = self
    present(imagePicker, animated: true)
  }
  
  func getDocumentDirectory() -> URL {
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return path[0]
  }
  
  // 1* a method that will save the places in form of Data in UserDefaults
  func save() {
    let encoder = JSONEncoder()
    if let savedData = try? encoder.encode(places) {
      let userDefaults = UserDefaults.standard
      userDefaults.set(savedData, forKey: "places")
    } else {
      print("Failed to save places!")
    }
  }

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    guard let image = info[.editedImage] as? UIImage else { return }
    let imageName = UUID().uuidString
    let imagePath = getDocumentDirectory().appendingPathComponent(imageName)
    if let jpegData = image.jpegData(compressionQuality: 0.8) {
      try? jpegData.write(to: imagePath)
    }
    
    let place = Place(name: "Set your title", image: imageName)
    places.append(place)
    // 2* save the state
    self.save()
    tableView.reloadData()
    
    dismiss(animated: true)
  }
}

// MARK: - Extension that will contain the TableView DataSource and Delegate methods
extension ViewController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return places.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
    let place = places[indexPath.row]
    cell.textLabel?.text = place.name
    
    let imagePath = getDocumentDirectory().appendingPathComponent(place.image)
    cell.imageView?.image = UIImage(contentsOfFile: imagePath.path)
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let alertController = UIAlertController(title: "Please select a specific action:", message: nil, preferredStyle: .actionSheet)
    
    alertController.addAction(UIAlertAction(title: "Rename", style: .default, handler: { [weak self] _ in
      self?.renamePhotAlert(indexPath: indexPath)
    }))
    
    alertController.addAction(UIAlertAction(title: "Watch full image", style: .default) { [weak self] _ in
      if let detailVC = self?.storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
        let place = self?.places[indexPath.row]
        let imagePath = self?.getDocumentDirectory().appendingPathComponent(place?.image ?? "")
        detailVC.selectedImage = UIImage(contentsOfFile: imagePath?.path ?? "")
        detailVC.selectedImageTitle = place?.name
        self?.navigationController?.pushViewController(detailVC, animated: true)
      }
    })
    
    alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
      self?.places.remove(at: indexPath.row)
      // 2* save the state
      self?.save()
      self?.tableView.reloadData()
    }))
    
    present(alertController, animated: true)
  }
  
  func renamePhotAlert(indexPath: IndexPath) {
    let place = places[indexPath.row]
    let ac = UIAlertController(title: "Rename the photo: ", message: nil, preferredStyle: .alert)
    ac.addTextField()
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
      guard let newName = ac?.textFields?[0].text else { return }
      place.name = newName
      // 2* save the state
      self?.save()
      self?.tableView.reloadData()
    })
    present(ac, animated: true)
  }
  
}

