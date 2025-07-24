//
//  FocusTimeApp.swift
//  FocusTime
//
//  Created by George Kyrylenko on 16.04.2025.
//

import SwiftUI
import SwiftData

#warning("When creating a splash screen make sure to handle ModelContainer errors!")

@main
struct FocusTimeApp: App {
    let modelContainer: ModelContainer
    
    var body: some Scene {
        WindowGroup {
            MainFlowCoordinatorView(viewModel: .init(modelContainer: modelContainer))
//            ShieldDebugView(
//                viewModel: .init(modelContainer: modelContainer)
//            )
        }
    }
    
    init() {
        let schema = Schema([BlockItem.self, Schedule.self])
        let config = ModelConfiguration(groupContainer: .identifier(AppValues.appGroupIdentifier))
        let container = try! ModelContainer(for: schema, configurations: config)
        
        self.modelContainer = container
    }
}
