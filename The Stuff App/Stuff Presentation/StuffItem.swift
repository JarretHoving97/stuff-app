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
    let color: Color
    let name: String
    let createdAt: Date
    let state: String
    let rememberDate: Date?
    
    init(id: UUID = UUID(),color: Color, name: String) {
        self.id = id
        self.color = color
        self.name = name
        self.createdAt = Date()
        self.state = "Unremembered"
        self.rememberDate = Date()
        
    }
    
    init(id: UUID, color: Color, name: String, createdAt: Date, state: String, rememberDate: Date?) {
        self.id = id
        self.color = color
        self.name = name
        self.createdAt = createdAt
        self.state = state
        self.rememberDate = rememberDate
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
    }
}
