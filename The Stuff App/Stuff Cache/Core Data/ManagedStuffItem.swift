//
//  ManagedStuffItem.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 26/10/2024.
//

import CoreData
import Foundation


//@objc(ManagedFeedImage)
//class ManagedFeedImage: NSManagedObject {
//    @NSManaged var id: UUID
//    @NSManaged var imageDescription: String?
//    @NSManaged var location: String?
//    @NSManaged var url: URL
//    @NSManaged var data: Data?
//    @NSManaged var cache: ManagedCache
//}


@objc(ManagedStuffItem)
class ManagedStuffItem: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var createdAt: Date
    @NSManaged var state: String
    @NSManaged var rememberDate: Date?
}


@objc(ManagedStuffAction)
class ModalStuffAction: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var actionDescription: String
}
