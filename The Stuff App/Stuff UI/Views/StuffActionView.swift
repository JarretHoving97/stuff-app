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
    
    var body: some View {
        
        ZStack {
            Color(color)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.body)
                    .foregroundStyle(.black)
                    .minimumScaleFactor(0.01)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
                HStack {
                    icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.black)
                    Spacer()
                }
                
                Text(shortDescription)
                    .font(.subheadline)
                    .foregroundStyle(.black)
                    .minimumScaleFactor(0.01)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                }
            
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
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
