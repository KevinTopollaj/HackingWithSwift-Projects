//
//  ViewController.swift
//  CapitalCities
//
//  Created by Mr.Kevin on 28/07/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

  @IBOutlet var mapView: MKMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Capital Cities"

    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(changeMapType))
    
    createCapitalCityAnotation()
  }
  
  @objc func changeMapType() {
    let ac = UIAlertController(title: "Change the view of the map:", message: nil, preferredStyle: .actionSheet)
    ac.addAction(UIAlertAction(title: "Standard", style: .default) { [weak self] (_) in
      self?.mapView.mapType = .standard
    })
    ac.addAction(UIAlertAction(title: "Satellite", style: .default) { [weak self] (_) in
      self?.mapView.mapType = .satellite
    })
    ac.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: { [weak self] (_) in
      self?.mapView.mapType = .hybrid
    }))
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(ac, animated: true)
  }

  func createCapitalCityAnotation() {
    // Create Capital City instances
    let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
    let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
    let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
    let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
    let washington = Capital(title: "Washington,_D.C", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
    
    // Add Capital Cities as Annotaition in mapView
    mapView.addAnnotations([london, oslo, paris, rome, washington])
  }
  
  
  /// A delegate method that will return an AnnotationView
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    // 1. If the annotation isn't from a capital city, it must return nil so iOS uses a default view.
    guard annotation is Capital else { return nil }
    
     // 2. Define a reuse identifier. This is a string that will be used to ensure we reuse annotation views as much as possible.
    let identifier = "Capital"
  
    // 3. dequeue an annotation view from the map view's pool of unused views.
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
    
    if annotationView == nil {
  
      // 4. If it isn't able to find a reusable view, create a new one using MKPinAnnotationView and sets its canShowCallout property to true. This triggers the popup with the city name.
      annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      annotationView?.canShowCallout = true
      // set the pin color
      annotationView?.pinTintColor = .black

      // 5. Create a new UIButton using the built-in .detailDisclosure type. This is a small blue "i" symbol with a circle around it.
      let btn = UIButton(type: .detailDisclosure)
      annotationView?.rightCalloutAccessoryView = btn
    } else {
  
      // 6. If it can reuse a view, update that view to use a different annotation.
      annotationView?.annotation = annotation
    }

    return annotationView
  }
  
  /// A delegate method that will be triggered when the accessoryView is selected in the annotationView in our case is the button that will give us more information about the capital city
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    // get an instance of the Capital
    guard let capital = view.annotation as? Capital else { return }
    
    // create two variables that will contain the Capital title and info
//    let placeName = capital.title
//    let placeInfo = capital.info
    
    // create an alert to display those information
//    let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
//    ac.addAction(UIAlertAction(title: "OK", style: .default))
//    present(ac, animated: true)
    
    let detailVC = DetailViewController()
    detailVC.cityName = capital.title
    navigationController?.pushViewController(detailVC, animated: true)
  }

}

