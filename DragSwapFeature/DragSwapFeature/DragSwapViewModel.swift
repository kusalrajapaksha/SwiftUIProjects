//
//  DragSwapViewModel.swift
//  DragSwapFeature
//
//  Created by Kusal Rajapaksha on 2024-01-05.
//

import Foundation
import SwiftUI

struct Item{
    let id = UUID().uuidString
    var color: Color
    var name: String
}

class DragSwapViewModel: ObservableObject {
    
    @Published var itemsIDArray = [String]()
    var itemsArray = [Item]()
    
    init(){
        createItemArray()
    }
    
    func createItemArray(){
        itemsArray.append(Item(color: .red, name: "Item 1"))
        itemsArray.append(Item(color: .green, name: "Item 2"))
        itemsArray.append(Item(color: .blue, name: "Item 3"))
        itemsArray.append(Item(color: .yellow, name: "Item 4"))
        itemsArray.append(Item(color: .orange, name: "Item 5"))

        createItemsIDArray()
    }
    
    func createItemsIDArray(){
        itemsIDArray = itemsArray.map({$0.id})
    }
    
    func getItem(id: String) -> Item{
        return itemsArray.first(where: {$0.id == id})!
    }
}
