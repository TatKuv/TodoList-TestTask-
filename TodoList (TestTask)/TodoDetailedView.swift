//
//  TodoDetailedView.swift
//  TodoList (TestTask)
//
//  Created by Tatiana Kuvarzina on 19.06.2025.
//

import SwiftUI

struct TodoDetailedView: View {
   // @Environment(\.managedObjectContext) var moc
    
    var todo: Todo? //Сделать не опциональным и для новой задачи передавать "новый объект" - тогда Техты будут заменены на Техт филды
    
    @State private var title = ""
    @State private var taskDescription = ""

    
    var dateStr: String {
        let date = todo?.date ?? Date.now
            return date.formatted(date: .numeric, time: .omitted)
    }
    
    
    var body: some View {
        
        NavigationView {
        
            VStack (alignment: .leading, spacing: 20) {
                Text(todo?.todo ?? "Задача 121")
                    .font(.largeTitle)
                    .bold()
                Text(dateStr)
                    .font(.caption)
                    .opacity(0.8)
                Text(todo?.taskDescription ?? " Give me task" )
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    TodoDetailedView()
}
