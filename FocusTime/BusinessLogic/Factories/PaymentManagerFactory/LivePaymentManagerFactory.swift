//
//  LivePaymentManagerFactory.swift
//  FocusTime
//
//  Created by Maksym Horobets on 12.08.2025.
//

import Foundation

actor LivePaymentManagerFactory: PaymentManagerFactory {
    func makePaymentManager() async -> any PaymentManager {
        await StoreKitPaymentManager()
    }
}
