//
//  ViewController.swift
//  NameToFaces
//
//  Created by Mr.Kevin on 20/07/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
  
  // create an array that will contain Person object
  var people = [Person]()

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPhoto))
    
    // 3* we need to load the array back from disk when the app runs.
    let defaults = UserDefaults.standard
    
    // pull out the saved Data in the UserDefaults
    if let savedPeople = defaults.object(forKey: "people") as? Data {
      // decode the Data so they are an array of Person
      if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPeople) as? [Person] {
        // asign the decoded data to the people array
        people = decodedPeople
      }
    }
  }
  
  @objc func addNewPhoto() {
    // create an instance of the UIImagePickerController that will alow us to access the photo library
    let imagePicker = UIImagePickerController()
    
    // check if the camera source is available and if it is use it otherwise use the photoLibrary
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      imagePicker.sourceType = .camera
    } else {
      imagePicker.sourceType = .photoLibrary
    }
    
    // alows the user to crop the picture they select
    imagePicker.allowsEditing = true
    // asign the ViewController to be the delegate of the UIImagePickerController and conform to its delegates
    imagePicker.delegate = self
    // present the imagePicker
    present(imagePicker, animated: true)
    
  }
  
  // Method used to find the Documents directory URL
  func getDocumentDirectory() -> URL {
    // asks for the documents directory, and we want the path to be relative to the user's home directory.
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return path[0]
  }
  
  // 1* a method that will load and save the people array
  func save() {
    // converts our people array into Data object
    if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false) {
      // create an instance of UserDefaults
      let defaults = UserDefaults.standard
      // save our Data with a people key
      defaults.set(savedData, forKey: "people")
    }
  }
  
}


// MARK: - Extension that will contain UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  /// A method that will return us the image selected by the user
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    // 1- Extract the image
    guard let image = info[.editedImage] as? UIImage else { return }
    // 2- Generate an unique filename
    let imageName = UUID().uuidString
    // 3- Create the image path
    let imagePath = getDocumentDirectory().appendingPathComponent(imageName)
    // 4- Convert the image to Data and write that data to disc
    if let jpegData = image.jpegData(compressionQuality: 0.8) {
      try? jpegData.write(to: imagePath)
    }
    
    // create an Person instance
    let person = Person(name: "Unknown", image: imageName)
    // add it to the people array
    people.append(person)
    // 2* save our data state
    self.save()
    // reload the data in the collection view
    collectionView.reloadData()
    
    // 5- Dismiss the viewcontroller
    dismiss(animated: true)
    
  }
}


// MARK: - Extension that will contain the CollectionView DataSource and Delegate methods
extension ViewController {
  /// Data Source Methods
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return people.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    // create the cell
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
      // will cause a crash, since the PesonCell wasn not created correctly
      fatalError("Unable to dequeue PersonCell")
    }
    
    // get the person from the people array at the correct position
    let person = people[indexPath.item]
    // asing the cell name to be the person name
    cell.name.text = person.name
    // get the image path form the person image filename
    let imagePath = getDocumentDirectory().appendingPathComponent(person.image)
    // create an UIImage from the path asign it to the cell image
    cell.imageView.image = UIImage(contentsOfFile: imagePath.path)
    
    // design the cell
    cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
    cell.imageView.layer.borderWidth = 2
    cell.imageView.layer.cornerRadius = 3
    cell.layer.cornerRadius = 7
    
    // we have the PersonCell so return it
    return cell
  }
  
  /// Delegate Method
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let ac = UIAlertController(title: "Do you want to Rename or Delete the photo ?", message: nil, preferredStyle: .alert)
    
    ac.addAction(UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
      self?.renamePhotoAlert(indexPath: indexPath)
    })
    
    ac.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
      self?.people.remove(at: indexPath.item)
      // 2* save our data state
      self?.save()
      self?.collectionView.reloadData()
    })
    
    present(ac, animated: true)
  }
  
  func renamePhotoAlert(indexPath: IndexPath) {
    // get the Person object from the cell that was tapped
    let person = people[indexPath.item]
    // show an alert that will ask the users to rename the cell
    let ac = UIAlertController(title: "Rename the photo: ", message: nil, preferredStyle: .alert)
    // add a textfield to the alert
    ac.addTextField()
    // add actions to the alert
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
      // get the text that we asign to the alert text field
      guard let newName = ac?.textFields?[0].text else { return }
      // update the person name with the newName
      person.name = newName
      // 2* save our data state
      self?.save()
      // reload the collection to show the changes
      self?.collectionView.reloadData()
    })
    // present the alert to the user
    present(ac, animated: true)
  }
}

