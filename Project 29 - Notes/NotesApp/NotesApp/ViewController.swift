//
//  ViewController.swift
//  NotesApp
//
//  Created by Mr.Kevin on 06/08/2019.
//  Copyright © 2019 Mr.Kevin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  var notes = [Note]()
  // 4 - Create an instance of the NoteDetailViewController
  var noteDetailVC = NoteDetailViewController()
  let defaults = UserDefaults.standard
  
  lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(NoteCell.self, forCellReuseIdentifier: NoteCell.identifier)
    tableView.estimatedRowHeight = NoteCell.Metrics.height
    tableView.rowHeight = NoteCell.Metrics.height
    tableView.dataSource = self
    tableView.delegate = self
    return tableView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpNavigation()
    setUpTableView()
    
    loadNotes()
    
    // 5 - Make the current class to be the delegate
    noteDetailVC.delegate = self
  }
  
  func setUpNavigation() {
    title = "Notes"
    navigationController?.navigationBar.prefersLargeTitles = true
    view.backgroundColor = .white
    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let composeBarButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(displayNoteTextView))
    toolbarItems = [spacer, composeBarButton]
    navigationController?.isToolbarHidden = false
  }
  
  @objc func displayNoteTextView() {
    noteDetailVC.isEdited = false
    navigationController?.pushViewController(noteDetailVC, animated: true)
  }
  
  func setUpTableView() {
    view.addSubview(tableView)
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
      ])
  }

  // 1* Will save the notes data to user defaults
  func saveNotes() {
    let jsonEncoder = JSONEncoder()
    if let savedNotes = try? jsonEncoder.encode(notes) {
      defaults.set(savedNotes, forKey: "savedNotes")
    } else {
      print("Failed to save notes")
    }
  }
  
  // 3* Load the data back from disk when the app runs
  func loadNotes() {
    if let savedNotes = defaults.object(forKey: "savedNotes") as? Data {
      let decoder = JSONDecoder()
      do {
        notes = try decoder.decode([Note].self, from: savedNotes)
        notes.sort { $0.date > $1.date }
      } catch {
        print("Failed to load note")
      }
    }
  }

}

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    noteDetailVC.isEdited = true
    noteDetailVC.selectedNoteIndex = indexPath.row
    noteDetailVC.noteContent = notes[indexPath.row].content
    navigationController?.pushViewController(noteDetailVC, animated: true)
  }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return notes.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.identifier, for: indexPath) as? NoteCell else { fatalError("Cell not found") }
    cell.accessoryType = .disclosureIndicator
    cell.noteLabel.text = notes[indexPath.row].content
    cell.dateLabel.text = Date.getCurrentDate()
    return cell
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      notes.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
      // 2* Save the state
      saveNotes()
    }
  }

}

// 6 - Adopt the delegate
extension ViewController: NoteDetailViewControllerDelegate {

  func shouldAdd(note: String) {
    let myNote = Note(content: note, date: Date.getCurrentDate())
    notes.append(myNote)
    // 2* Save the state
    saveNotes()
    tableView.reloadData()
  }
  
  func updateNote(index: Int, content: String) {
    notes[index].content = content
    // 2* Save the state
    saveNotes()
    tableView.reloadData()
  }
  
}

