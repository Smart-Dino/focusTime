//
//  MockPaymentManagerFactory.swift
//  FocusTime
//
//  Created by Maksym Horobets on 11.08.2025.
//

import Foundation

struct MockPaymentManagerFactory: PaymentManagerFactory {
    func makePaymentManager() async -> any PaymentManager {
        MockPaymentManagerWithPurchaseError()
    }
}
