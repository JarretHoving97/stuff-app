//
//  ModalViewModifier.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 24/10/2024.
//


import SwiftUI

struct ModalViewModifier<Destination: View, Bindable: Identifiable>: ViewModifier {
    @Binding var value: Bindable?
    let destination: (_ value: Bindable) -> Destination
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if let value {
                destination(value)
            }
        }
    }
}

extension View {
    func modal<Destination: View, Bindable: Identifiable>(bindable: Binding<Bindable?>, @ViewBuilder destination: @escaping (_ value: Bindable) -> Destination) -> some View {
        self.modifier(ModalViewModifier(value: bindable, destination: { value in
            destination(value)
        }))
        
    }
}
