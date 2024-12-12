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
            
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(viewModel.items, id: \.self) { item in
                        
                        NavigationLink {
                            ReviewDashboardView(viewModel: ReviewDashboardViewModel(
                                item: item,
                                actionLoader: MOCK_ACTION_STORE()
                                )
                            )
                        } label: {
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
                        }
                    }
                }
            }
            .padding()
            .animation(.default, value: viewModel.items)
            
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color("bg_color")
                .ignoresSafeArea(.all)
        )
        
        .navigationTitle("")
    }
}

#Preview {
    
    NavigationStack {
        StuffListView(
            viewModel: StuffListViewModel(
                store: MOCK_STORE()
            )
        )
    }

}


