//
//  ManagedStuffAction.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 18/11/2024.
//

import Foundation
import CoreData

@objc(ManagedStuffAction)
class ManagedStuffAction: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var actionDescription: String
    @NSManaged var isCompleted: Bool
    @NSManaged var stuffItem: ManagedStuffItem
}

extension ManagedStuffAction: Identifiable {

    static func newAction(for action: StuffActionModel, in context: NSManagedObjectContext) -> ManagedStuffAction {
        
        let managedAction = ManagedStuffAction(context: context)
        managedAction.id = action.id
        managedAction.actionDescription = action.description
        managedAction.isCompleted = action.isCompleted
    
        return managedAction
    }
    
    static func find(for id: UUID, in context: NSManagedObjectContext) throws -> ManagedStuffAction? {
        let request = NSFetchRequest<ManagedStuffAction>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return try context.fetch(request).first
    }
}
