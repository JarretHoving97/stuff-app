//
//  ReviewDashboardViewModel.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 24/11/2024.
//

import SwiftUI

@MainActor
@Observable
public class ReviewDashboardViewModel {

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
    
    public func addNewsTask(description: String) async {
        let item = StuffActionModel(id: UUID(), description: description, isCompleted: false)
        try? await actionLoader?.add(action: item, to: item.id)
        actions.insert(item, at: 0)
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
        withAnimation {
            self.setTilteView(with: actions ?? [])
            self.actions = actions ?? []
        }
    }
    
    private func setTilteView(with actions: [StuffActionModel]) {
        motivationTitle = motivationalTitle(for: actions)
    }
}
