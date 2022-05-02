//
//  ContactsTable.swift
//  TaskManager
//
//  Created by Eugene on 02.05.2022.
//

import UIKit

class ContactsTable: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.backgroundColor = .systemYellow
        self.translatesAutoresizingMaskIntoConstraints = false
        self.register(ContactCell.self, forCellReuseIdentifier: ContactCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
