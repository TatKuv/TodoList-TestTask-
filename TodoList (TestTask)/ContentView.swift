//
//  ContentView.swift
//  TodoList (TestTask)
//
//  Created by Tatiana Kuvarzina on 18.06.2025.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @FetchRequest(sortDescriptors: []) var todos: FetchedResults<Todo>
    
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var modelData: ModelData
    
    @State private var searchText = ""
    
    var filteredTasks: [Todo] {
        if searchText.isEmpty {
            Array(todos)
        } else {
            todos.filter { $0.todo.localizedStandardContains(searchText) == true }  //search
        }
    }
    
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                List(filteredTasks) { task in
                    HStack(alignment: .firstTextBaseline, spacing: 15) {
                        
                        Image(systemName: task.isCompleted ? "checkmark.circle" : "circle")
                            .scaleEffect(1.8)
                            .foregroundStyle(.yellow)
                        
                        VStack (alignment: .leading) {
                            
                            Group {
                                Text(task.todo)
                                    .font(.title2)
                                    .strikethrough(task.isCompleted)
                                
                                Text(task.taskDescription)
                            }
                            .opacity(task.isCompleted ? 0.6 : 1)
                            
                            Text(task.date?.formatted() ?? "N/A")
                                .opacity(0.6)
                        }
                        .font(.caption)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        task.isCompleted.toggle()
                        //                        do {
                        //                            try moc.save()
                        //
                        //                        } catch {
                        //                            print("changes not saved: \(error)")
                        //                        }
                    }
                    
                    .contextMenu {
                        NavigationLink(value: task) {
                            Label("Редактировать", systemImage: "square.and.pencil")
                        }
                        
                        ShareLink(item: "\(task.todo) \n \(task.taskDescription)") {
                            Label ("Поделиться", systemImage: "square.and.arrow.up")
                        }
                        
                        Button {
                            moc.delete(task)
                            
                            //                            Заменить на функцию
                            //                            do {
                            //                                try moc.save()
                            //
                            //                            } catch {
                            //                                print("deliting not saved: \(error)")
                            //                            }
                            
                            
                        } label: {
                            Label("Удалить", systemImage: "arrow.up.trash")
                        }
                    }
                }
                .navigationDestination(for: Todo.self) { task in
                        TodoDetailedView(todo: task, context: moc)
                    }
                .listStyle(.plain)
                .navigationTitle("Задачи")
                .toolbar {
                    
                    ToolbarItemGroup (placement: .bottomBar) {
                        Spacer()
                        Text("\(todos.count) \(taskWord(for: todos.count))")
                        Spacer()
                        NavigationLink(value: moc) {
                            Label("New", systemImage: "square.and.pencil")
                        }
                        .navigationDestination(for: NSManagedObjectContext.self) { moc in
                            TodoDetailedView(context: moc)
                        }
                        
                    }
                }
                
                .task {
                    if todos.isEmpty {
                        await modelData.loadAndImportTodos(using: moc)
                    }
                }
                .searchable(text: $searchText, prompt: "Search for a task")
            }
            .preferredColorScheme(.dark)
        }
    }
    
    func taskWord(for count: Int) -> String {
        let remainder10 = count % 10
        let remainder100 = count % 100
        
        if remainder100 >= 11 && remainder100 <= 14 {
            return "задач"
        }
        switch remainder10 {
        case 1:
            return "задача"
        case 2...4:
            return "задачи"
        default:
            return "задач"
        }
    }
    
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, DataController().container.viewContext)
        .environmentObject(ModelData())
}
