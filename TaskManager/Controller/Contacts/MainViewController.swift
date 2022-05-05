//
//  MainViewController.swift
//  TaskManager
//
//  Created by Eugene on 30.04.2022.
//

import UIKit

class MainViewController: UIViewController {

    var Contacts = [ContactModel]()
    var contactTable: UITableView = ContactsTable(frame: .zero, style: .plain)
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let attrs = [
        NSAttributedString.Key.foregroundColor: UIColor.systemYellow,
        NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 30)!
    ]
    
    func constraints() {
        NSLayoutConstraint.activate([
            contactTable.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            contactTable.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor),
            contactTable.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            contactTable.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc func getAllContacts() {
        do {
            let contacts = try self.context.fetch(ContactModel.fetchRequest())
            self.Contacts = contacts
            self.contactTable.reloadData()
        } catch let error {
            let errorAlert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            errorAlert.addAction(cancelButton)
            self.present(errorAlert, animated: true, completion: nil)
        }
        
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
            
            let newContact = ContactModel(context: self.context)
            newContact.name = contactName
            newContact.phone = contactPhone
            
            do {
                self.Contacts.append(newContact)
                try self.context.save()
                self.getAllContacts()
            } catch let error {
                let errorAlert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
                self.present(errorAlert, animated: true, completion: nil)
            }
            //self.Contacts.append(newContact)
        }
        
        createAlert.addAction(cancelButton)
        createAlert.addAction(addButton)
        
        self.present(createAlert, animated: true, completion: nil)
        
    }
    @objc func updateContact(update contact: ContactModel) {
        let createAlert = UIAlertController(title: "New contact", message: "Add new contact", preferredStyle: .alert)
        
        createAlert.addTextField { nameTextField in
            nameTextField.text = contact.name
        }
        createAlert.addTextField { phoneTextField in
            phoneTextField.text = contact.phone
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addButton = UIAlertAction(title: "Изменить", style: .default) { _ in
            guard let updetedContactName = createAlert.textFields?[0].text,
                  let updatedContactPhone = createAlert.textFields?[1].text else {
                return
            }
            
            contact.name = updetedContactName
            contact.phone = updatedContactPhone
            
            do {
                try self.context.save()
                self.getAllContacts()
            } catch let error {
                let errorAlert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
                self.present(errorAlert, animated: true, completion: nil)
            }
        }
        
        createAlert.addAction(cancelButton)
        createAlert.addAction(addButton)
        
        self.present(createAlert, animated: true, completion: nil)
    }
    @objc func deleteContact(delete contact: ContactModel) {
        context.delete(contact)
        
        do {
            try context.save()
            self.getAllContacts()
        } catch let error {
            let errorAlert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
            present(errorAlert, animated: true)
        }
    }
    
    private func configure(cell: inout UITableViewCell, for indexPath: IndexPath) {
        var configuration = cell.defaultContentConfiguration()
        configuration.text = Contacts[indexPath.row].name
        configuration.secondaryText = Contacts[indexPath.row].phone
        cell.contentConfiguration = configuration
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
        self.view.addSubview(contactTable)
        self.contactTable.delegate = self
        self.contactTable.dataSource = self
        
        navigationItem.title = "Task Manager"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addContact))
        navigationController?.navigationBar.backgroundColor = .blue
        navigationController?.navigationBar.titleTextAttributes = attrs
        
        getAllContacts()
        constraints()
    }
    
}

extension MainViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Contacts.count
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
            let contactToDelete = self.Contacts[indexPath.row]
            self.deleteContact(delete: contactToDelete)
        }
        let actionEdit = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
            let contactToEdit = self.Contacts[indexPath.row]
            self.updateContact(update: contactToEdit)
        }
        let actions = UISwipeActionsConfiguration(actions: [actionDelete, actionEdit])
        
        return actions
    }
    
}

