//
//  ReviewPresentationTests.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 20/11/2024.
//

import Testing
import SwiftUI
@testable import The_Stuff_App

@MainActor
@Observable
class ReviewDashboardViewModel {
    
    var actions: [StuffActionModel] {
        return item.actions
    }
    
    private var item: StuffItem
    
    private var actionLoader: StuffActionStore?
    
    init(item: StuffItem, actionLoader: StuffActionStore?) {
        self.actionLoader = actionLoader
        self.item = item
    }

}
@MainActor
struct ReviewPresentationTests {
    
    private func makeSUT() -> ReviewDashboardViewModel {
        let stuffItem = StuffItem(color: .bg, name: "A Thing")
        return ReviewDashboardViewModel(item: stuffItem, actionLoader: StuffActionLoaderSpy())
    }
    
    @Test func appearsWithEmptyActions() {
        let sut = makeSUT()
        #expect(sut.actions.isEmpty)
    }
    
    // MARK: Helpers
    class StuffActionLoaderSpy: StuffActionStore {
        
        func add(action: StuffActionModel, to item: UUID) async throws {}
        
        func setCompleted(_ id: UUID, isCompleted: Bool) async throws {}
        
        func delete(action id: UUID) async throws {}
    }
}

