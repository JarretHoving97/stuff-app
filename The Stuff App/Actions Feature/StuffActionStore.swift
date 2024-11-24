//
//  StuffActionStore.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 20/11/2024.
//

import Foundation

protocol StuffActionStore {
    func retrieve(for item: UUID) async throws -> [StuffActionModel]
    func add(action: StuffActionModel, to item: UUID) async throws
    func setCompleted(_ id: UUID, isCompleted: Bool) async throws
    func delete(action id: UUID) async throws
}


class MOCK_ACTION_STORE: StuffActionStore {
    
    var actions: [StuffActionModel] = [
        StuffActionModel(id: UUID(), description: "A task to do", isCompleted: false),
        StuffActionModel(id: UUID(), description: "A other tasks to do do", isCompleted: true),
        StuffActionModel(id: UUID(), description: "this task is completed", isCompleted: false),
    ]
    
    func retrieve(for item: UUID) async throws -> [StuffActionModel] {
        return actions
    }
    
    func add(action: StuffActionModel, to item: UUID) async throws {
        actions.insert(action, at: 0)
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
