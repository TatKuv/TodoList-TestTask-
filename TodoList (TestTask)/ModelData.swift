//
//  ModelData.swift
//  TodoList (TestTask)
//
//  Created by Tatiana Kuvarzina on 18.06.2025.
//

import CoreData
import Foundation


final class ModelData: ObservableObject {

    func deleteInBackground(task: Todo, dataController: DataController, completion: @escaping () -> Void = {}) {
        let objectID = task.objectID
        let context = dataController.newBackgroundContext()

        context.perform {
            do {
                if let object = try? context.existingObject(with: objectID) {
                    context.delete(object)
                    try context.save()
                }
                DispatchQueue.main.async {
                    completion()
                }
            } catch {
                print("Ошибка удаления: \(error.localizedDescription)")
            }
        }
    }
    
    
        func importTodos(from todos: [TodoDTO], into context: NSManagedObjectContext) throws {
            
            for dto in todos {
                let todo = Todo(context: context)
                todo.id = UUID().uuidString
                todo.todo = dto.title
                todo.isCompleted = dto.completed
                todo.date = Date.now
                todo.taskDescription = dto.title
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Ошибка при сохранении: \(error), \(error.userInfo)")
        }
    }
    
    func loadAndImportTodos(using context: NSManagedObjectContext) async {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            print("Invalid URL")
            return
        }

        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedData = try? decoder.decode(Todos.self, from: data) {
                        do {
                            try self.importTodos(from: decodedData.todos, into: context)
                        } catch {
                            print("no transfered")
                        }
            }
            
        } catch {
            print("Invalid data")
        }
        
    }
}
