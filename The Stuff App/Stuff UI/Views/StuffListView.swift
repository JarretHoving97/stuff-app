//
//  StuffListView.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 24/10/2024.
//


import SwiftUI

struct StuffListView: View {
    
    var viewModel: StuffListViewModel
    
    @State private var presentSheet: Bool = false
    @State private var selectedItem: StuffItem?
    @State private var showDetail: Bool = false
    
    @State private var detailEnabled: Bool = true
    
    @Namespace private var animation
    
    var body: some View {
        
        ZStack(alignment: .bottomTrailing) { // Set alignment to bottomTrailing
            
            if let selectedItem = viewModel.selectedItem, showDetail {
                
                StuffDetailView(
                    viewModel: StuffActionViewModel(item: selectedItem),
                    onClose: {
                        detailEnabled = false
                        withAnimation(.spring(duration: 0.2)) {
                            showDetail.toggle()
                        }
                    },
                    animation: animation
                )
                .onDisappear {
                    detailEnabled = true
                }
                
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(viewModel.items, id: \.self) { item in
                            CardView(title: item.name)
                                .matchedGeometryEffect(id: item.id, in: animation)
                                .contextMenu {
                                    Button {
                                        Task {
                                            await viewModel.delete(item.id)
                                            await viewModel.retrieve()
                                        }
                                        
                                    } label: {
                                        Label("Delete", systemImage: "xmark")
                                    }
                                }
                                .onTapGesture {
                                    guard detailEnabled else { return }
                                    
                                    viewModel.selectItem(item: item)
                                    withAnimation(.spring(duration: 0.4, bounce: 0.2, blendDuration: 0.0)) {
                                        showDetail.toggle()
                                    }
                            }
                        }
                    }
                    .padding()
                    .animation(.default, value: viewModel.items)
                }
                
                Button {
                    presentSheet.toggle()
                } label: {
                    ZStack {
                        Color("item_secondary_color")
                        Image(systemName: "plus")
                            .tint(.white)
                    }
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                }
                .padding(10)
                
                
                .sheet(isPresented: $presentSheet) {
                    AddStuffItemView(
                        presentSheet: $presentSheet) { name in
                            Task {
                                await viewModel.add(StuffItem(id: UUID(), color: .bg, name: name))
                            }
                        }
                        .presentationDetents([.height(120)])
                        .onDisappear {
                            Task {
                                await viewModel.retrieve()
                            }
                        }
                }
                .task {
                    await viewModel.retrieve()
                }
                
                
            }
        }
        .background(
            Color("bg_color")
                .ignoresSafeArea(.all)
        )
    }
}

#Preview {
    
    StuffListView(
        viewModel: StuffListViewModel(
            store: MOCK_STORE()
        )
    )
}


