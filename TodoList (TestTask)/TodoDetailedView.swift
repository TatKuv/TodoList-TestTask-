//
//  TodoDetailedView.swift
//  TodoList (TestTask)
//
//  Created by Tatiana Kuvarzina on 19.06.2025.
//
import CoreData
import SwiftUI

struct TodoDetailedView: View {
    
    var context: NSManagedObjectContext
    var todo: Todo
    
    @State private var title = ""
    @State private var taskDescription = ""
    
    @FocusState private var isFocused : Bool
    
    init(todo: Todo, context: NSManagedObjectContext) {
        self.todo = todo
        self.title = todo.todo //?? "Task"
        self.taskDescription = todo.taskDescription //?? ""
        
        self.context = context
    }
    
    init(context: NSManagedObjectContext) {
        
        let todo = Todo(context: context)
        todo.id = UUID().uuidString
        todo.todo = "Новая задача"
        todo.taskDescription = "Описание"
        todo.date = Date.now
        todo.isCompleted = false
        
        self.init(todo: todo, context: context)
    }
    
    var dateStr: String {
        let date = todo.date
        return date.formatted(date: .numeric, time: .omitted)
    }
    
    
    var body: some View {
        
        NavigationStack {
            
            VStack (alignment: .leading, spacing: 20) {
                TextField("Задача", text: $title, axis: .vertical)
                    .font(.largeTitle)
                    .bold()
                    .focused($isFocused)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            isFocused = true
                        }
                    }
                Text(dateStr)
                    .font(.caption)
                    .opacity(0.8)
                TextField("Описание", text: $taskDescription, axis: .vertical)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .onDisappear {
                todo.todo = title
                todo.taskDescription = taskDescription
                
                if context.hasChanges {
                    do {
                        try context.save()
                    } catch {
                        print("Редактирование не удалось: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}

#Preview {
    //TodoDetailedView()
}
