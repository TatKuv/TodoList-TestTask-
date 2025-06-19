//
//  TodoList__TestTask_App.swift
//  TodoList (TestTask)
//
//  Created by Tatiana Kuvarzina on 18.06.2025.
//

import SwiftUI

@main
struct Todo_List__TestTask_App: App {
    @StateObject private var dataController = DataController()
    @StateObject private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(modelData)
        }
    }
}
