//
//  ListItemView.swift
//  ToDoList-CoreData
//
//  Created by Kusal Rajapaksha on 2024-01-10.
//

import SwiftUI

struct ListItemView: View {
    
    @ObservedObject var viewModel: ViewModel
    var item: ToDoItem
    @State var isChecked: Bool = false
    
    init(viewModel: ViewModel, item: ToDoItem) {
        self.viewModel = viewModel
        self.item = item
    }
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(item.title ?? "")
                Text(item.timestamp?.description ?? "")
                    .font(.caption)
            }
            
            Spacer()
            
            CheckBox(isChecked: $isChecked)
                .frame(width: 30, height: 30)
                .onChange(of: isChecked) { newValue in
                    viewModel.updateItem(of: item.id ?? "", isCompleted: newValue)
                }
                .onAppear(perform: {
                    isChecked = item.isCompleted
                })

        }
    }
    
}

#Preview {
    ListItemView(viewModel: ViewModel(), item: ToDoItem())
}
