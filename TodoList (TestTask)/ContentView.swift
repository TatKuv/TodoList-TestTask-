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
            todos.filter { $0.todo?.localizedStandardContains(searchText) == true }  //search
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
                                Text(task.todo ?? "cant specify")
                                    .font(.title2)
                                    .strikethrough(task.isCompleted)
                                
                                Text(task.taskDescription ?? "N/A")
                            }
                            .opacity(task.isCompleted ? 0.6 : 1)
                            
                            Text(task.date?.formatted() ?? "N/A")
                                .opacity(0.6)
                        }
                        .font(.caption)
                    }
                    
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
                        
                        NavigationLink(destination: TodoDetailedView(todo: task)) {
                            Label("Редактировать", systemImage: "square.and.pencil")
                        }
                        
                        Button {
                        } label: {
                            Label("Поделиться", systemImage: "square.and.arrow.up")
                        }
                        Button {
                            moc.delete(task)
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
                .listStyle(.plain)
                .navigationTitle("Задачи")
                .toolbar {
                    
                    ToolbarItemGroup (placement: .bottomBar) {
                        Spacer()
                            Text("\(todos.count) задач")
                        Spacer()
//                            Button("New", systemImage: "square.and.pencil") {
//                                
//                            }
                        NavigationLink(destination: TodoDetailedView()) {  //нужно передавать новый объект
                            
                            Label("New", systemImage: "square.and.pencil")
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
}

#Preview {
    ContentView()
        .environmentObject(DataController())
        .environmentObject(ModelData())
}
