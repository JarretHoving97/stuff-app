//
//  ContentView.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 24/10/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        StuffListView(
            viewModel: StuffListViewModel(
                items: [
                    StuffItem(color: .purple, name: "Call the dentist"),
                    StuffItem(color: .blue, name: "Mail maintanance engineer back"),
                    StuffItem(color: .brown, name: "Create mail invitation"),
                ]
            )
        )
    }
}

#Preview {
    ContentView()
}
