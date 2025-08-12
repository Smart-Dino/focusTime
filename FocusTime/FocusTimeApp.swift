//
//  FocusTimeApp.swift
//  FocusTime
//
//  Created by George Kyrylenko on 16.04.2025.
//

import SwiftUI

@main
struct FocusTimeApp: App {
    let appFlowViewModel: AppFlowCoordinatorViewModel
    
    var body: some Scene {
        WindowGroup {
            AppFlowCoordinatorView(viewModel: appFlowViewModel)
                .preferredColorScheme(.dark) // Inject dark color scheme throughout the app.
        }
    }
    
    init() {
        self.appFlowViewModel = AppFlowCoordinatorViewModel()
    }
}
