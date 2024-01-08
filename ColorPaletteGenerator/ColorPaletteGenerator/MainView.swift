//
//  MainView.swift
//  ColorPaletteGenerator
//
//  Created by Kusal Rajapaksha on 2024-01-07.
//

import SwiftUI

struct MainView: View {
    
    @State private var openCameraView: Bool = false
    
    var body: some View {
        HStack{
            Button(action: {
                
            }, label: {
                Text("Gallery")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            })
            
            Button(action: {
                openCameraView.toggle()
            }, label: {
                Text("Camera")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            })
        }
        
        .fullScreenCover(isPresented: $openCameraView, content: {
            CameraView()
        })
    }
}

#Preview {
    MainView()
}
