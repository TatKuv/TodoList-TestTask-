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
    
    
    var body: some View {
        
        NavigationStack {
            FilteredList(searchText: searchText)
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
            
//                .task {
//                    if todos.isEmpty {
//                        await modelData.loadAndImportTodos(using: moc)
//                    }
//                }
                .searchable(text: $searchText, prompt: "Поиск задач")
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
