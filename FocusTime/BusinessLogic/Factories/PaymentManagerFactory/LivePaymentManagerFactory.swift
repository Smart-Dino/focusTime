//
//  LivePaymentManagerFactory.swift
//  FocusTime
//
//  Created by Maksym Horobets on 11.08.2025.
//

import Foundation

struct LivePaymentManagerFactory: PaymentManagerFactory {
    func makePaymentManager() async -> any PaymentManager {
        await StoreKitPaymentManager()
    }
}
