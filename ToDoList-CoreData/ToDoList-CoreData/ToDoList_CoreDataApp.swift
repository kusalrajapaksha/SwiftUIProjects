//
//  ToDoList_CoreDataApp.swift
//  ToDoList-CoreData
//
//  Created by Kusal Rajapaksha on 2024-01-09.
//

import SwiftUI

@main
struct ToDoList_CoreDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
