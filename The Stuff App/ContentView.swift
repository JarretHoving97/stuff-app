//
//  ContentView.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 24/10/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            StuffListView(
                viewModel: StuffListViewModel(
                    store: MOCK_STORE()
                )
            )
        }
    }
}

#Preview {
    ContentView()
}
