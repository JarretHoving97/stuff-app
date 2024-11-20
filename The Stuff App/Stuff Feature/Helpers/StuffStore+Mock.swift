//
//  StuffStore+Mock.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 20/11/2024.
//
import Foundation

class MOCK_STORE: StuffStore {
 
    var items = [StuffItem]()
    
    init() {
        items = [
            StuffItem(color: .accentColor, name: "Plan a meeting with the engineering team"),
            StuffItem(id: UUID(), color: .gray, name: "Prepare AppStore Connect presentation."),
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

    func update(_ id: UUID, with item: StuffItem) async throws {}
}
