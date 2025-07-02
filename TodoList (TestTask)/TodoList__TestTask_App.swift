//
//  TodoList__TestTask_App.swift
//  TodoList (TestTask)
//
//  Created by Tatiana Kuvarzina on 18.06.2025.
//

import SwiftUI

@main
struct Todo_List__TestTask_App: App {
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore = false
    
    @StateObject private var dataController = DataController()
    @StateObject private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataController)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(modelData)
                .onAppear {
                    if !hasLaunchedBefore {
                        Task {
                            await modelData.loadAndImportTodos(using: dataController.context)
                            hasLaunchedBefore = true
                        }
                    }
                }
            
        }
    }
}
