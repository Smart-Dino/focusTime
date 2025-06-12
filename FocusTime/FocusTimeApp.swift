//
//  FocusTimeApp.swift
//  FocusTime
//
//  Created by George Kyrylenko on 16.04.2025.
//

import SwiftUI

@main
struct FocusTimeApp: App {
    let paywallFlowViewModel: PaywallFlowCoordinatorViewModel
    
    var body: some Scene {
        WindowGroup {
            PaywallFlowCoordinatorView(
                viewModel: paywallFlowViewModel
            )
//            ContentView()
        }
    }
    
    init() {
        let paymentManager = StoreKitPaymentManager()
        let superPaywallVM = SuperPaywallViewModel(paymentManager: paymentManager)
        self.paywallFlowViewModel = .init(superPaywallVM: superPaywallVM)
    }
}
