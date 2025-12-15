//
//  NotesDetailVC.swift
//  DataParsing
//
//  Created by Keerthi Devipriya(kdp) on 15/12/25.
//

import UIKit

protocol NoteActions: AnyObject {
    func saveNotes(detailNote: Note)
    func deleteNotes(detailNote: Note)
}

class NotesDetailVC: UIViewController {
    
    var notes: [Note] = []
    var detailNote: Note?
    weak var delegate: NoteActions?
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var saveBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .blue
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(tapSaveNote), for: .touchUpInside)
        return btn
    }()
    
    lazy var deleteBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Delete", for: .normal)
        btn.backgroundColor = .red
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(deleteNote), for: .touchUpInside)
        return btn
    }()
    
    lazy var textView: UITextView = {
        let tview = UITextView()
        tview.translatesAutoresizingMaskIntoConstraints = false
        tview.delegate = self
        tview.text = "Enter notes..."
        tview.font = UIFont.systemFont(ofSize: 18)
        tview.textColor = UIColor.lightGray
        return tview
    }()

    static func makeViewController(notes: [Note], detailNote: Note?) -> NotesDetailVC {
        let vc = NotesDetailVC()
        vc.notes = notes
        vc.detailNote = detailNote
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = detailNote == nil ? "Create Note" : "Edit Note"
        self.createViews()
        self.createContentView()
        self.setUpButton()
    }
    
    func setUpButton() {
        if let detailNote = detailNote {
            self.textView.text = detailNote.description
            self.textView.textColor = .black
            self.saveBtn.setTitle("Save", for: .normal)
            self.deleteBtn.isHidden = false
        } else {
            self.saveBtn.setTitle("Create", for: .normal)
            self.deleteBtn.isHidden = true
        }
    }
    
    func createContentView() {
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            self.textView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 16),
            self.textView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 120),
            self.textView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -16),
            self.textView.heightAnchor.constraint(equalToConstant: 200),
            
            self.saveBtn.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 24),
            self.saveBtn.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -24),
            self.saveBtn.topAnchor.constraint(equalTo: self.textView.bottomAnchor, constant: 16),
            self.saveBtn.heightAnchor.constraint(equalToConstant: 44),
            
            self.deleteBtn.topAnchor.constraint(equalTo: self.saveBtn.bottomAnchor, constant: 16),
            self.deleteBtn.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 24),
            self.deleteBtn.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -24),
            self.deleteBtn.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -32),
            self.deleteBtn.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func createViews() {
        self.containerView.addSubview(textView)
        self.containerView.addSubview(saveBtn)
        self.containerView.addSubview(deleteBtn)
        self.view.addSubview(containerView)
    }
}

extension NotesDetailVC {
    @objc func tapSaveNote() {
        let description = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if description.isEmpty || description == "Enter notes..." {
            let alert = UIAlertController(title: "Error", message: "Please enter some text for the note.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        let note: Note
        if let existingNote = detailNote {
            note = Note(id: existingNote.id, description: description)
        } else {
            let newId = notes.count + 1
            note = Note(id: newId, description: description)
        }
        self.delegate?.saveNotes(detailNote: note)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func deleteNote() {
        guard let detailNote = detailNote else { return }
        
        let alert = UIAlertController(title: "Delete Note", message: "Are you sure you want to delete this note?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.delegate?.deleteNotes(detailNote: detailNote)
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }
}

extension NotesDetailVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "Enter notes..."
            textView.textColor = UIColor.lightGray
        }
    }
}
