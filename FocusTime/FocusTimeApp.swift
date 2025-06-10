//
//  FocusTimeApp.swift
//  FocusTime
//
//  Created by George Kyrylenko on 16.04.2025.
//

import SwiftUI

@main
struct FocusTimeApp: App {
    let factory: PaywallBusinessLogicFactory
    
    var body: some Scene {
        WindowGroup {
            PaywallFlowCoordinatorView(
                viewModel: .init(factory: factory)
            )
//            ContentView()
        }
    }
    
    init() {
        let paymentManager = StoreKitPaymentManager()
        let superPaywallVM = SuperPaywallViewModel(paymentManager: paymentManager)
        let paywallFactory = PaywallBusinessLogicFactory(
            paymentManager: paymentManager,
            superPaywallVM: superPaywallVM
        )
        self.factory = paywallFactory
    }
}
