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
            LazyVStack(spacing: -40) {
                ForEach(viewModel.items) { item in
                    TaskView(item: item, animation: animation)
                        .matchedGeometryEffect(id: item.id, in: animation)
                        .onTapGesture {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ){
                                withAnimation(.spring(duration: 0.4, bounce: 0.2, blendDuration: 0.2)) {
                                    viewModel.selectedItem = item
                         
                                }
                            }
                        }
                }
            }
            .padding(.top, 40)
        }
        .background() {
            Color.white.ignoresSafeArea(.all)
        }
        .modal(bindable: $viewModel.selectedItem) { value in
            StuffDetailView(
                animation: animation,
                item: value,
                show: $viewModel.selectedItem.toBoolBinding
            )
            .transition(.asymmetric(insertion: .opacity, removal: .opacity))
        }
        

    }
}


#Preview {
    StuffListView(
        viewModel: StuffListViewModel(
            items: [
                StuffItem(color: .purple, name: "Call the dentist"),
                StuffItem(color: .blue, name: "Mail maintanance engineer back"),
                StuffItem(color: .brown, name: "Create mail invitation"),
            ]
        )
    )
}
