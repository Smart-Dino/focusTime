//
//  PaymentManager.swift
//  FocusTime
//
//  Created by Maksym Horobets on 18.05.2025.
//

import Foundation
import StoreKit

/// Represents errors that can occur during the payment process.
enum PaymentError: LocalizedError {
    case failedVerification
    case purchaseInProgress
    case productNotFound
    case unknown

    /// A user-friendly description for each payment error.
    var errorDescription: String? {
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

// MARK: - Payment Manager Protocol

/// Defines the interface for managing in-app purchases.
protocol PaymentManager: Actor {
    // MARK: - Product Listings

    /// All products available for purchase.
    var products: [FTProduct] { get }

    /// Products that the user has already purchased and is entitled to.
    var purchasedProducts: [FTProduct] { get }

    // MARK: - Purchase Actions

    /// Attempts to purchase the given product.
    ///
    /// - Parameter product: The `FTProduct` to purchase.
    /// - Returns: An optional `FTProduct.PurchaseResult` indicating success, pending, or cancellation.
    /// - Throws: `PaymentError` if a critical issue occurs during the purchase.
    func purchase(_ product: FTProduct) async throws -> FTProduct.PurchaseResult?

    /// Restores previously made purchases.
    ///
    /// - Throws: `PaymentError` if a critical issue occurs during restoration.
    ///
    /// After successful restoration, entitlements should be re-validated using `isPurchased(_:)`.
    func restorePurchases() async throws

    // MARK: - Entitlement Checks

    /// Checks if the specified product has been purchased.
    ///
    /// - Parameter product: The `FTProduct` to check.
    /// - Returns: `true` if the product is in `purchasedProducts`, otherwise `false`.
    func isPurchased(_ product: FTProduct) async -> Bool
    
    /// Determines whether the user is eligible for an introductory offer (e.g. free trial) for a specific product or
    /// any auto-renewable product subscription in the same subscription group.
    /// - Parameter product: The `FTProduct` to check for trial eligibility.
    /// - Returns: `true` if the user appears to be eligible for an introductory offer; `false` otherwise.
    /// - Throws: `PaymentError` if an error occurs while determining eligibility (e.g. missing product info).
    func eligibleForIntro(product: FTProduct) async throws(PaymentError) -> Bool

    /// Streams updates to the purchased products list.
    ///
    /// - Returns: An `AsyncStream` emitting arrays of `FTProduct`.
    func stream() -> AsyncStream<[FTProduct]>
}

// MARK: - Mock Implementation

/// A mock `PaymentManager` that simulates errors on purchase and restore operations.
actor MockPaymentManagerWithPurchaseError: PaymentManager {
    // MARK: - Stored Properties
    private(set) var products: [FTProduct]
    private var trialUsed: Bool
    var purchasedProducts: [FTProduct] = []
    
    // MARK: - Initialization
    init(trialUsed: Bool = false) {
        self.trialUsed = trialUsed
        self.products = [
            FTProduct.Mocks.monthly.product,
            FTProduct.Mocks.yearly.product,
            FTProduct.Mocks.lifetime.product
        ]
    }

    // MARK: - Streaming
    func stream() -> AsyncStream<[FTProduct]> {
        AsyncStream { continuation in
            continuation.yield([])
        }
    }

    // MARK: - Protocol Methods
    func eligibleForIntro(product: FTProduct) async throws(PaymentError) -> Bool {
        if !trialUsed {
            if products.first(where: { $0.trialPeriod != nil }) != nil {
                return true
            }
        }
        
        return false
    }

    func isPurchased(_ product: FTProduct) async -> Bool {
        purchasedProducts.contains(product)
    }

    func purchase(_ product: FTProduct) async throws -> FTProduct.PurchaseResult? {
        print("[Mock] purchase invoked for product: \(product)")
        throw PaymentError.unknown
    }

    func restorePurchases() async throws {
        print("[Mock] restorePurchases invoked")
        throw PaymentError.unknown
    }
}
