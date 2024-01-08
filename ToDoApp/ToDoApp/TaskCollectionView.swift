//
//  TaskCollectionView.swift
//  ToDoApp
//
//  Created by Kusal Rajapaksha on 2024-01-06.
//

import SwiftUI

enum TaskDateItem: String{
    case Today = "Today"
    case Tomorrow = "Tomorrow"
    case Upcoming = "Upcoming"
}

enum TaskStatusType: String{
    case All = "All"
    case Completed = "Completed"
    case Pending = "Pending"
    case Missed = "Missed"
}

struct TaskCollectionView: View {
    
    @StateObject var viewModel = ToDoCollectionViewModel()
    
    @State private var taskDateTypeArray: [TaskDateItem] = [.Today, .Tomorrow, .Upcoming]
    @State private var taskStatusTypeArray: [TaskStatusType] = [.All, .Completed, .Pending, .Missed]
    
    @State var toDoList: [String] = ["Hi", "Shopping", "Studying"]
    
    @State private var selectedTaskDateType: Int = 0
    @State private var selectedTaskStatusTypeArray: Int = 0


    var body: some View {
        VStack {
            VStack{
                HStack{
                    Text("Tasks List")
                        .font(.largeTitle)
                        .foregroundStyle(Color.white)
                        
                    Spacer()
                    
                    Button(action: {}, label: {
                        Image(systemName: "plus")
                            .padding(8)
                            .background {
                                Circle()
                                    .stroke(Color.white, style: StrokeStyle(lineWidth: 4))
                                    .fill(Color.black)
                                   
                            }
                            .foregroundColor(Color.white)
                    })
                }
                
                Spacer().frame(height: 10)
                
                HStack{
                    
                    ForEach(0..<taskDateTypeArray.count, id: \.self){index in
                        let item = taskDateTypeArray[index]
                        Button(action: {
                            selectedTaskDateType = index
                        }, label: {
                            Text(item.rawValue)
                                .font(.system(size: 20))
                                .foregroundStyle(Color.white)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .background {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(selectedTaskDateType == index ? Color.blue : Color.green)
                                }
                        })
                        
                        if index < taskDateTypeArray.count - 1{
                            Spacer()
                        }
                       
                    }
                    
                }
                
                Spacer().frame(height: 10)
                
                HStack{
                    
                    ForEach(0..<taskStatusTypeArray.count, id: \.self){index in
                        let item = taskStatusTypeArray[index]
                        Button(action: {
                            selectedTaskStatusTypeArray = index
                        }, label: {
                            Text(item.rawValue)
                                .font(.system(size: 14))
                                .foregroundStyle(Color.white)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .background {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(selectedTaskStatusTypeArray == index ? Color.blue : Color.green)
                                }
                            
                        })
                        
                        if index < taskStatusTypeArray.count - 1{
                            Spacer()
                        }
                    }
                }
                
                Spacer().frame(height: 10)
                
                List {
                    ForEach(viewModel.todos, id: \.self) { todo in
                        Text(todo.title)
                    }
                }
                .frame(maxWidth:.infinity)
                .background(.clear)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            
            
        }
        .background(LinearGradient(colors: [.purple, .black, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
        
        
        
    }
}

#Preview {
    TaskCollectionView()
}
