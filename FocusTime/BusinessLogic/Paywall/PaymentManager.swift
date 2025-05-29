//
//  PaymentManager.swift
//  FocusTime
//
//  Created by Maksym Horobets on 18.05.2025.
//

import Foundation
import StoreKit

enum PaymentError: LocalizedError {
    case failedVerification
    case purchaseInProgress
    case productNotFound
    case unknown

    /// A human-readable description for each payment error.
    var errorDescription: String {
        switch self {
        case .failedVerification:
            return "The purchase could not be verified. Please try again later."
        case .purchaseInProgress:
            return "A purchase is already in progress. Please wait until it completes."
        case .productNotFound:
            return "The requested product could not be found."
        case .unknown:
            return "An unknown error occurred during the purchase."
        }
    }
}

// MARK: This is unfinished and will be done on the stage of implementing Business Logic.
protocol PaymentManager: Actor {
    /// Returns `Bool` based on if the user has used his trial period.
    var trialUsed: Bool { get }
    /// Fetches and returns a list of products available for purchase.
    /// - Returns: An array of ``Product`` objects.
    /// - Throws: An error if fetching products fails.
    func getProducts() async throws -> [FTProduct]

    /// Attempts to purchase the specified ``Product``.
    /// - Parameter product: The ``Product`` to purchase.
    /// - Returns: A `Product.PurchaseResult?` indicating the outcome (success, pending, userCancelled).
    /// - Throws: An error if the purchase process itself encounters a critical issue.
    func purchase(_ product: FTProduct) async throws -> FTProduct.PurchaseResult?

    /// Attempts to restore previously made purchases.
    /// - Throws: An error if the restoration process encounters a critical issue.
    /// After a successful call, the user's entitlements should be re-checked
    /// using `hasEntitlement(:)` or `getAllActiveEntitlements()`.
    func restorePurchases() async throws

    // TODO: Implement Entitlements when wiring up business logic.
}

/// This instance of ``PaymentManager`` only succeeds on `getProducts()` method.
actor MockPaymentManagerWithPurchaseError: PaymentManager {
    private var products: [FTProduct]
    // This will have to be a computed property in LivePaymentManager
    private(set) var trialUsed: Bool
    
    func getProducts() async throws(PaymentError) -> [FTProduct] {
        print("getProducts invoked")
        return products
    }
    
    func purchase(_ product: FTProduct) async throws(PaymentError) -> FTProduct.PurchaseResult? {
        print("purchase invoked")
        print("Description: \(product)")
        print("Formatted price: \(product.price.description)")
        throw .unknown
    }
    
    func restorePurchases() async throws(PaymentError) {
        print("restorePurchases invoked")
        throw .unknown
    }
    
    init(trialUsed: Bool = false) {
        // Get products
        self.products = [
            FTProduct.Mocks.monthly.product,
            FTProduct.Mocks.yearly.product,
            FTProduct.Mocks.lifetime.product
        ]
        self.trialUsed = trialUsed
    }
    
}
