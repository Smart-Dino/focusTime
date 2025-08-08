//
//  FocusTimeApp.swift
//  FocusTime
//
//  Created by George Kyrylenko on 16.04.2025.
//

import SwiftUI

@main
struct FocusTimeApp: App {
    let launchFlowViewModel: LaunchFlowCoordinatorViewModel
    
    var body: some Scene {
        WindowGroup {
            LaunchFlowView(viewModel: launchFlowViewModel)
                .preferredColorScheme(.dark) // Inject dark color scheme throughout the app.
        }
    }
    
    init() {
        let persistenceStoreFactory = LivePersistenceStoreFactory()
        self.launchFlowViewModel = LaunchFlowCoordinatorViewModel(persistenceStoreFactory: persistenceStoreFactory)
    }
}
