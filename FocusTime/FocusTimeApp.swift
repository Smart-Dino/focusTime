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
            PaywallFlowView(viewModel: .init(paymentManager: StoreKitPaymentManager()))
//            ContentView()
//            StoreKitPaymentManagerDebugView(paymentManager: StoreKitPaymentManager())
        }
    }
}
