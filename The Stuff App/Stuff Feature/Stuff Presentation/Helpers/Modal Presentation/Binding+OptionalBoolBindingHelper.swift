//
//  Binding+OptionalBoolBindingHelper.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 24/10/2024.
//

import SwiftUI

extension Binding where Value == StuffItem? {
    
    var toBoolBinding: Binding<Bool> {
        Binding<Bool>.init {
            self.wrappedValue != nil
        } set: { value in
            if !value {
                self.wrappedValue = nil
            }
        }
    }
}
