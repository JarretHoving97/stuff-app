//
//  StuffStoreTests.swift
//  StuffStoreTests
//
//  Created by Jarret Hoving on 25/10/2024.
//

import Testing
@testable import The_Stuff_App

class StuffStore {
    
    private(set) var stuffItems: [StuffItem] = []
    
    enum Error: Swift.Error {
        case duplicate
        case sameName
    }
    
    func insert(_ items: [StuffItem]) async throws {
       try items.forEach { newItem in
           guard !stuffItems.contains(newItem) else { throw Error.duplicate }
           guard !stuffItems.map({$0.name}).contains(newItem.name) else { throw Error.sameName }
           stuffItems.append(newItem)
        }
    }
    
    func retrieve() async throws -> [StuffItem] {
        return stuffItems
    }
}

struct StuffStoreTests {
    
    let sut = StuffStore()
    
    @Test func doesNotHaveStuffOnCreation() async throws {
        assert(sut.stuffItems.isEmpty)
    }
    
    @Test func doesStoreItemWhenAdded() async throws {
        let sut = StuffStore()
        try await sut.insert([makeUniqueItem()])
        assert(!sut.stuffItems.isEmpty)
    }
    
    @Test func retrievesEmpty() async throws {
        let items = try await sut.retrieve()
        assert(items.isEmpty)
    }
    
    @Test func retrievesStoredItem() async throws {
        let item = makeUniqueItem()
        try await sut.insert([item])
        
        let items = try await sut.retrieve()
        assert(items == [item])
    }
    
    @Test func retrievesMultipleStoredItems() async throws {
        let items = makeUniqueItems()
        try await sut.insert(items)
        
        let retrievedItems = try await sut.retrieve()
        assert(retrievedItems == items)
    }
    
    @Test func errorsWhenAddingDuplicateItem() async throws {
        let item = makeUniqueItem()
        
        await #expect(throws: (StuffStore.Error.duplicate).self ) {
            try await sut.insert([item, item])
        }
        
        let items = try await sut.retrieve()
        assert(items.count == 1)
    }
    
    @Test func errorsWhenAddingItemWithSameName() async throws {
        let item1 = makeUniqueItem(with: "task 1")
        let item2 = makeUniqueItem(with: "task 1")
        
        await #expect(throws: (StuffStore.Error.sameName).self ) {
            try await sut.insert([item1, item2])
        }
        let items = try await sut.retrieve()
        assert(items.count == 1)
    }
    
    
    // MARK: Helpers
    
    private func makeUniqueItem(with name: String = "A task to do") -> StuffItem {
        StuffItem(color: .black, name: name)
    }
    
    private func makeUniqueItems() -> [StuffItem] {
        [makeUniqueItem(with: "a task"), makeUniqueItem(with: "anbother task")]
    }
}
