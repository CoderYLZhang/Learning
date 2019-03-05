//
//  NotesListViewController.swift
//  SwiftTextKitNotepad
//
//  Created by 张银龙 on 2019/3/5.
//  Copyright © 2019 张银龙. All rights reserved.
//


import UIKit

class NotesListViewController: UITableViewController {
  
  enum Segue {
    static let noteSelected =  "CellSelected"
    static let newNote =  "AddNewNote"
  }
  
  // some default notes to play with
  var notes = [
    Note(text: "~Shopping List~\r\r1. _Cheese_\r2. Biscuits\r3. Sausages\r4. IMPORTANT Cash for going out!\r5. -potatoes-\r6. A copy of iOS8 by Tutorials\r7. A new iPhone\r8. A present for mum"),
    Note(text: "Meeting notes\rA long and drawn out meeting, it lasted hours and hours and hours!"),
    Note(text: "Perfection ... \n\nPerfection is achieved not when there is nothing left to add, but when there is nothing left to take away - Antoine de Saint-Exupery"),
    Note(text: "Notes on Swift\nThis new language from Apple is changing iOS development as we know it!"),
    Note(text: "Meeting notes\rA different meeting, just as long and boring"),
    Note(text: "A collection of thoughts\rWhy do birds sing? Why is the sky blue? Why is it so hard to create good test data?"),
    
    Note(text: "Meeting notes\rA long and drawn out meeting, it lasted hours and hours and hours!"),
    Note(text: "Perfection ... \n\nPerfection is achieved not when there is nothing left to add, but when there is nothing left to take away - Antoine de Saint-Exupery"),
    Note(text: "Notes on Swift\nThis new language from Apple is changing iOS development as we know it!"),
    Note(text: "Meeting notes\rA different meeting, just as long and boring"),
    Note(text: "A collection of thoughts\rWhy do birds sing? Why is the sky blue? Why is it so hard to create good test data?")
  ]

  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    // whenever this view controller appears, reload the table. This allows it to reflect any changes
    // made whilst editing notes
    tableView.reloadData()
    navigationController?.navigationBar.barStyle = .black
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 45.0
  }
  
  //MARK: -  Table view data source
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return notes.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
    
    // Configure the cell...
    let note = notes[indexPath.row]
    cell.textLabel?.text = note.title
    let fontList : [UIFont.TextStyle] = [.largeTitle,
                                         .title1,
                                         .title2,
                                         .title3,
                                         .headline,
                                         .subheadline,
                                         .body,
                                         .callout,
                                         .footnote,
                                         .caption1,
                                         .caption2
    ]
    
    let font = UIFont.preferredFont(forTextStyle: fontList[indexPath.row])
    let textColor = UIColor(red: 0.175, green: 0.458, blue: 0.831, alpha: 1)
    let attributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: textColor,
        .font: font,
        .textEffect: NSAttributedString.TextEffectStyle.letterpressStyle]
    
    let attributedString = NSAttributedString(string: note.title, attributes: attributes)
    cell.textLabel?.attributedText = attributedString
    cell.detailTextLabel?.text = fontList[indexPath.row].rawValue
    
    return cell
    
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
    guard let editorVC = segue.destination as? NoteEditorViewController else {
      return
    }
    
    if Segue.noteSelected == segue.identifier {
      if let path = tableView.indexPathForSelectedRow {
        editorVC.note = notes[path.row]
      }
    } else if Segue.newNote == segue.identifier {
      editorVC.note = Note(text: " ")
      notes.append(editorVC.note)
    }
  }
}
