//
//  StuffListView.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 24/10/2024.
//


import SwiftUI


@MainActor
@Observable class StuffListViewModel {
    
    private(set) var items = [StuffItem]()
    
    var selectedItem: StuffItem?
    
    var store: StuffStore
    
    init(store: StuffStore) {
        self.store = store
    }
    
    func selectItem(item: StuffItem) {
        selectedItem = item
    }
    
    func removeItem() {
        selectedItem = nil
    }
    
    func retrieve(for date: Date = Date()) async {
        let stuff = try? await store.retrieve()
        self.items = stuff?
            .filter { item in return date.isInPastOrToday(date: item.rememberDate) } ?? []
    }
    
    func delete(_ item: UUID) async {
        try? await store.delete(item)
    }
    
    func add(_ item: StuffItem) async {
        try? await store.insert(item)
    }
}


struct StuffListView: View {
    
    var viewModel: StuffListViewModel
    
    @State private var presentSheet: Bool = false
    @State private var selectedItem: StuffItem?
    
    @State private var showDetail: Bool = false
    
    @Namespace private var animation
    
    var body: some View {
        
        ZStack(alignment: .bottomTrailing) { // Set alignment to bottomTrailing
            
            if let selectedItem = viewModel.selectedItem, showDetail {
                StuffActionView(viewModel: .init(item: selectedItem), animation: animation, onClose: {
                    withAnimation(.spring(duration: 0.6, bounce: 0.2, blendDuration: 0.2)) {
                        showDetail.toggle()
                    }
                })
            } else {
                ScrollView {
                    LazyVStack(spacing: 20) {
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
                                    viewModel.selectItem(item: item)
                                    
                                    withAnimation(.spring(duration: 0.4, bounce: 0.2, blendDuration: 0.2)) {
                                        showDetail.toggle()
                                    }
                                    
                                }
                            
                        }
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    Color("bg_color")
                        .ignoresSafeArea(.all)
                )
           
                
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
                    StuffFormView(
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
                
                .animation(.default, value: viewModel.items)
                }
            }
    }
}

struct CardView: View {
    
    let title: String
    
    var body: some View {
        ZStack {
            Text(title)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .font(.headline)
                .lineLimit(4, reservesSpace: false)
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color("item_primary_color"))
        .cornerRadius(14)
        
    }
}


struct StuffFormView: View {
    
    @State private var name: String = ""
    @Binding var presentSheet: Bool
    
    var onAddButtonTapped: ((String) -> Void)
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                Button("add") {
                    onAddButtonTapped(name)
                    presentSheet.toggle()
                }
            }
            
            TextField("", text: $name)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
                .padding()
                .background(Color.black.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            
        }
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("item_secondary_color"))
    }
}

#Preview {
    
    StuffListView(
        viewModel: StuffListViewModel(
            store: MockStore()
        )
    )
}


extension Date {
    
    public func isInPastOrToday(date: Date?) -> Bool {
        guard let date else { return true }
        return date.isInSame(.day, as: self) || self >= date
    }
    
    public func isInSame(_ component: Calendar.Component, as date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: component)
    }
}
