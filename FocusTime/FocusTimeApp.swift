//
//  FocusTimeApp.swift
//  FocusTime
//
//  Created by George Kyrylenko on 16.04.2025.
//

import SwiftUI

@main
struct FocusTimeApp: App {
    var body: some Scene {
        WindowGroup {
            PlanSelectionPaywallView(viewModel: .init(superPaywallVM: .init(paymentManager: StoreKitPaymentManager()), flowDelegate: nil))
        }
    }
}
