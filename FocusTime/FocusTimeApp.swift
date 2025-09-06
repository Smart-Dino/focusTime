//
//  FocusTimeApp.swift
//  FocusTime
//
//  Created by George Kyrylenko on 16.04.2025.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct FocusTimeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let appFlowViewModel: AppFlowCoordinatorViewModel
    
    var body: some Scene {
        WindowGroup {
            AppFlowCoordinatorView(viewModel: appFlowViewModel)
                .preferredColorScheme(.dark) // Inject dark color scheme throughout the app.
        }
    }
    
    init() {
        self.appFlowViewModel = AppFlowCoordinatorViewModel(analyticsManager: LiveAnalyticsManager())
    }
}
