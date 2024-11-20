//
//  StuffActionView.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 20/11/2024.
//

import SwiftUI

struct StuffActionView: View {
    
    let color: Color
    let icon: Image
    let title: String
    let shortDescription: String
    
    var onTap: (() -> Void)?
    
    // Detect compact or regular size class
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        let isCompact = UIScreen.main.bounds.height <= 736
        
        ZStack {
            Color(color)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.body)
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
                HStack {
                    icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: isCompact ? 40 : 50, height: isCompact ? 40 : 50)
                        .foregroundStyle(.black)
                    Spacer()
                }
                
                Text(shortDescription)
                    .font(.subheadline)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                }
            
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 10))
        }
        .onTapGesture {
            onTap?()
        }
    }
}


#Preview {
    StuffActionView(
        color: .hilightedItem,
        icon: Image(systemName: "eye"),
        title: "Do something",
        shortDescription: "If you do something. you're doing something.",
        onTap: {}
    )
    .frame(width: 200, height: 240)
    
}
