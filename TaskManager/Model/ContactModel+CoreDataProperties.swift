//
//  ContactModel+CoreDataProperties.swift
//  TaskManager
//
//  Created by Eugene on 02.05.2022.
//
//

import Foundation
import CoreData


extension ContactModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactModel> {
        return NSFetchRequest<ContactModel>(entityName: "ContactModel")
    }

    @NSManaged public var name: String?
    @NSManaged public var phone: String?

}

extension ContactModel : Identifiable {

}
