//
//  ModelData.swift
//  TodoList (TestTask)
//
//  Created by Tatiana Kuvarzina on 18.06.2025.
//

import CoreData
import Foundation


final class ModelData: ObservableObject {

    
    func importTodos(from todos: [TodoDTO], into dataController: DataController) throws {
        let context = dataController.newBackgroundContext()
        
        context.perform {
            for dto in todos {
                let todo = Todo(context: context)
                todo.id = UUID().uuidString
                todo.todo = dto.title
                todo.isCompleted = dto.completed
                todo.date = Date.now
                todo.taskDescription = dto.title
            }
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Ошибка при сохранении: \(error), \(error.userInfo)")
        }
    }
    
    func loadAndImportTodos(using dataController: DataController) async {
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
                            try self.importTodos(from: decodedData.todos, into: dataController)
                        } catch {
                            print("no transfered")
                        }
            }
            
        } catch {
            print("Invalid data")
        }
        
    }
}
