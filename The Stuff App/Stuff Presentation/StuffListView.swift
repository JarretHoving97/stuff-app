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
        withAnimation(.spring(duration: 0.4, bounce: 0.2, blendDuration: 0.2)) {
            selectedItem = item
        }
    }
    
    func retrieve(for date: Date = Date()) async {
        let stuff = try? await store.retrieve()
        self.items = stuff?
            .filter { item in return date.isInPastOrToday(date: item.rememberDate) } ?? []
    }
    
    func delete(_ item: UUID) async {
        try? await store.delete(item)
    }
}


struct StuffListView: View {
    
    var viewModel: StuffListViewModel
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) { // Set alignment to bottomTrailing
            ScrollView {
                VStack(spacing: 20) {
                    cardView
                    cardView
                    cardView
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color("bg_color")
                    .ignoresSafeArea(.all)
            )
            
            Button {
                print("tapped")
            } label: {
                ZStack {
                    Color("item_secondary_color")
                    Image(systemName: "plus")
                        .tint(.white)
                }
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            }
            .padding() // Add padding to move it away from the screen edges
        }

    }
    
    
    
    var cardView: some View {
        ZStack {
            Text("Hello there!")
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .font(.headline)
                .lineLimit(4, reservesSpace: true)
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .background(Color("item_primary_color"))
        .cornerRadius(14)
 
   
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
        guard let date else { return true}
        return date.isInSame(.day, as: self) || self >= date
    }
    
    public func isInSame(_ component: Calendar.Component, as date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: component)
    }
}
