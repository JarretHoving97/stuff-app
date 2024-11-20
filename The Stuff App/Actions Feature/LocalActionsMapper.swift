//
//  LocalActionsMapper.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 20/11/2024.
//

import Foundation

public enum LocalActionsMapper {
    
     static func mapToLocal(managedActions: [ManagedStuffAction] ) -> [StuffActionModel] {
        return managedActions.map { StuffActionModel(managed: $0 )}
    }
}
