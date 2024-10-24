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
                .font(.largeTitle)
                .foregroundColor(.white)
        }
        .frame(height: 180)
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
    }
}

#Preview {
    @Previewable @Namespace var namespace
    
    return TaskView(item: StuffItem(color: .blue, name: "TODO"), animation: namespace)
}
