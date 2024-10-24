//
//  StuffListView.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 24/10/2024.
//


import SwiftUI

@Observable
class StuffListViewModel {
    
    private(set) var items: [StuffItem]
    
    var selectedItem: StuffItem?
    
    init(items: [StuffItem]) {
        self.items = items
    }
}

struct StuffListView: View {
    
    @Namespace private var animation
    
    @State private var viewModel: StuffListViewModel
    
    init(viewModel: StuffListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        ScrollView {
            VStack {
                ForEach(viewModel.items) { item in
                    TaskView(item: item, animation: animation)
                        .matchedGeometryEffect(id: item, in: animation)
                    
                        .onTapGesture {
                            withAnimation(.linear(duration: 0.2)) {
                                viewModel.selectedItem = item
                     
                            }
                        }
                }
            }
            .padding(.top, 0)
        }

    }
}


#Preview {
    StuffListView(
        viewModel: StuffListViewModel(
            items: [
                StuffItem(color: .black, name: "Call the dentis"),
                StuffItem(color: .black, name: "Mail maintanance engineer back"),
                StuffItem(color: .black, name: "Create mail invitation"),
            ]
        )
    )
}
