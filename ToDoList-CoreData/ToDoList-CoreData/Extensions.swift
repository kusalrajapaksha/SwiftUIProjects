//
//  Extensions.swift
//  ToDoList-CoreData
//
//  Created by Kusal Rajapaksha on 2024-01-10.
//

import Foundation
import SwiftUI

extension View{
    func placeholder<Content: View>(when shouldShow: Bool,alignment: Alignment = .leading,@ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

extension Color {
    
    init(hex: String, alpha: Double = 1) {
        var formattedHex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        if formattedHex.hasPrefix("#") {
            formattedHex.remove(at: formattedHex.startIndex)
        }
        
        var rgb: UInt64 = 0
        Scanner(string: formattedHex).scanHexInt64(&rgb)
        
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        
        self.init(
            .sRGB,
            red: red,
            green: green,
            blue: blue,
            opacity: alpha
        )
    }
    
}
