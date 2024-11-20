//
//  StuffListViewModel.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 20/11/2024.
//

import SwiftUI

@MainActor
@Observable
class StuffListViewModel {
    
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
