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
    
    var contactTable: UITableView = ContactsTable(frame: .zero, style: .plain)
    
    private var contacts: [ContactProtocol] = [] {
        didSet {
            contacts.sort{ $0.title < $1.title }
        }
    }
    
    private func loadContacts() {
        contacts.append(Contact(title: "Аня", phone: "+7(978)-766-76-09"))
        contacts.append(Contact(title: "Оля", phone: "+7(954)-766-76-07"))
        contacts.append(Contact(title: "Варя", phone: "+7(910)-766-76-10"))
        contacts.append(Contact(title: "Арина", phone: "+7(982)-766-76-08"))
    }
    private func configure(cell: inout UITableViewCell, for indexPath: IndexPath) {
        var configuration = cell.defaultContentConfiguration()
        configuration.text = contacts[indexPath.row].title
        configuration.secondaryText = contacts[indexPath.row].phone
        cell.contentConfiguration = configuration
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            contactTable.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            contactTable.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor),
            contactTable.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            contactTable.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc func addContact() {
        let createAlert = UIAlertController(title: "New contact", message: "Add new contact", preferredStyle: .alert)
        
        createAlert.addTextField { nameTextField in
            nameTextField.text = "Имя"
        }
        createAlert.addTextField { phoneTextField in
            phoneTextField.text = "Номер телефона"
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addButton = UIAlertAction(title: "Добавить", style: .default) { _ in
            guard let contactName = createAlert.textFields?[0].text,
                  let contactPhone = createAlert.textFields?[1].text else {
                return
            }
            let contact = Contact(title: contactName, phone: contactPhone)
            
            self.contacts.append(contact)
            self.contactTable.reloadData()
        }
        
        createAlert.addAction(cancelButton)
        createAlert.addAction(addButton)
        
        self.present(createAlert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(contactTable)
        self.contactTable.delegate = self
        self.contactTable.dataSource = self
        
        loadContacts()
        constraints()
        
        navigationItem.title = "Task Manager"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addContact))
        navigationController?.navigationBar.backgroundColor = .blue
        navigationController?.navigationBar.titleTextAttributes = attrs
        
    }
    
}

extension MainViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.identifier, for: indexPath)
        configure(cell: &cell, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension MainViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDelete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.contacts.remove(at: indexPath.row)
            tableView.reloadData()
        }
        let actionEdit = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
            
        }
        let actions = UISwipeActionsConfiguration(actions: [actionDelete, actionEdit])
        
        return actions
    }
    
}

