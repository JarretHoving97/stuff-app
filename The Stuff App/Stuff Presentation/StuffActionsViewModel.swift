//
//  StuffActionsViewModel.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 20/11/2024.
//

import SwiftUI

class StuffActionViewModel {
    
    @AppStorage("show_closing_animation") var showClosingAnimaiton: Bool = true
    
    let item: StuffItem
    
    init(item: StuffItem) {
        self.item = item
    }
}
