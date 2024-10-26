//
//  StuffStoreTests.swift
//  StuffStoreTests
//
//  Created by Jarret Hoving on 25/10/2024.
//

import Testing
import Foundation
@testable import The_Stuff_App

class StuffStore {
    
    private(set) var stuffItems: [StuffItem] = []
    
    enum Error: Swift.Error {
        case duplicate
        case sameName
        case notFound
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
    
    func delete(_ id: UUID) async throws {
        guard let index = stuffItems.firstIndex(where: {$0.id == id}) else { throw Error.notFound }
        stuffItems.remove(at: index)
    }
}

struct StuffStoreTests {
    
    let sut = StuffStore()
    
    @Test func doesNotHaveStuffOnCreation() async throws {
        try await expect(sut, toRetrieve: [])
    }
    
    @Test func retrievesEmpty() async throws {
        try await expect(sut, toRetrieve: [])
    }
    
    @Test func doesStoreItemWhenAdded() async throws {
        let sut = StuffStore()
        try await sut.insert([makeUniqueItem()])
        assert(!sut.stuffItems.isEmpty)
    }

    @Test func retrievesStoredItem() async throws {
        let item = makeUniqueItem()
        try await sut.insert([item])
        
        try await expect(sut, toRetrieve: [item])
    }
    
    @Test func retrievesMultipleStoredItems() async throws {
        let items = makeUniqueItems()
        try await sut.insert(items)
 
        try await expect(sut, toRetrieve: items)
    }
    
    @Test func errorsWhenAddingDuplicateItem() async throws {
        let item = makeUniqueItem()
        
        await #expect(throws: (StuffStore.Error.duplicate).self ) {
            try await sut.insert([item, item])
        }
        
        try await expect(sut, toRetrieve: [item])
    }
    
    @Test func errorsWhenAddingItemWithSameName() async throws {
        let item1 = makeUniqueItem(with: "task 1")
        let item2 = makeUniqueItem(with: "task 1")
        
        await #expect(throws: (StuffStore.Error.sameName).self ) {
            try await sut.insert([item1, item2])
        }
        try await expect(sut, toRetrieve: [item1])
    }
    
    @Test func retrievesEmptyWhenNoItemsFoundAfterDeleting() async throws {
        let sut = StuffStore()
        let item = makeUniqueItem()
        
        try await sut.insert([item])
        try await sut.delete(item.id)
        
        try await expect(sut, toRetrieve: [])
    }
    
    @Test func throwsErrorAfterDeletingNonExistingItem() async throws {
        let sut = StuffStore()
        let uniqueItems = makeUniqueItems()
        try await sut.insert(uniqueItems)
        
        await #expect(throws: (StuffStore.Error.notFound).self ) {
            try await sut.delete(UUID())
        }
        
       try await expect(sut, toRetrieve: uniqueItems)
    }

    // MARK: Helpers
    
    private func expect(_ sut: StuffStore, toRetrieve expectedStuff: [StuffItem], file: StaticString = #file, line: UInt = #line) async throws {
        let retrievedStuff = try await sut.retrieve()
        assert(retrievedStuff == expectedStuff, "Expected \(expectedStuff) but got \(retrievedStuff) instead", file: file, line: line)
    }
    
    private func makeUniqueItem(with name: String = "A task to do") -> StuffItem {
        StuffItem(color: .black, name: name)
    }
    
    private func makeUniqueItems() -> [StuffItem] {
        [makeUniqueItem(with: "a task"), makeUniqueItem(with: "anbother task")]
    }
}
