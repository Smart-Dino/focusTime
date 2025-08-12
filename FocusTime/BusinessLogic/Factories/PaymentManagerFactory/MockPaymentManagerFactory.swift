//
//  MockPaymentManagerFactory.swift
//  FocusTime
//
//  Created by Maksym Horobets on 12.08.2025.
//

import Foundation

actor MockPaymentManagerFactory: PaymentManagerFactory {
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
