//
//  PaymentManager.swift
//  FocusTime
//
//  Created by Maksym Horobets on 18.05.2025.
//

import Foundation

// MARK: - Payment Manager Protocol
/// Defines the interface for managing in-app purchases.
protocol PaymentManager: Actor {
    // MARK: - Product Listings
    /// Tells whether the user has access to the **pro** version of the app.
    var isPro: Bool { get }
    /// All products available for purchase.
    var products: [FTProduct] { get async }
    /// Products that the user has already purchased and is entitled to.
    var purchasedProducts: [FTProduct] { get }

    // MARK: - Service
    /// Used to load/reload data into payment manager's public and private properties.
    /// - Important: Recommended to use on every paywall screen launch. Access the needed data after awaiting this method.
    func reloadData() async
    
    // MARK: - Convenience
    /// Returns the `FTProduct` associated with the given product identifier.
    ///
    /// - Parameter id: The product identifier as a `String`.
    /// - Returns: The `FTProduct` corresponding to the given identifier.
    /// - Throws: `PaymentError` if the product cannot be found or retrieved.
    func productForID(_ id: String) throws(PaymentError) -> FTProduct

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

    // MARK: - Stream
    /// Streams updates to the purchased products list.
    ///
    /// - Returns: An `AsyncStream` emitting arrays of `FTProduct`.
    func isProUserChangesStream() -> AsyncStream<Bool>
}

// MARK: - Mock Implementation
actor MockPaymentManagerWithPurchaseError: PaymentManager {
    // MARK: - Stored Properties
    private(set) var isPro: Bool
    private(set) var products: [FTProduct]
    private(set) var purchasedProducts: [FTProduct] = []
    
    private var trialUsed: Bool
    
    // MARK: - Initialization
    init(isPro: Bool = false,
        trialUsed: Bool = false
    ) {
        self.isPro = isPro
        self.trialUsed = trialUsed
        self.products = [
            FTProduct.Mocks.weekly.product,
            FTProduct.Mocks.monthly.product
        ]
    }

    // MARK: - Methods
    func isProUserChangesStream() -> AsyncStream<Bool> {
        AsyncStream { continuation in
            continuation.yield(true)
        }
    }

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
    
    func reloadData() async { return }
    
    func productForID(_ id: String) throws(PaymentError) -> FTProduct {
        throw .productNotFound
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
