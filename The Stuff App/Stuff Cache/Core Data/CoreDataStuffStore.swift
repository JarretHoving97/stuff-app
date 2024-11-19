//
//  Untitled.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 26/10/2024.
//

import CoreData

class CoreDataStuffStore: StuffStore {

    private static let modelName = "Stuff"
    private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: CoreDataStuffStore.self))
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
    }
    
    private func cleanUpReferencesToPersistentStores() {
        context.performAndWait {
            let coordinator = self.container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }
    
    deinit {
        cleanUpReferencesToPersistentStores()
    }
    
    public init(storeURL: URL) throws {
        
        guard let model = CoreDataStuffStore.model else {
            throw StoreError.modelNotFound
        }
        
        do {
            container = try NSPersistentContainer.load(name: CoreDataStuffStore.modelName, model: model, url: storeURL)
            context = container.newBackgroundContext()
        } catch {
            throw StoreError.failedToLoadPersistentContainer(error)
        }
    }
    
    
    func insert(_ item: StuffItem) async throws {
        
        let existingItems = try ManagedStuffItem.find(in: context) ?? []
        
        if existingItems.map({$0.name}).contains(item.name) {
            throw StuffStoreError.sameName
        }
        
        if existingItems.map({$0.id}).contains(item.id) {
            throw StuffStoreError.duplicate
        }
        
        let managedItem = ManagedStuffItem(context: context)
        managedItem.id = item.id
        managedItem.createdAt = item.createdAt
        managedItem.rememberDate = item.rememberDate
        managedItem.state = item.state
        managedItem.name = item.name
        
        try context.save()
        
    }
    
    func retrieve() async throws -> [StuffItem] {
        guard let items = try ManagedStuffItem.find(in: context) else { throw StoreError.modelNotFound }
        return items.map { StuffItem(id: $0.id, color: .black, name: $0.name, createdAt: $0.createdAt, state: $0.state, rememberDate: $0.rememberDate, actions: LocalActionsMapper.mapToLocal(managedActions: $0.actions?.compactMap {$0 as? ManagedStuffAction} ?? [])) }

    }

    
    func update(_ id: UUID, with item: StuffItem) async throws {
        let context = context
        
        if let managedItem = try ManagedStuffItem.find(id: id, in: context) {
            
            managedItem.name = item.name
            managedItem.state = item.state
            managedItem.rememberDate = item.rememberDate
            
            try context.save()
            return
        }
        
        throw StuffStoreError.notFound
    }
    
    func delete(_ id: UUID) async throws {
        let context = context
        
        guard try ManagedStuffItem.find(id: id, in: context) != nil else {
            throw StuffStoreError.notFound
        }
        
        try ManagedStuffItem.find(id: id, in: context)
            .map(context.delete)
            .map(context.save)
    }
    
    
    func add(action: StuffActionModel, to item: UUID) async throws {
        let context = context
        
        guard let managedStuffItem = try ManagedStuffItem.find(id: item, in: context) else {
            throw StuffStoreError.notFound
        }
        
        try ManagedStuffItem.add(action: action, to: managedStuffItem, in: context)
    }
    
    func setCompleted(_ id: UUID, isCompleted: Bool) async throws {
        let context = context
        
        guard let managedAction = try ManagedStuffAction.find(for: id, in: context) else {
            throw StuffStoreError.notFound
        }
        
        managedAction.isCompleted = isCompleted
        
        try context.save()
    }
    
    func delete(action id: UUID) async throws {
        let context = context
        
        try ManagedStuffAction.find(for: id, in: context)
            .map(context.delete)
            .map(context.save)
        
    }
}


 struct StuffActionModel: Hashable, Identifiable {
    public let id: UUID
    let description: String
    var isCompleted: Bool
    
    public init(id: UUID, description: String, isCompleted: Bool) {
        self.id = id
        self.description = description
        self.isCompleted = isCompleted
    }
    
    public init(managed: ManagedStuffAction) {
        self.id = managed.id
        self.description = managed.actionDescription
        self.isCompleted = managed.isCompleted
    }
}

