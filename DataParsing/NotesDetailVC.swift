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
        btn.setTitle("Create", for: .normal)
        btn.backgroundColor = .blue
        btn.titleLabel?.textColor = .white
        btn.addTarget(self, action: #selector(tapSaveNote), for: .touchUpInside)
        return btn
    }()
    
    lazy var deleteBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Delete", for: .normal)
        btn.backgroundColor = .blue
        btn.titleLabel?.textColor = .white
        btn.addTarget(self, action: #selector(deleteNote), for: .touchUpInside)
        return btn
    }()
    
    lazy var textView: UITextView = {
        let tview = UITextView()
        tview.translatesAutoresizingMaskIntoConstraints = false
        tview.delegate = self
        tview.text = "Enter notes..."
        tview.font = UIFont.systemFont(ofSize: 24)
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
        self.createViews()
        self.createContentView()
        if let detailNote = detailNote {
            self.textView.text = detailNote.description
            self.textView.textColor = .black
        }
    }
    
    func createContentView() {
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            self.textView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor),
            self.textView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 120),
            self.textView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor),
            
            self.saveBtn.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 24),
            self.saveBtn.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -24),
            self.saveBtn.topAnchor.constraint(equalTo: self.textView.bottomAnchor, constant: 16),
            
            
            self.deleteBtn.topAnchor.constraint(equalTo: self.saveBtn.bottomAnchor, constant: 16),
            self.deleteBtn.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 24),
            self.deleteBtn.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -24),
            self.deleteBtn.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -32)
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
        if notes.count <= 0 {
            print("Notes is created successfully")
        } else {
            print("Notes is updated successfully")
        }
        let updatedNote = Note(id: detailNote?.id ?? 1, title: detailNote?.title, description: textView.text)
        self.delegate?.saveNotes(detailNote: updatedNote)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func deleteNote() {
        if notes.count <= 0 {
            self.deleteBtn.isEnabled = false
            print("Notes is not yet created")
            return
        } else {
            self.deleteBtn.isEnabled = true
            print("Notes is deleted successfully")
        }
        let updatedNote = Note(id: detailNote?.id ?? 1, title: detailNote?.title, description: textView.text)
        self.delegate?.deleteNotes(detailNote: updatedNote)
        self.navigationController?.popViewController(animated: true)
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

        if textView.text == "" {
            //textViw.text = "Enter notes....."
            textView.textColor = UIColor.lightGray
        }
    }
}
