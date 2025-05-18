//
//  PaymentManager.swift
//  FocusTime
//
//  Created by Maksym Horobets on 18.05.2025.
//

import Foundation
import StoreKit

// MARK: This is unfinished and will be so on the stage of implementing Business Logic.
protocol PaymentManager: Actor {

    /// Fetches and returns a list of products available for purchase.
    /// - Returns: An array of ``Product`` objects.
    /// - Throws: An error if fetching products fails.
    func getProducts() async throws -> [Product]

    /// Attempts to purchase the specified ``Product``.
    /// - Parameter product: The ``Product`` to purchase.
    /// - Returns: A `Product.PurchaseResult?` indicating the outcome (success, pending, userCancelled).
    /// - Throws: An error if the purchase process itself encounters a critical issue.
    func purchase(_ product: Product) async throws -> Product.PurchaseResult?

    /// Attempts to restore previously made purchases.
    /// - Throws: An error if the restoration process encounters a critical issue.
    /// After a successful call, the user's entitlements should be re-checked
    /// using `hasEntitlement(:)` or `getAllActiveEntitlements()`.
    func restorePurchases() async throws

    // TODO: Implement Entitlements when wiring up business logic.
}

actor MockPaymentManager: PaymentManager {
    func getProducts() async throws -> [Product] {
        print("getProducts invoked")
        throw NSError() // Use NSError for now
    }
    
    func purchase(_ product: Product) async throws -> Product.PurchaseResult? {
        print("purchase invoked")
        throw NSError() // Use NSError for now
    }
    
    func restorePurchases() async throws {
        print("restorePurchases invoked")
        throw NSError() // Use NSError for now
    }
    
    
}
