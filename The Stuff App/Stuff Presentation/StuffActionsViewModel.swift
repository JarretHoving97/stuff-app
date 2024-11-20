//
//  StuffActionsViewModel.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 20/11/2024.
//

import SwiftUI

@Observable
class StuffActionViewModel {
    
    let item: StuffItem
    
    init(item: StuffItem) {
        self.item = item
    }
}
