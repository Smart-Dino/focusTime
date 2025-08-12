//
//  PaymentManagerFactory.swift
//  FocusTime
//
//  Created by Maksym Horobets on 11.08.2025.
//

import Foundation

protocol PaymentManagerFactory: Sendable {
    func makePaymentManager() async -> PaymentManager
}
