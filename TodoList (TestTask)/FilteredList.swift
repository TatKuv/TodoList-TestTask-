//
//  FilteredList.swift
//  TodoList (TestTask)
//
//  Created by Tatiana Kuvarzina on 21.06.2025.
//

import CoreData
import SwiftUI

struct FilteredList: View {
    @Environment(\.managedObjectContext) var moc
        @EnvironmentObject var dataController: DataController
        @EnvironmentObject var modelData: ModelData
    
    @FetchRequest var filteredTodos: FetchedResults<Todo>
    
    init(searchText: String) {
        let predicate: NSPredicate? = searchText.isEmpty ? nil : NSPredicate(format: "todo CONTAINS[cd] %@", searchText)

        _filteredTodos = FetchRequest<Todo>(
                   sortDescriptors: [SortDescriptor(\.date, order: .reverse)],
                   predicate: predicate,
                   animation: .default
               )
    }
    
    var body: some View {
        List(filteredTodos) { task in
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
                    modelData.deleteInBackground(task: task, dataController: dataController) { }
                } label: {
                    Label("Удалить", systemImage: "arrow.up.trash")
                }
            }
        }
        .navigationDestination(for: Todo.self) { task in
            TodoDetailedView(todo: task, context: dataController.newBackgroundContext())
        }
        .listStyle(.plain)
    }
}

#Preview {
    let dataController = DataController()
    FilteredList(searchText: "")
        .environment(\.managedObjectContext, dataController.context)
        .environmentObject(dataController)
        .environmentObject(ModelData())
}
