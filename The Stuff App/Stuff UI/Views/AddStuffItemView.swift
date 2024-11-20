//
//  AddStuffItemView.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 20/11/2024.
//

import SwiftUI

struct AddStuffItemView: View {
    
    @State private var name: String = ""
    @Binding var presentSheet: Bool
    
    var onAddButtonTapped: ((String) -> Void)
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                Button("add") {
                    onAddButtonTapped(name)
                    presentSheet.toggle()
                }
            }
            
            TextField("", text: $name)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
                .padding()
                .background(Color.black.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            
        }
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("item_secondary_color"))
    }
}
