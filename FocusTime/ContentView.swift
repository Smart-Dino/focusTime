//
//  ContentView.swift
//  FocusTime
//
//  Created by George Kyrylenko on 16.04.2025.
//

import SwiftUI
import FocusTimeUI

struct ContentView: View {
    var body: some View {
        Button("Test") { }
            .buttonStyle(FTPrimaryButtonStyle())
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
