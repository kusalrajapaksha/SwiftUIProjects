//
//  DragSwapView.swift
//  DragSwapFeature
//
//  Created by Kusal Rajapaksha on 2024-01-05.
//

import SwiftUI

struct DragSwapView: View {
    
    @StateObject var viewModel = DragSwapViewModel()
    @State var draggedID: String?
    
    var body: some View {
        ScrollView{
            Grid(verticalSpacing: 10, content: {
                ForEach(viewModel.itemsIDArray, id: \.self) { id in
                    let item = viewModel.getItem(id: id)
                    CellView(backgroundColor: item.color, name: item.name)
                        .onDrag({
                            self.draggedID = id
                            return NSItemProvider()
                        }, preview: { })
                        .onDrop(of: [.text], delegate: DropViewDelegate(destinationItemID: id, idArray: $viewModel.itemsIDArray, draggedItemID: $draggedID))
                }
            })
            .frame(maxWidth: .infinity)
        }
        
    }
}

struct DropViewDelegate: DropDelegate {
    
    let destinationItemID: String
    @Binding var idArray: [String]
    @Binding var draggedItemID: String?
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        draggedItemID = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        // Swap Items
        if let draggedItemID {
            let fromIndex = idArray.firstIndex(of: draggedItemID)
            if let fromIndex {
                let toIndex = idArray.firstIndex(of: destinationItemID)
                if let toIndex, fromIndex != toIndex {
                    withAnimation {
                        self.idArray.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: (toIndex > fromIndex ? (toIndex + 1) : toIndex))
                    }
                }
            }
        }
    }
}


struct CellView: View {
    let backgroundColor: Color
    let name: String
    
    var body: some View {
        HStack{
            Text(name)
        }
        .background(.clear)
        .padding(30)
        .background(backgroundColor)
        .cornerRadius(8)
    }
}

#Preview {
    DragSwapView()
}
