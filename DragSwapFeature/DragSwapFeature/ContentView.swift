//
//  ContentView.swift
//  DragSwapFeature
//
//  Created by Kusal Rajapaksha on 2024-01-05.
//

import SwiftUI

struct ContentView: View {
    
    @State var dragOffset: CGSize = .zero
    

    var body: some View {
        VStack{
            DragSwapView()
        }
        
    }
}

#Preview {
    ContentView()
}
