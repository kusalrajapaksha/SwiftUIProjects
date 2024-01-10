//
//  CheckBox.swift
//  ToDoList-CoreData
//
//  Created by Kusal Rajapaksha on 2024-01-10.
//

import SwiftUI

struct CheckBox: View {
    
    @Binding var isChecked: Bool
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(Color.black, lineWidth: 2)
                .background(RoundedRectangle(cornerRadius: 8).fill(isChecked ? Color.black : Color.clear))
                .overlay {
                    Image(systemName: "checkmark")
                        .scaledToFit()
                        .padding()
                        .foregroundColor(isChecked ? .white : .clear)
                }
                
        }
        .onTapGesture {
            isChecked.toggle()
        }
    }
}

#Preview {
    CheckBox(isChecked: Binding.constant(false))
}
