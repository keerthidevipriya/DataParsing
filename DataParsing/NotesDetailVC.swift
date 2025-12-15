//
//  NotesDetailVC.swift
//  DataParsing
//
//  Created by Keerthi Devipriya(kdp) on 15/12/25.
//

import UIKit

class NotesDetailVC: UIViewController {
    
    var notes: [Note] = []
    var detailNote: Note?
    
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var saveBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.text = "Create"
        btn.backgroundColor = .blue
        btn.titleLabel?.textColor = .white
        btn.addTarget(self, action: #selector(tapSaveNote), for: .touchUpInside)
        return btn
    }()
    
    lazy var deleteBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.text = "Create"
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
        var vc = NotesDetailVC()
        vc.notes = notes
        vc.detailNote = detailNote
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createViews()
        self.createContentView()
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
            //self.createBtn.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -12)
        ])
    }
    
    func createViews() {
        self.containerView.addSubview(textView)
        self.containerView.addSubview(saveBtn)
        self.containerView.addSubview(deleteBtn)
        self.view.addSubview(containerView)
    }

}


extension NotesDetailVC: UITextViewDelegate {
    @objc func tapSaveNote() {
        if notes.count <= 0 {
            var note = Note(id: 1, title: nil, description: textView.text)
            notes.append(note)
            print("Notes is created successfully")
        } else {
            if let detailNote = detailNote {
                let id = detailNote.id
                var updatedNote = Note(id: id, title: detailNote.title, description: textView.text)
                notes.remove(at: id-1)
                notes.insert(updatedNote, at: detailNote.id-1)
                //Need to check whether I can directly add or sorting and stuff enough
            }
        }
    }
    
    @objc func deleteNote() {
        for i in notes {
            if i.id == detailNote?.id {
                notes.remove(at: (i.id)-1)
                print("Notes is deleted successfully")
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {

        if textView.text == "" {

            textView.text = "enter notes....."
            textView.textColor = UIColor.lightGray
        }
    }
}
