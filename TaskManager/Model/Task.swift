//
//  Task.swift
//  TaskManager
//
//  Created by Eugene on 05.05.2022.
//

import Foundation

enum TaskPriority {
    case normal
    case important
}

enum TaskStatus {
    case planned
    case completed
}

protocol TaskProtocol {
    var title: String { get set }
    var type: TaskPriority { get set }
    var status: TaskStatus { get set }
}
