//
//  StuffActionModel.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 20/11/2024.
//

import Foundation

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

