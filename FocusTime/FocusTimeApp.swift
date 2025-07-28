//
//  FocusTimeApp.swift
//  FocusTime
//
//  Created by George Kyrylenko on 16.04.2025.
//

import SwiftUI

@main
struct FocusTimeApp: App {
    @State var paymentManager: PaymentManager?
    
    var body: some Scene {
        WindowGroup {
            Group {
                if let paymentManager {
                    PlanSelectionPaywallView(
                        viewModel: .init(superPaywallVM: .init(paymentManager: paymentManager),
                                         flowDelegate: nil)
                    )
                } else {
                    ProgressView()
                        .task {
                            self.paymentManager = await StoreKitPaymentManager()
                        }
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}
