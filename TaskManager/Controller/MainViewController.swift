//
//  MainViewController.swift
//  TaskManager
//
//  Created by Eugene on 30.04.2022.
//

import UIKit

class MainViewController: UIViewController {

    let attrs = [
        NSAttributedString.Key.foregroundColor: UIColor.systemYellow,
        NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 30)!
    ]
    
    var contactTable: UITableView = UITableView(frame: .zero, style: .plain)
    
    private var contacts = [ContactProtocol]()
    
    private func loadContacts() {
        contacts.append(Contact(title: "Варя", phone: "+7(910)-766-76-10"))
        contacts.append(Contact(title: "Аня", phone: "+7(978)-766-76-09"))
        contacts.append(Contact(title: "Арина", phone: "+7(982)-766-76-08"))
        contacts.append(Contact(title: "Оля", phone: "+7(954)-766-76-07"))
    }
    private func configure(cell: inout UITableViewCell, for indexPath: IndexPath) {
        var configuration = cell.defaultContentConfiguration()
        configuration.text = contacts[indexPath.row].title
        configuration.secondaryText = contacts[indexPath.row].phone
        cell.contentConfiguration = configuration
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            contactTable.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor),
            contactTable.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor),
            contactTable.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            contactTable.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactTable.translatesAutoresizingMaskIntoConstraints = false
        contactTable.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        self.view.addSubview(contactTable)
        self.contactTable.delegate = self
        self.contactTable.dataSource = self
        
        loadContacts()
        constraints()
        
        navigationItem.title = "Task Manager"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        navigationController?.navigationBar.backgroundColor = .blue
        navigationController?.navigationBar.titleTextAttributes = attrs
        
    }
    
}

extension MainViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        configure(cell: &cell, for: indexPath)
        return cell
    }
    
}
