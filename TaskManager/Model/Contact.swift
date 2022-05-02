//
//  Contact.swift
//  TaskManager
//
//  Created by Eugene on 02.05.2022.
//

import Foundation

protocol ContactProtocol {
    var title: String { get set }
    var phone: String { get set }
}

struct Contact: ContactProtocol {
    
    var title: String
    var phone: String
    
}
