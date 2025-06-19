//
//  DataController.swift
//  TodoList (TestTask)
//
//  Created by Tatiana Kuvarzina on 18.06.2025.
//

import CoreData
import Foundation


class DataController: ObservableObject {
    
    let container = NSPersistentContainer(name: "Todos")

    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        context.automaticallyMergesChangesFromParent = true
    }
    
    
    
    func newBackgroundContext() -> NSManagedObjectContext {
        let context = container.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        return context
    }
    
    
    func saveData() {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print("Error saving. \(error.localizedDescription)")
            }
        }
    }
    
}

