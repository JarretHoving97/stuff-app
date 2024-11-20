//
//  StuffStore.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 26/10/2024.
//

import Foundation

enum StuffStoreError: Swift.Error {
    case duplicate
    case sameName
    case notFound
}

protocol StuffStore {
    func insert(_ item: StuffItem) async throws
    func retrieve() async throws -> [StuffItem]
    func delete(_ id: UUID) async throws
    func update(_ id: UUID, with item: StuffItem) async throws
    
    func add(action: StuffActionModel, to item: UUID) async throws
    func setCompleted(_ id: UUID, isCompleted: Bool) async throws
    func delete(action id: UUID) async throws
}
