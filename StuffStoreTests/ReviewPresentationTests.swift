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
    public static let TASK_IS_COMPLETED = "Great Job, You've completed this task!"
    
    var itemTitle: String {
        return item.name
    }
    
    var motivationTitle: String = ""
    
    private(set) var actions: [StuffActionModel]
    
    private var item: StuffItem
    
    private var actionLoader: StuffActionStore?
    
    init(item: StuffItem, actionLoader: StuffActionStore?) {
        self.actionLoader = actionLoader
        self.actions = item.actions
        self.item = item
        
        setTilteView(with: actions)
    }
    
    public func setTaskCompleted(for action: UUID, isCompleted: Bool) async {
        try? await actionLoader?.setCompleted(action, isCompleted: isCompleted)
        await reload()
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
        
        if completedPercentage == 100 {
            return ReviewDashboardViewModel.TASK_IS_COMPLETED
        }

        return ReviewDashboardViewModel.TASK_ALMOST_DONE
    }
    
 
    private func reload() async {
        let actions = try? await actionLoader?.retrieve(for: item.id)
        self.setTilteView(with: actions ?? [])
        self.actions = actions ?? []
    }
    
    private func setTilteView(with actions: [StuffActionModel]) {
        motivationTitle = motivationalTitle(for: actions)
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

