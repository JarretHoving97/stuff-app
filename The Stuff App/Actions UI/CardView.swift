//
//  CardView.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 20/11/2024.
//

import SwiftUI

struct CardView: View {
    
    let title: String
    
    var body: some View {
        ZStack {
            Text(title)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .multilineTextAlignment(.leading)
                .font(.headline)
                .lineLimit(4, reservesSpace: false)
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                .padding()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("item_primary_color"))
        .cornerRadius(14)
    }
}

