//
//  ManagedStuffItem.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 26/10/2024.
//

import CoreData
import Foundation

@objc(ManagedStuffItem)
class ManagedStuffItem: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var createdAt: Date
    @NSManaged var state: String
    @NSManaged var rememberDate: Date?
}

extension ManagedStuffItem {
    
    static func find(in context: NSManagedObjectContext) throws -> [ManagedStuffItem]? {
        let request = NSFetchRequest<ManagedStuffItem>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request)
        
    }
    
    static func find(id: UUID, in context: NSManagedObjectContext) throws -> ManagedStuffItem? {
        let request = NSFetchRequest<ManagedStuffItem>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return try context.fetch(request).first
        
    }
}

@objc(ManagedStuffAction)
class ModalStuffAction: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var actionDescription: String
}
