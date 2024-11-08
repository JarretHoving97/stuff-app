//
//  ContentView.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 24/10/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        StuffListView(
            viewModel: StuffListViewModel(
                store: MockStore()
            )
        )
    }
}

#Preview {
    ContentView()
}


class MockStore: StuffStore {
    
    var items = [StuffItem]()
    
    init() {
        items = [
            StuffItem(color: .accentColor, name: "Yes"),
            StuffItem(id: UUID(), color: .gray, name: "Noo i dont want to do this"),
        ]
    }
    
    func insert(_ item: StuffItem) async throws {
        items.append(item)
    }
    
    func retrieve() async throws -> [StuffItem] {
        return items
    }
    
    func delete(_ id: UUID) async throws {
        items.removeAll(where: {$0.id == id})
    }
    
    func update(_ id: UUID, with item: StuffItem) async throws {
        
    }
}
