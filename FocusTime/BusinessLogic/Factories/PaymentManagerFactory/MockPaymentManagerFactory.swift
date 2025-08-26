//
//  MockPaymentManagerFactory.swift
//  FocusTime
//
//  Created by Maksym Horobets on 11.08.2025.
//

import Foundation

struct MockPaymentManagerFactory: PaymentManagerFactory {
    private let isPro: Bool
    private let isTrialUsed: Bool
    
    init(isPro: Bool = false, isTrialUsed: Bool = false) {
        self.isPro = isPro
        self.isTrialUsed = isTrialUsed
    }
    
    func makePaymentManager() async -> any PaymentManager {
        MockPaymentManagerWithPurchaseError(isPro: isPro, trialUsed: isTrialUsed)
    }
}
