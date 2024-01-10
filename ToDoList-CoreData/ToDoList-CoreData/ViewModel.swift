//
//  ViewModel.swift
//  ToDoList-CoreData
//
//  Created by Kusal Rajapaksha on 2024-01-10.
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
        
    let container = PersistenceController.shared.container
    
    @Published var savedEntities: [ToDoItem] = []
    
    init() {
        fetchItems()
    }
    
    func fetchItems() {
        let request = ToDoItem.fetchRequest()

        do {
            savedEntities = try container.viewContext.fetch(request)
            savedEntities = savedEntities.sorted(by: { item1, item2 in
                item1.timestamp! > item2.timestamp!
            })
        } catch let error {
               print("Error fetching \(error)")
        }
    }
    
    
    func addItem(title: String) {
        let newItem = ToDoItem(context: container.viewContext)
        newItem.id = UUID().uuidString
        newItem.title = title
        newItem.timestamp = Date()
        newItem.isCompleted = false
        saveData()
    }
    
    func deleteTool(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let entity = savedEntities[index]
        container.viewContext.delete(entity)
        saveData()
            
    }
    
    func updateItem(of id: String, isCompleted: Bool) {
        guard let itemInSaved = savedEntities.first(where: {$0.id == id}) else {return}
        itemInSaved.isCompleted = isCompleted
        saveData()
    }

        
    func saveData() {
        do {
            try container.viewContext.save()
            fetchItems()
        } catch let error {
            print("Error saving. \(error)")
        }
    }
        

}
