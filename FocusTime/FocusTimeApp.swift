//
//  FocusTimeApp.swift
//  FocusTime
//
//  Created by George Kyrylenko on 16.04.2025.
//

import SwiftUI

@main
struct FocusTimeApp: App {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                OnboardingPaywallView(viewModel: .init(
                    paymentManager: MockPaymentManagerWithPurchaseError()
                ))
                // TODO: - REMOVE TEMPORARY BUTTON
                Button("Reset Onboarding (for Preview)") {
                    hasCompletedOnboarding = false
                    
                }
                .padding()
                .buttonStyle(.borderedProminent)
            } else {
                OnboardingCoordinatorView(hasCompletedOnboarding: $hasCompletedOnboarding)
            }
        }
    }
}
