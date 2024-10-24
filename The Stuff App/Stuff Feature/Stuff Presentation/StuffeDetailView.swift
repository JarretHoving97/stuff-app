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
            TaskView(item: item, animation: animation)
                .matchedGeometryEffect(id: item.id, in: animation)
                .onTapGesture {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.spring(duration: 0.4, bounce: 0.2, blendDuration: 0.2)) {
                            show.toggle()
                        }
                    }
                }
                .padding(.top, 40)
            Spacer()
        }
        .background() {
            Color.white.ignoresSafeArea(.all)
        }
    }
}


#Preview {
    @Previewable @Namespace var namespace
    
    StuffDetailView(animation: namespace, item: StuffItem(color: .black, name: "Call the dentist"), show: .constant(true))
}
