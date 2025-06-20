//
//  ContentView.swift
//  TodoList (TestTask)
//
//  Created by Tatiana Kuvarzina on 18.06.2025.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var todos: FetchedResults<Todo>
    
    @EnvironmentObject var dataController: DataController
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
                            .foregroundStyle(task.isCompleted ? .yellow : .gray)
                        
                        VStack (alignment: .leading) {
                            
                            Group {
                                Text(task.todo)
                                    .font(.title2)
                                    .strikethrough(task.isCompleted)
                                
                                Text(task.taskDescription)
                            }
                            .opacity(task.isCompleted ? 0.6 : 1)
                            
                            Text(task.date.formatted(date: .numeric, time: .omitted))
                                .opacity(0.6)
                        }
                        .font(.caption)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        task.isCompleted.toggle()
                        dataController.saveData()
                    }
                    
                    .contextMenu {
                        NavigationLink(value: task) {
                            Label("Редактировать", systemImage: "square.and.pencil")
                        }
                        
                        ShareLink(item: "\(task.todo) \n \(task.taskDescription)") {
                            Label ("Поделиться", systemImage: "square.and.arrow.up")
                        }
                        
                        Button {
                                modelData.deleteInBackground(task: task, dataController: dataController) {
                                    // filteredTodos.removeAll { $0.objectID == task.objectID }
                            }
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
                        
                        NavigationLink {
                            TodoDetailedView(context: dataController.newBackgroundContext())
                        } label: {
                            Label("New", systemImage: "square.and.pencil")
                        }
                    }
                }
                
                .task {
                    if todos.isEmpty {
                        await modelData.loadAndImportTodos(using: dataController)
                    }
                }
                .searchable(text: $searchText, prompt: "Поиск задач")
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
    let dataController = DataController()
    ContentView()
        .environment(\.managedObjectContext, dataController.context)
        .environmentObject(dataController)
        .environmentObject(ModelData())
}
