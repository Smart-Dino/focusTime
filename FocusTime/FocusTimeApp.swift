//
//  FocusTimeApp.swift
//  FocusTime
//
//  Created by George Kyrylenko on 16.04.2025.
//

import SwiftUI
import SwiftData

@main
struct FocusTimeApp: App {
    let modelContainer: ModelContainer
    
    var body: some Scene {
        WindowGroup {
//            Text("No entry flow.")
            MainFlowCoordinatorView(viewModel: .init(modelContainer: modelContainer))
        }
    }
    
    init() {
        let schema = Schema([BlockItem.self, Schedule.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true, groupContainer: .identifier(AppValues.appGroupIdentifier))
        let container = try! ModelContainer(for: schema, configurations: config)
        
        self.modelContainer = container
    }
}
