//
//  InterfaceController.swift
//  PsychicTester WatchKit Extension
//
//  Created by Mr.Kevin on 29/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {
  
  @IBOutlet var welcomeText: WKInterfaceLabel!
  @IBOutlet var hideButton: WKInterfaceButton!
  
  @IBAction func hideWelcomeText() {
    welcomeText.setHidden(true)
    hideButton.setHidden(true)
  }
  
  func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
    WKInterfaceDevice().play(.click)
  }
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    
    // Configure interface objects here.
  }
  
  override func willActivate() {
    super.willActivate()
    
    if WCSession.isSupported() {
      let session = WCSession.default
      session.delegate = self
      session.activate()
    }
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }
  
  func session(_ session: WCSession, activationDidCompleteWith
    activationState: WCSessionActivationState, error: Error?) {
  }
  
}
