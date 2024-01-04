//
//  CustomSlider.swift
//  CustomSlider
//
//  Created by Kusal Rajapaksha on 2024-01-04.
//

import SwiftUI

struct CustomSlider: View {
    @State var value: Double = 50
    
    @State var minValue: Double = 0
    @State var maxValue: Double = 256
    
    @State var trackHeight: CGFloat = 4
    @State var thumbRadius: CGFloat = 12
    @State var thumbColor: Color = Color(.purple)
    @State var trackColor: Color = Color(.gray)
    @State var tintColor: Color = Color(.purple)
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack(alignment: .leading){
                //--Track
                RoundedRectangle(cornerRadius: trackHeight/2)
                    .fill(trackColor)
                    .frame(width: geometry.size.width, height: trackHeight)
                
                let xDistance = CGFloat((value - minValue)/(maxValue - minValue)) * geometry.size.width
                
                //--Tinted track
                RoundedRectangle(cornerRadius: trackHeight/2)
                    .fill(tintColor)
                    .frame(width: xDistance, height: trackHeight)
                    
                
                //--Thumb
                Circle()
                    .fill(thumbColor)
                    .frame(width: thumbRadius * 2)
                    .offset(x: xDistance - thumbRadius)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged({ gesture in
                                updateValue(with: gesture, in: geometry)
                            })
                    )
            }
            .padding(.top, (geometry.size.height - thumbRadius * 2) / 2)
        })
    }
    
    //--Update slider value when the thumb is dragging
    private func updateValue(with gesture: DragGesture.Value, in geometry: GeometryProxy) {
        let dragPortion = gesture.location.x / geometry.size.width
        let newValue = Double((maxValue - minValue) * dragPortion) + minValue
        value = min(max(newValue,minValue),maxValue)
    }
}

#Preview {
    CustomSlider()
}
