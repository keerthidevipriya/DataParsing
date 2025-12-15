//
//  DetailVC.swift
//  DataParsing
//
//  Created by Keerthi Devipriya(kdp) on 08/02/24.
//

import UIKit

class DetailVC: UIViewController {
    
    lazy var greetLbl: UILabel = {
        var lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        return lbl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func makeViewController(data: String) -> DetailVC {
        let vc = DetailVC()
        vc.configure(text: data)
        return vc
    }
    
    func configure(text: String) {
        self.greetLbl.text = text
        configureView()
        configureViewConstraints()
        configureViewTheme()
    }
    
    func configureView() {
        self.view.addSubview(greetLbl)
    }
    
    func configureViewConstraints() {
        NSLayoutConstraint.activate([
            self.greetLbl.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.greetLbl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    func configureViewTheme() {
        self.view.backgroundColor = .white
    }

}
