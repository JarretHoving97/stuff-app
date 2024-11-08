//
//  StuffeDetailView.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 24/10/2024.
//

import SwiftUI

struct StuffDetailView: View {
    
    var animation: Namespace.ID
    let item: StuffItem
    @Binding var show: Bool
    
    var body: some View {
        VStack {
            TaskView(item: item)
                .matchedGeometryEffect(id: item.id, in: animation, properties: .position, isSource: true)
                .onTapGesture {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        show = false
                    }
                }
                .padding(.top, 40)
            Spacer()
        }
        .background(Color.white.ignoresSafeArea())
    }
}


#Preview {
    @Previewable @Namespace var namespace
    
    StuffDetailView(animation: namespace, item: StuffItem(color: .black, name: "Call the dentist"), show: .constant(true))
}
