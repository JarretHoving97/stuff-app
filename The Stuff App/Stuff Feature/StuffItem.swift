//
//  StuffItem.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 24/10/2024.
//

import Foundation
import SwiftUI

struct StuffItem: Hashable, Identifiable {
    
    enum State: String {
        case done
        case scheduled
        case remembered
    }
    
    let id: UUID
    var color: Color
    var name: String
    let createdAt: Date
    var state: String
    let rememberDate: Date?
    
    var actions: [StuffActionModel]

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
    
    init(id: UUID = UUID(), color: Color, name: String) {
        self.id = id
        self.color = color
        self.name = name
        self.createdAt = Date()
        self.state = "Unremembered"
        self.rememberDate = Date()
        self.actions = []
        
    }
}
