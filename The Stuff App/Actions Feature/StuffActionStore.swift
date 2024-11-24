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
