//
//  StuffStoreTests.swift
//  StuffStoreTests
//
//  Created by Jarret Hoving on 25/10/2024.
//

import Testing
import Foundation
@testable import The_Stuff_App

struct StuffStoreTests {
    
    let sut = try! CoreDataStuffStore(storeURL: URL(fileURLWithPath: "/dev/null"))
    
    @Test func doesNotHaveStuffOnCreation() async throws {
        try await expect(sut, toRetrieve: [])
    }
    
    @Test func retrievesEmpty() async throws {
        try await expect(sut, toRetrieve: [])
    }
    
    @Test func doesStoreItemWhenAdded() async throws {
        let item = makeUniqueItem()
        try await sut.insert(item)
        try await expect(sut, toRetrieve: [item])
    }

    @Test func retrievesStoredItem() async throws {
        let item = makeUniqueItem()
        try await sut.insert(item)
        
        try await expect(sut, toRetrieve: [item])
    }
    
    @Test func retrievesMultipleStoredItems() async throws {
        let items = makeUniqueItems()
        
        try await sut.insert(items[0])
        try await sut.insert(items[1])
        
        try await expect(sut, toRetrieve: items)
    }
    
    @Test func errorsWhenAddingDuplicateItem() async throws {
        let item = makeUniqueItem()
        let sameNameItem = StuffItem(id: item.id, color: .black, name: "an other name")
    
        await #expect(throws: (StuffStoreError.duplicate).self ) {
            try await sut.insert(item)
            try await sut.insert(sameNameItem)
        }
        
        try await expect(sut, toRetrieve: [item])
    }
    
    @Test func errorsWhenAddingItemWithSameName() async throws {
        let item1 = makeUniqueItem(with: "task 1")
        let item2 = makeUniqueItem(with: "task 1")
        
        await #expect(throws: (StuffStoreError.sameName).self ) {
            try await sut.insert(item1)
            try await sut.insert(item2)
        }
        try await expect(sut, toRetrieve: [item1])
    }

    @Test func retrievesEmptyWhenNoItemsFoundAfterDeleting() async throws {
        let item = makeUniqueItem()
        
        try await sut.insert(item)
        try await sut.delete(item.id)
        
        try await expect(sut, toRetrieve: [])
    }

    @Test func throwsErrorAfterDeletingNonExistingItem() async throws {
        let uniqueItems = makeUniqueItems()
        try await sut.insert(uniqueItems[0])
        try await sut.insert(uniqueItems[1])
        
        await #expect(throws: (StuffStoreError.notFound).self ) {
            try await sut.delete(UUID())
        }
        
       try await expect(sut, toRetrieve: uniqueItems)
    }
    
    @Test func updatesItem() async throws {
        let item = makeUniqueItem()
        
        try await sut.insert(item)
        
        var updatedItem = item
        updatedItem.name = "Updated task"
    
        
        try await sut.update(item.id, with: updatedItem)
        
        try await expect(sut, toRetrieve: [updatedItem])
    }
    
    @Test func retrievesNonUpdatedWhenUpdatingNonExistingItem() async throws {
        let item = makeUniqueItem()
        
        try await sut.insert(item)
        
        await #expect(throws: (StuffStoreError.notFound).self ) {
            try await sut.update(UUID(), with: item)
        }

        
        try await expect(sut, toRetrieve: [item])
    }
    
    @Test func hasEmptyActionsWhenCreatedStuffItem() async throws {
        let item = makeUniqueItem()
        
        try await sut.insert(item)
        
        try await expect(sut, toRetrieve: [], for: item)
    }
    
    @Test func hasNonEmptyActionsAfterAddedAction() async throws {
        let item = makeUniqueItem()
        try await sut.insert(item)
        
        let action = StuffActionModel(id: UUID(), description: "Something to do", isCompleted: false)
        
        try await sut.add(action: action, to: item.id)
        try await expect(sut, toRetrieve: [action], for: item)
    }
    
    @Test func storesMultipleActions() async throws {
        let item = makeUniqueItem()
        try await sut.insert(item)
        let localActions = makeUniqueActions()

        for action in localActions {
            try await sut.add(action: action, to: item.id)
        }
        try await expect(sut, toRetrieve: localActions, for: item)
    }

    @Test func didSetActionAsCompleted() async throws {
        let item = makeUniqueItem()
        try await sut.insert(item)
        
        let action = StuffActionModel(id: UUID(), description: "Something to do", isCompleted: false)
        
        try await sut.add(action: action, to: item.id)
        try await sut.setCompleted(action.id, isCompleted: true)
        
        let expectedResult = [StuffActionModel(id: action.id, description: action.description, isCompleted: true)]
        try await expect(sut, toRetrieve: expectedResult, for: item)
    }
    
    @Test func deletesAction() async throws {
        let item = makeUniqueItem()
        try await sut.insert(item)
        
        let action = StuffActionModel(id: UUID(), description: "Something to do", isCompleted: false)
        
        try await sut.add(action: action, to: item.id)
        try await sut.delete(action: action.id)
        
       try await expect(sut, toRetrieve: [], for: item)
    }

    // MARK: Helpers
    
    private func expect(_ sut: StuffStore, toRetrieve expectedStuff: [StuffItem], fileID: String = #fileID, filePath: String = #filePath, line: Int = #line, column: Int = #column) async throws {
        let retrievedStuff = try await sut.retrieve()
        #expect(retrievedStuff == expectedStuff, sourceLocation: SourceLocation(fileID: fileID, filePath: filePath, line: line, column: column))
    }
    
    private func expect(_ sut: StuffStore, toRetrieve expectedActions: [StuffActionModel], for stuffItem: StuffItem, fileID: String = #fileID, filePath: String = #filePath, line: Int = #line, column: Int = #column) async throws {
        let retrievedActions = try await sut.retrieve().first(where: {$0.id == stuffItem.id})?.actions
        #expect(retrievedActions == expectedActions, sourceLocation: SourceLocation(fileID: fileID, filePath: filePath, line: line, column: column))
    }
    
    private func makeUniqueItem(with name: String = "A task to do") -> StuffItem {
        StuffItem(color: .black, name: name)
    }
    
    private func makeUniqueItems() -> [StuffItem] {
        [makeUniqueItem(with: "a task"), makeUniqueItem(with: "anbother task")]
    }
    
    private func makeUniqueActions() -> [StuffActionModel] {
        return [
            StuffActionModel(id: UUID(), description: "Something to do", isCompleted: false),
            StuffActionModel(id: UUID(), description: "Something else to do", isCompleted: false),
            StuffActionModel(id: UUID(), description: "Something to do tomorrow", isCompleted: false),
            StuffActionModel(id: UUID(), description: "Something to do today", isCompleted: false),
        ]
    }
}

