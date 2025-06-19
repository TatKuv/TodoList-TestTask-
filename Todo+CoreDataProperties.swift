//
//  Todo+CoreDataProperties.swift
//  TodoList (TestTask)
//
//  Created by Tatiana Kuvarzina on 18.06.2025.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var id: String?
    @NSManaged public var todo: String?
    @NSManaged public var taskDescription: String?
    @NSManaged public var date: Date?
    @NSManaged public var isCompleted: Bool

}

extension Todo : Identifiable {

}
