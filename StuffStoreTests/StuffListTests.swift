//
//  StuffListTests.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 07/11/2024.
//

import Testing
import Foundation
@testable import The_Stuff_App
import SwiftUI



@MainActor
struct StuffListTests {
    
    private func makeSUT() -> (sut: StuffListViewModel, store: StuffStoreSpy ) {
        let store = StuffStoreSpy()
        
        let sut = StuffListViewModel(store: store)
        
        return (sut, store)
    }
    
    @Test func doesNotLoadStuffOnInit() {
        let (sut, _) = makeSUT()
        
        #expect(sut.items.isEmpty)
    }
    
    @Test func doesRetrieveStuff() async throws {
        let (sut, store) = makeSUT()
        await sut.retrieve()
        #expect(store.messages == [.retrieve])
    }
    
    
    @Test func loadsStuffFromStore() async throws {
        let (sut, store) = makeSUT()
        let stuffItem = makeStuffItem()
        
        try await store.insert(stuffItem)
        await sut.retrieve()
        
        
        #expect(store.messages == [.insert(stuffItem), .retrieve])
        #expect(sut.items == [stuffItem])
    }
    
    @Test func doesDeleteStuffITem() async throws {
        let (sut, store) = makeSUT()
        
        let item = makeStuffItem()
        try await store.insert(item)
        
        await sut.delete(item.id)
        
        #expect(store.messages == [.insert(item), .delete(item.id)])
        #expect(sut.items.isEmpty)
    }
    
    @Test func doesNotShowStuffWhereRememberDateIsInFuture() async throws {
        let (sut, store) = makeSUT()
        let rememberedStuffItem = makeRemindedStuffItem()
        
        try await store.insert(rememberedStuffItem)
        await sut.retrieve()
        
        #expect(sut.items == [])
    }
    
    @Test func doesShowStuffWhereRememberDateIsPassed() async throws {
        let (sut, store) = makeSUT()
        let rememberedStuffItem = makeRemindedStuffItem()
        
        try await store.insert(rememberedStuffItem)
        await sut.retrieve(for: Date().adding(days: 2))
        
        #expect(sut.items == [rememberedStuffItem])
    }
    
    
    @Test func doesShowStuffThatHasNoRememberDateSet() async throws {
        let (sut, store) = makeSUT()
        let stuffItem = makeStuffItem()
        
        try await store.insert(stuffItem)
        await sut.retrieve()
        
        #expect(sut.items == [stuffItem])
    }
    
    func makeStuffItem() -> StuffItem {
        StuffItem(id: UUID(), color: .red, name: "Something todo")
    }
    
    func makeRemindedStuffItem(for rememberData: Date = Date().adding(days: 1)) -> StuffItem {
        StuffItem(id: UUID(), color: .green, name: "Future Item", createdAt: Date(), state: "TODO", rememberDate: rememberData)
    }
    
    
    class StuffStoreSpy: StuffStore {
        
        enum ReceivedMessage: Equatable {
            case update(UUID, StuffItem)
            case insert(StuffItem)
            case delete(UUID)
            case retrieve
        }
        
        private(set) var messages = [ReceivedMessage]()
        
        private(set) var feed = [StuffItem]()
        
        func insert(_ item: StuffItem) async throws {
            feed.append(item)
            messages.append(.insert(item))
        }
        
        func retrieve() async throws -> [StuffItem] {
            messages.append(.retrieve)
            return feed
        }
        
        func delete(_ id: UUID) async throws {
            messages.append(.delete(id))
        }
        
        func update(_ id: UUID, with item: StuffItem) async throws {
            messages.append(.update(id, item))
        }
    }
}


extension Date {
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }

    func adding(minutes: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .minute, value: minutes, to: self)!
    }

    func adding(days: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .day, value: days, to: self)!
    }

}
