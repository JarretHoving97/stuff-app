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

    // TODO: Translations
    public static let NO_ACTIONS_TITLE = "Add actions to complete this task"
    public static let WHAT_ACTIONS_FOR_TODAY = "What actions do you want to take for today?"
    public static let TASK_ALMOST_DONE = "This task is almost done!"
    
    var itemTitle: String {
        return item.name
    }
    
    var actions: [StuffActionModel] {
        return item.actions
    }
    
    var motivationTitle: String {
        return motivationalTitle(for: item.actions)
    }
    
    private var item: StuffItem
    
    private var actionLoader: StuffActionStore?
    
    init(item: StuffItem, actionLoader: StuffActionStore?) {
        self.actionLoader = actionLoader
        self.item = item
    }
    
    private func motivationalTitle(for actions: [StuffActionModel]) -> String {
        if actions.isEmpty {
            return ReviewDashboardViewModel.NO_ACTIONS_TITLE
        }
        
        let completedCount = actions.filter { $0.isCompleted }
        let completedPercentage = Double(completedCount.count) / Double(actions.count) * 100
        
        if completedPercentage < 80 {
            return ReviewDashboardViewModel.WHAT_ACTIONS_FOR_TODAY
        }

        return ReviewDashboardViewModel.TASK_ALMOST_DONE
    }
}

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
    
    // MARK: Helpers
    private func makeSUT(with actions: [StuffActionModel] = []) -> ReviewDashboardViewModel {
        let stuffItem = StuffItem(color: .bg, name: "A Thing", actions: actions)
        return ReviewDashboardViewModel(item: stuffItem, actionLoader: StuffActionsLoaderStub(actions: actions))
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

