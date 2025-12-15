/*
 As a user, I want a simple Notes application so that I can keep track of my thoughts.
 Acceptance Criteria:
 When I open the app, I should see a list of all my notes on the main screen.
 If I haven’t created any notes yet, the screen should indicate that it’s empty.
 I must have the ability to create a new note.
 I must be able to edit any of my existing notes.
 I must be able to delete any note I no longer need
 */

import UIKit

class Note {
    var id: Int
    var title: String?
    var description: String
    
    init(id: Int, title: String? = nil, description: String) {
        self.id = id
        self.title = title
        self.description = description
    }
}


class ViewController: UIViewController {
    
    var notes: [Note] = []
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var tv: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .singleLine
        tv.estimatedRowHeight = 100
        tv.backgroundColor = .white
        tv.rowHeight = UITableView.automaticDimension
        return tv
    }()
    
    lazy var createBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Create", for: .normal)
        btn.backgroundColor = .blue
        btn.titleLabel?.textColor = .white
        btn.addTarget(self, action: #selector(tapCreate), for: .touchUpInside)
        return btn
    }()
    
    lazy var infoLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "No notes created 😔 Create one to start new!!!!"
        lbl.textColor = .darkGray
        return lbl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Personal Notes"
        self.createViews()
        self.createContentView()
        self.handleNotes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.handleNotes()
    }
    
    func createContentView() {
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            self.infoLbl.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            self.infoLbl.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor),
            
            self.tv.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 120),
            self.tv.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 12),
            self.tv.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -12),
            
            self.createBtn.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 24),
            self.createBtn.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -24),
            self.createBtn.topAnchor.constraint(equalTo: self.tv.bottomAnchor, constant: 16),
            self.createBtn.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -32),
            self.createBtn.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func createViews() {
        self.containerView.addSubview(tv)
        self.containerView.addSubview(infoLbl)
        self.containerView.addSubview(createBtn)
        self.view.addSubview(containerView)
    }
    
    func handleNotes() {
        if notes.count > 0 {
            self.infoLbl.isHidden = true
            fetchNotes()
        } else {
            self.infoLbl.isHidden = false
        }
    }
    
    func fetchNotes() {
        self.tv.reloadData()
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let text = notes[indexPath.row].description
        cell.backgroundColor = .lightGray
        cell.textLabel?.text = text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigateToNotesDetailVC(detailNote: notes[indexPath.row])
    }
}

extension ViewController {
    func navigateToNotesDetailVC(detailNote: Note?) {
        let vc = NotesDetailVC.makeViewController(notes: self.notes, detailNote: detailNote)
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tapCreate() {
        self.navigateToNotesDetailVC(detailNote: nil)
    }
}


extension ViewController: NoteActions {
    func saveNotes(detailNote: Note) {
        let id = detailNote.id
        self.notes.append(detailNote)
        
        //self.notes.remove(at: id-1)
        //self.notes.insert(detailNote, at: detailNote.id-1)
    }
}
