//
//  PaletteView.swift
//  ColorPaletteGenerator
//
//  Created by Kusal Rajapaksha on 2024-01-07.
//

import SwiftUI

struct PaletteView: View {
    
    @Binding var colorArray: [Color]
                                      
    var body: some View {
        if colorArray.count == 9{
            VStack(spacing: 0){
                HStack(spacing: 0) {
                    Rectangle().fill(colorArray[0])
                    Rectangle().fill(colorArray[1])
                    Rectangle().fill(colorArray[2])
                }
                HStack(spacing: 0) {
                    Rectangle().fill(colorArray[3])
                    Rectangle().fill(colorArray[4])
                    Rectangle().fill(colorArray[5])
                }
                HStack(spacing: 0) {
                    Rectangle().fill(colorArray[6])
                    Rectangle().fill(colorArray[7])
                    Rectangle().fill(colorArray[8])
                }
            }
        }
    }
}

#Preview {
    PaletteView(colorArray: Binding.constant([]))
}
