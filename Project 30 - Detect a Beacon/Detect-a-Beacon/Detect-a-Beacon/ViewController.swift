//
//  ViewController.swift
//  Detect-a-Beacon
//
//  Created by Mr.Kevin on 10/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
  
  /// Outlets
  @IBOutlet var distanceReading: UILabel!
  
  /// Properties
  
  // this is the Core Location class that lets us configure how we want to be notified about location, and will also deliver location updates to us.
  var locationManager: CLLocationManager?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 1. initialize CLLocationManager object
    locationManager = CLLocationManager()
    // 2. Make the ViewController to be the delegate of CLLocationManager
    locationManager?.delegate = self
    // 3. Request authorization
    locationManager?.requestAlwaysAuthorization()
    
    // in case we want to use the user location only when the user is using the app
//    locationManager?.requestWhenInUseAuthorization()
    
    view.backgroundColor = .gray
    
  }
  
  // delegate method
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedAlways {
      if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
        if CLLocationManager.isRangingAvailable() {
          startScanning()
        }
      }
    }
  }
  
  // Will start to scann for a iBeacon
  func startScanning() {
    // convert a string into a UUID
    let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
    // create a beacon
    let beaconRegion = CLBeaconRegion(proximityUUID: uuid,major: 123, minor: 456, identifier: "MyBeacon")
    // monitor for the existence of the region
    locationManager?.startMonitoring(for: beaconRegion)
    // starts measuring the distance between us and the beacon.
    locationManager?.startRangingBeacons(in: beaconRegion)
  }
  
  // a method that is going to change the label text and view background color to reflect proximity to the beacon we're scanning for.
  func update(distance: CLProximity) {
    UIView.animate(withDuration: 1) {
      switch distance {
      case .far:
        self.view.backgroundColor = .blue
        self.distanceReading.text = "FAR"
      case .near:
        self.view.backgroundColor = .orange
        self.distanceReading.text = "NEAR"
      case .immediate:
        self.view.backgroundColor = .red
        self.distanceReading.text = "RIGHT HERE"
      default:
        self.view.backgroundColor = .gray
        self.distanceReading.text = "UNKNOWN"
      }
    }
  }
  
  // a delegate method that will find beacons in the range
  func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
    if let beacon = beacons.first {
      update(distance: beacon.proximity)
    } else {
      update(distance: .unknown)
    }
  }

}

