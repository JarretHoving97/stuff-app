//
//  TaskView.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 24/10/2024.
//

import SwiftUI

struct TaskView: View {
    
    let item: StuffItem
    let animation: Namespace.ID
    
    var body: some View {
        ZStack {
            item.color
                .cornerRadius(20)
                .shadow(radius: 10)
            
            Text(item.name)
                .font(.title)
                .foregroundColor(.white)
                .lineLimit(3, reservesSpace: true)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .multilineTextAlignment(.leading)
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                
        }
        .frame(height: 100)
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
    }
}

#Preview {
    @Previewable @Namespace var namespace
    
    return TaskView(item: StuffItem(color: .blue, name: "TODO"), animation: namespace)
}
