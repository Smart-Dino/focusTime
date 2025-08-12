//
//  PaymentManagerFactory.swift
//  FocusTime
//
//  Created by Maksym Horobets on 12.08.2025.
//

import Foundation

protocol PaymentManagerFactory: Actor {
    func makePaymentManager() async -> PaymentManager
}
