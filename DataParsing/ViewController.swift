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
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(tapCreate), for: .touchUpInside)
        return btn
    }()
    
    lazy var infoLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "No notes created 😔 Create one to start!"
        lbl.textColor = .darkGray
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
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
            self.infoLbl.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 24),
            self.infoLbl.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -24),
            
            self.tv.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 120),
            self.tv.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 12),
            self.tv.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -12),
            
            self.createBtn.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 24),
            self.createBtn.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -24),
            self.createBtn.topAnchor.constraint(equalTo: self.tv.bottomAnchor, constant: 16),
            self.createBtn.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -32),
            self.createBtn.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    func createViews() {
        self.containerView.addSubview(tv)
        self.containerView.addSubview(infoLbl)
        self.containerView.addSubview(createBtn)
        self.view.addSubview(containerView)
    }
    
    func handleNotes() {
        if notes.isEmpty {
            self.infoLbl.isHidden = false
            self.tv.isHidden = true
        } else {
            self.infoLbl.isHidden = true
            self.tv.isHidden = false
            self.tv.reloadData()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "NoteCell")
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.description
        cell.textLabel?.numberOfLines = 0
        cell.backgroundColor = .lightGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
    func deleteNotes(detailNote: Note) {
        if let index = notes.firstIndex(where: { $0.id == detailNote.id }) {
            notes.remove(at: index)
            handleNotes()
        }
    }
    
    func saveNotes(detailNote: Note) {
        if let index = notes.firstIndex(where: { $0.id == detailNote.id }) {
            notes[index] = detailNote
        } else {
            notes.append(detailNote)
        }
        handleNotes()
    }
}
