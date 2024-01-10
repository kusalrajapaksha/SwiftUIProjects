//
//  ToDoAddView.swift
//  ToDoList-CoreData
//
//  Created by Kusal Rajapaksha on 2024-01-09.
//

import SwiftUI

struct ToDoAddView: View {
    
    @ObservedObject var viewModel: ViewModel
    @State private var todoTitle: String = ""
    @FocusState private var isFocused: Bool
    @Environment(\.managedObjectContext) private var viewContext


    var body: some View {
        VStack(spacing: 0){
            
            if isFocused{
                Color.gray.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture { location in
                        isFocused = false
                    }
            }else{
                Color.clear
            }
           

            ZStack{
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue.opacity(0.1))
                    .overlay {
                        HStack{
                            TextField("", text: $todoTitle, onEditingChanged: searchTextFieldGetFocus)
                                .placeholder(when: todoTitle.isEmpty, placeholder: {
                                    Text("Add task")
                                        .foregroundColor(Color.gray.opacity(0.8))
                                })
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .focused($isFocused)
                                .onSubmit {
                                    addItem()
                                }
                            
                            Circle()
                                .fill(Color.blue)
                                .overlay {
                                    Image(systemName: "arrow.up")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .padding(10)
                                }
                                .onTapGesture {
                                    withAnimation(.bouncy) {
                                        addItem()
                                    }
                                    
                                }
                        }
                        
                        
                    }
                    .padding(8)
            }
            .frame(height: 60)
            .background(Color.black)
                
        }
        .presentationDetents([.height(50)])
    }
    
    private func searchTextFieldGetFocus(focused:Bool) {
        if focused{
            
        }else{
            
        }
    }
    
    private func addItem() {
        
        if !todoTitle.isEmpty{
            withAnimation {
                viewModel.addItem(title: todoTitle)
            }
            todoTitle = ""
        }
        
        
    }
    
}

#Preview {
    ToDoAddView(viewModel: ViewModel())
}
