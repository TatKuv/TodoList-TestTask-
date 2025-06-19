//
//  TodoDTO.swift
//  TodoList (TestTask)
//
//  Created by Tatiana Kuvarzina on 18.06.2025.
//

import Foundation

class Todos: Decodable {
    let todos: [TodoDTO]
}


class TodoDTO: Codable, Hashable, Identifiable, ObservableObject {
    
    static func == (lhs: TodoDTO, rhs: TodoDTO) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    
    let id: Int
    var title: String
    var taskDescription: String
    var completed: Bool
    var date = Date.now.formatted(date: .numeric, time: .omitted)
    
    enum CodingKeys: String, CodingKey {
        case id
        case taskDescription = "todo"
        case completed
    }
    
    required init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.taskDescription = try container.decode(String.self, forKey: .taskDescription)
        self.completed = try container.decode(Bool.self, forKey: .completed)
        
        //let index = taskDescription.index(taskDescription.startIndex,offsetBy: 8)
        
           // self.title = String(taskDescripton[...index] )
        
        self.title = taskDescription
    }
    
    init(id: Int, taskDescription: String, title: String, completed: Bool = false) {
        self.id = id
        self.taskDescription = taskDescription
        self.title = title
        self.completed = completed
    }

}

