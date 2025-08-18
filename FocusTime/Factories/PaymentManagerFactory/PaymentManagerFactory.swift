//
//  PaymentManagerFactory.swift
//  FocusTime
//
//  Created by Maksym Horobets on 11.08.2025.
//

import Foundation

@MainActor
protocol PaymentManagerFactory {
    func makePaymentManager() async -> PaymentManager
}
