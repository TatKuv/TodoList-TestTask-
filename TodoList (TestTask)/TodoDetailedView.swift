//
//  TodoDetailedView.swift
//  TodoList (TestTask)
//
//  Created by Tatiana Kuvarzina on 19.06.2025.
//
import CoreData
import SwiftUI

struct TodoDetailedView: View {
    //@Environment(\.managedObjectContext) var moc
    
    var context: NSManagedObjectContext
    var todo: Todo
    
    @State private var title = ""
    @State private var taskDescription = ""

    init(todo: Todo, context: NSManagedObjectContext) {
        self.todo = todo
        self.title = todo.todo //?? "Task"
        self.taskDescription = todo.taskDescription //?? ""
        
        self.context = context
    }
    
    init(context: NSManagedObjectContext) {
        
        let todo = Todo(context: context)
        todo.id = UUID().uuidString
        todo.todo = "New Task"
        todo.taskDescription = "Task Description"
        todo.date = Date.now
        todo.isCompleted = false
        
        self.init(todo: todo, context: context)
    }
    
    var dateStr: String {
        let date = todo.date //?? Date.now
            return date.formatted(date: .numeric, time: .omitted)
    }
    
    
    var body: some View {
        
        NavigationView {
        
            VStack (alignment: .leading, spacing: 20) {
                TextField("Todo", text: $title)
                    .font(.largeTitle)
                    .bold()
                Text(dateStr)
                    .font(.caption)
                    .opacity(0.8)
                TextField("Todo", text: $taskDescription)
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
            .onDisappear {
                todo.todo = title
                todo.taskDescription = taskDescription
                
                do {
                    try context.save()
                } catch {
                    print("Редактирование не удалось")
                }
            }
        }
    }
}

#Preview {
    //TodoDetailedView()
}
