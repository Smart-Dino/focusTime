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
    /// A list of all products available for purchase, typically sorted for display.
    var products: [FTProduct] { get }

    /// A list of products that the user has already purchased and are currently entitled to.
    var purchasedProducts: [FTProduct] { get }
    
    /// Returns `Bool` based on if the user has used his trial period.
    var trialUsed: Bool { get }

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
    
    /// Checks if a specific product has been purchased by the user.
    ///
    /// - Parameter product: The `FTProduct` to check.
    /// - Returns: `true` if the product is found in the `purchasedProducts` list, `false` otherwise.
    /// - Throws: An error if there's an issue checking the purchase status (though typically this might just access local state).
    func isPurchased(_ product: FTProduct) async throws -> Bool

    // TODO: Implement Entitlements when wiring up business logic.
}


/// This instance of ``PaymentManager`` only succeeds on `getProducts()` method.
actor MockPaymentManagerWithPurchaseError: PaymentManager {
    private(set) var products: [FTProduct]
    var purchasedProducts: [FTProduct] = []
    
    func isPurchased(_ product: FTProduct) async throws -> Bool {
        purchasedProducts.contains(product)
    }
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
