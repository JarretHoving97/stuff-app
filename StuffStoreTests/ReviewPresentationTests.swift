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
struct ReviewPresentationTests {
    
    @Test func appearsWithEmptyActions() {
        let sut = makeSUT()
        #expect(sut.actions.isEmpty)
    }
    
    @Test func hasStuffItemTitleToPresent() {
        let sut = makeSUT()
        #expect(!sut.itemTitle.isEmpty)
    }
    
    @Test func displaysAddActionsToDoTitleWhenNoActionsAreFound() {
        let sut = makeSUT()
        
        #expect(sut.motivationTitle == ReviewDashboardViewModel.NO_ACTIONS_TITLE)
    }
    
    @Test func displaysWhichActionsYouGonnaDoToday() {
        let sut = makeSUT(with: makeAllNonCompletedActions())
        #expect(sut.motivationTitle == ReviewDashboardViewModel.WHAT_ACTIONS_FOR_TODAY)
    }
    
    @Test func displaysAlmostCompletedTaskTitle() {
        let sut = makeSUT(with: makeAlmostCompletedActions())
        #expect(sut.motivationTitle == ReviewDashboardViewModel.TASK_ALMOST_DONE)
    }
    
    @Test func updatesTitleWhenActionsAreUpdated() async {
        let sut = makeSUT(with: makeAllNonCompletedActions())
        #expect(sut.motivationTitle == ReviewDashboardViewModel.WHAT_ACTIONS_FOR_TODAY)
        
        for action in sut.actions {
            await sut.setTaskCompleted(for: action.id, isCompleted: true)
        }
        
        #expect(sut.motivationTitle == ReviewDashboardViewModel.TASK_IS_COMPLETED)
    }
    
    @Test func updatesListWhenActionsAreUpdated() async {
        let item = makeUniqueAction(completed: false)
        let sut = makeSUT(with: [item])
        await sut.setTaskCompleted(for: item.id, isCompleted: true)
        
        #expect(sut.actions.allSatisfy { $0.isCompleted })
    }
    
    // MARK: Helpers
    private func makeSUT(with actions: [StuffActionModel] = []) -> ReviewDashboardViewModel {
        let stuffItem = StuffItem(color: .bg, name: "A Thing", actions: actions)
        return ReviewDashboardViewModel(item: stuffItem, actionLoader: StuffActionsLoaderStub(actions: actions))
    }
    
    func makeUniqueAction(completed: Bool) -> StuffActionModel {
        return StuffActionModel(id: UUID(), description: "A action", isCompleted: completed)
    }
    
    func makeAlmostCompletedActions() -> [StuffActionModel] {
        return [
            StuffActionModel(id: UUID(), description: "A action", isCompleted: true),
            StuffActionModel(id: UUID(), description: "A otherAction", isCompleted: true),
            StuffActionModel(id: UUID(), description: "A simple action", isCompleted: true),
            StuffActionModel(id: UUID(), description: "To do", isCompleted: true),
            StuffActionModel(id: UUID(), description: "No action", isCompleted: false),
        ]
    }
    
    func makeAllNonCompletedActions() -> [StuffActionModel] {
        return [
            StuffActionModel(id: UUID(), description: "A action", isCompleted: false),
            StuffActionModel(id: UUID(), description: "A otherAction", isCompleted: false),
            StuffActionModel(id: UUID(), description: "A simple action", isCompleted: false),
            StuffActionModel(id: UUID(), description: "To do", isCompleted: false),
            StuffActionModel(id: UUID(), description: "No action", isCompleted: false),
        ]
    }
    
    class StuffActionsLoaderStub: StuffActionStore {
      
        var actions: [StuffActionModel]
        
        init(actions: [StuffActionModel]) {
            self.actions = actions
        }
        
        func retrieve(for item: UUID) async throws -> [StuffActionModel] {
            return actions
        }
        
        func add(action: StuffActionModel, to item: UUID) async throws {
            actions.append(action)
        }
        
        func setCompleted(_ id: UUID, isCompleted: Bool) async throws {
            if let index = actions.firstIndex(where: {$0.id == id}) {
                actions[index].isCompleted = isCompleted
            }
        }
        
        func delete(action id: UUID) async throws {
            actions.removeAll(where: {$0.id == id})
        }
    }
}

