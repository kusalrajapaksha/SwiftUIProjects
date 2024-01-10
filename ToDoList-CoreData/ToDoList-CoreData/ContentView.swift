//
//  ContentView.swift
//  ToDoList-CoreData
//
//  Created by Kusal Rajapaksha on 2024-01-09.
//

import SwiftUI
import CoreData

struct ContentView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//    @FetchRequest(entity: ToDoItem.entity(),
//                  sortDescriptors: [NSSortDescriptor(keyPath: \ToDoItem.timestamp, ascending: false)])
//    var todoItems: FetchedResults<ToDoItem>
//    
    @StateObject var viewModel = ViewModel()
    @State private var showAddToDoView: Bool = false

    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Text("ToDo List")
                        .font(.largeTitle)
                    Spacer()
                    Button(action: {
                        showAddToDoView.toggle()
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 50,height: 50)
                    })
                    
                }.padding()
                List {
                    ForEach(viewModel.savedEntities, id: \.id) { item in
                        
                        ListItemView(viewModel: viewModel, item: item)

                    }
                    .onDelete(perform: viewModel.deleteTool)
                }
            }.padding(.bottom, 50)
            
            ToDoAddView(viewModel: viewModel)
                
        }
        
        
    }
    
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
