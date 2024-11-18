//
//  StuffItem.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 24/10/2024.
//

import Foundation
import SwiftUI

struct StuffItem: Hashable, Identifiable {
    let id: UUID
    var color: Color
    var name: String
    let createdAt: Date
    var state: String
    let rememberDate: Date?
    
    var actions: [StuffActionModel]
    
    init(id: UUID = UUID(),color: Color, name: String) {
        self.id = id
        self.color = color
        self.name = name
        self.createdAt = Date()
        self.state = "Unremembered"
        self.rememberDate = Date()
        self.actions = []
        
    }
    
    init(id: UUID, color: Color, name: String, createdAt: Date, state: String, rememberDate: Date?, actions: [StuffActionModel]) {
        self.id = id
        self.color = color
        self.name = name
        self.createdAt = createdAt
        self.state = state
        self.rememberDate = rememberDate
        self.actions = actions
    }
}

extension StuffItem {
    
    init(managedStuffItem: ManagedStuffItem) {
        self.id = managedStuffItem.id
        self.color = .black
        self.name = managedStuffItem.name
        self.createdAt = managedStuffItem.createdAt
        self.state = managedStuffItem.state
        self.rememberDate = managedStuffItem.rememberDate
        self.actions = LocalActionsMapper.mapToLocal(managedActions: managedStuffItem.actions?.compactMap {$0 as? ManagedStuffAction} ?? [])
    }
}


extension StuffItem {
    
    enum State: String {
        case done
        case scheduled
        case remembered
    }
}


public enum LocalActionsMapper {

     static func mapToLocal(managedActions: [ManagedStuffAction] ) -> [StuffActionModel] {
        return managedActions.map { StuffActionModel(managed: $0 )}
    }
}
