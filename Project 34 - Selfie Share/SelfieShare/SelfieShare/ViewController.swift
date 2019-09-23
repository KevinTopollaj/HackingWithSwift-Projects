//
//  ViewController.swift
//  SelfieShare
//
//  Created by Mr.Kevin on 13/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import MultipeerConnectivity
import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  // property that will store all the images used by the app
  var images = [UIImage]()
  
  /// Properties used for mulitpeer connectivity
  // 2. MCPeerID identifies each user uniquely in a session.
  var peerID = MCPeerID(displayName: UIDevice.current.name)
  // 1. MCSession is the manager class that handles all multipeer connectivity for us.
  var mcSession: MCSession?
  // 3. MCAdvertiserAssistant is used when creating a session, telling others that we exist and handling invitations.
  var mcAdvertiserAssistant: MCAdvertiserAssistant?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Selfie Share"
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
    
    // start by initializing our MCSession so that we're able to make connections.
    mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
    mcSession?.delegate = self
    
  }
  
  // method that will open the photo library
  @objc func importPicture() {
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.delegate = self
    present(picker, animated: true)
  }
  
  // delegate method that will handle the selection of an image in the photo library
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    // get the selected image
    guard let image = info[.editedImage] as? UIImage else { return }
    // dismiss the imagePickerController
    dismiss(animated: true)
    // insert the selected image at the images array at position 0
    images.insert(image, at: 0)
    // reload the data in the collection view
    collectionView.reloadData()
    
    /// Logic that sends image data to peers.
    // 1. Check if we have an active session we can use.
    guard let mcSession = mcSession else { return }
    // 2. Check if there are any peers to send to.
    if mcSession.connectedPeers.count > 0 {
      // 3. Convert the new image to a Data object.
      if let imageData = image.pngData() {
        // 4. Send it to all peers, ensuring it gets delivered.
        do {
          try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
        } catch {
          // 5. Show an error message if there's a problem.
          let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
          ac.addAction(UIAlertAction(title: "OK", style: .default))
          present(ac, animated: true)
        }
      }
    }
    
  }
  
  @objc func showConnectionPrompt() {
    let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Host a Session", style: .default, handler: startHosting))
    ac.addAction(UIAlertAction(title: "Join a Session", style: .default, handler: joinSession))
    ac.addAction(UIAlertAction(title: "Send Message", style: .default, handler: sendMessage))
    ac.addAction(UIAlertAction(title: "Connected Peers", style: .default, handler: showConnectedPeers))
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(ac, animated: true)
  }
  
  // 'service type' is used by both MCAdvertiserAssistant and MCBrowserViewController to make sure your users only see other users of the same app. They both also want a reference to your MCSession instance so they can take care of connections for you.
  func startHosting(action: UIAlertAction) {
    guard let mcSession = mcSession else { return }
    mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
    mcAdvertiserAssistant?.start()
  }
  
  func joinSession(action: UIAlertAction) {
    guard let mcSession = mcSession else { return }
    // 4. MCBrowserViewController is used when looking for sessions, showing users who is nearby and letting them join.
    let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
    mcBrowser.delegate = self
    present(mcBrowser, animated: true)
  }
  
  func sendMessage(action: UIAlertAction) {
    let ac = UIAlertController(title: "Message", message: nil, preferredStyle: .alert)
    ac.addTextField()
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    ac.addAction(UIAlertAction(title: "Send", style: .default, handler: { [weak self, weak ac] _ in
      if let text = ac?.textFields?[0].text {
        let data = Data(text.utf8)
        self?.sendText(data)
      }
    }))
    present(ac, animated: true)
    
  }
  
  func sendText(_ data: Data) {
    guard let mcSession = mcSession else { return }
    if !mcSession.connectedPeers.isEmpty {
      do {
        try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
      }
      catch {
        let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
      }
    }
  }
  
  func showConnectedPeers(action: UIAlertAction) {
    var peersText = ""
    var peersAvailable = false
    
    if let mcSession = mcSession {
      if mcSession.connectedPeers.count > 0 {
        peersAvailable = true
        for peer in mcSession.connectedPeers {
          peersText += "\n\(peer.displayName)"
        }
      }
    }
    
    if !peersAvailable {
      peersText += "\nNo peer connected"
    }
    
    let ac = UIAlertController(title: "Connected Peers", message: peersText, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default))
    present(ac, animated: true)
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
    // viewWithTag(), searches for any views inside itself with that tag number.
    if let imageView = cell.viewWithTag(1000) as? UIImageView {
      // set the image of the imageView to be an item in the indexPath
      imageView.image = images[indexPath.item]
    }
    return cell
  }
}

// Conforming to session delegates
extension ViewController: MCSessionDelegate, MCBrowserViewControllerDelegate {
  
  // When a user connects or disconnects from our session, this method is helpful for debugging.
  func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    switch state {
    case .connected:
      print("Connected: \(peerID.displayName)")
    case .connecting:
      print("Connecting: \(peerID.displayName)")
    case .notConnected:
      print("Not connected: \(peerID.displayName)")
      let ac = UIAlertController(title: "Disconnected", message: "\(peerID.displayName) is disconnected", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK", style: .default))
      present(ac, animated: true)
    // a default case for whatever might occur in the future
    @unknown default:
      print("Unknown state received: \(peerID.displayName)")
    }
  }
  
  // Its the method that gets executed when the data arrives at each peer
  func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    // we can create a UIImage from it and add it to our images array, using the main thread
    DispatchQueue.main.async { [weak self] in
      if let image = UIImage(data: data) {
        self?.images.insert(image, at: 0)
        self?.collectionView.reloadData()
      } else {
        let text = String(decoding: data, as: UTF8.self)
        let alert = UIAlertController(title: "Message:", message: "\n\(text)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self?.present(alert, animated: true)
      }
    }
  }
  
  func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    
  }
  
  func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    
  }
  
  func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    
  }
  
  func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
    dismiss(animated: true)
  }
  
  func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
    dismiss(animated: true)
  }
  
  
}

