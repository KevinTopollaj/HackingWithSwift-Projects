//
//  NoteDetailViewController.swift
//  NotesApp
//
//  Created by Mr.Kevin on 07/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit

// 1- Create the protocol
protocol NoteDetailViewControllerDelegate: class {
  func shouldAdd(note: String)
  func updateNote(index: Int, content: String)
}

class NoteDetailViewController: UIViewController {
  
  // 2 - Declare a property that has the delegate type
  weak var delegate: NoteDetailViewControllerDelegate!
  var selectedNoteIndex: Int?
  var noteContent: String?
  var isEdited: Bool?
  
  lazy var noteTextView: UITextView = {
    let textView = UITextView()
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.font = UIFont.systemFont(ofSize: 18)
    return textView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpNavigation()
    setUpTextView()
    setupKeyboard()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    guard let isEdited = isEdited else { return }
    if isEdited {
      if let content = noteContent {
        noteTextView.text = content
      }
    } else {
      noteTextView.text = ""
    }
  }
  
  func setUpNavigation() {
    navigationItem.largeTitleDisplayMode = .never
    view.backgroundColor = .white
    let doneBarBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(done))
    let shareBarBtn = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareNote))
    navigationItem.rightBarButtonItems = [doneBarBtn, shareBarBtn]
  }
  
  @objc func done() {

    guard let isEdited = isEdited else { return }
    guard let note = noteTextView.text else { return }
    
    // 3 - Call the delegate method and give it the value
    if note != "" {
      if let delegate = delegate {
        
        if isEdited {
          guard let index = selectedNoteIndex else { return }
          delegate.updateNote(index: index, content: note)
        } else {
          delegate.shouldAdd(note: note)
        }
        navigationController?.popViewController(animated: true)
      }
    }
  }
  
  @objc func shareNote() {
    guard let note = noteTextView.text else { return }
    let activityVC = UIActivityViewController(activityItems: [note], applicationActivities: [])
    activityVC.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    present(activityVC, animated: true)
  }
  
  func setUpTextView() {
    view.addSubview(noteTextView)
    NSLayoutConstraint.activate([
      noteTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      noteTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      noteTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      noteTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
      ])
  }
  
  func setupKeyboard() {
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
  }
  
  @objc func adjustForKeyboard(notification: Notification) {
    guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    
    let keyboardScreenEndFrame = keyboardValue.cgRectValue
    let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
    
    if notification.name == UIResponder.keyboardWillHideNotification {
      noteTextView.contentInset = .zero
    } else {
      noteTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
    }
    
    noteTextView.scrollIndicatorInsets = noteTextView.contentInset
    
    let selectedRange = noteTextView.selectedRange
    noteTextView.scrollRangeToVisible(selectedRange)
  }
  
  
}
