//
//  PaymentManager.swift
//  FocusTime
//
//  Created by Maksym Horobets on 18.05.2025.
//

import Foundation

@MainActor
@Observable
final class ProState {
    struct Status: Equatable {
        var isPro: Bool
        var lastUpdated: Date
    }
    
    var status: Status = Status(isPro: false, lastUpdated: .now)
    
    nonisolated init() { }
    
    nonisolated func updateProStatus(_ newValue: Bool) async {
        await MainActor.run {
            status = Status(isPro: newValue, lastUpdated: .now)
        }
    }
}

// MARK: - Payment Manager Protocol
/// Defines the interface for managing in-app purchases.
protocol PaymentManager: Actor {
    // MARK: - Product Listings
    /// Tells whether the user has access to the **pro** version of the app.
    @MainActor var state: ProState { get }
    /// All products available for purchase.
    var products: [FTProduct] { get async }
    /// Products that the user has already purchased and is entitled to.
    var purchasedProducts: [FTProduct] { get }

    // MARK: - Service
    /// Used to load/reload data into payment manager's public and private properties.
    /// - Important: Recommended to use on every paywall screen launch. Access the needed data after awaiting this method.
    func reloadData() async throws

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
}

// MARK: - Mock Implementation
actor MockPaymentManagerWithPurchaseError: PaymentManager {
    // MARK: - Stored Properties
    @MainActor private(set) var state: ProState
    private(set) var products: [FTProduct]
    private(set) var purchasedProducts: [FTProduct] = []
    
    private var trialUsed: Bool
    
    // MARK: - Initialization
    init(isPro: Bool = false,
        trialUsed: Bool = false
    ) {
        self.state = ProState()
        self.trialUsed = trialUsed
        do {
            self.products = [
                try FTProduct.Mocks.weekly.product,
                try FTProduct.Mocks.monthly.product
            ]
        } catch {
            self.products = []
        }
    }

    func eligibleForIntro(product: FTProduct) async throws(PaymentError) -> Bool {
        if !trialUsed {
            if product.trialPeriod != nil {
                return true
            }
        }
        
        return false
    }

    func isPurchased(_ product: FTProduct) async -> Bool {
        purchasedProducts.contains(product)
    }
    
    func reloadData() async { return }

    func purchase(_ product: FTProduct) async throws -> FTProduct.PurchaseResult? {
        print("[Mock] purchase invoked for product: \(product)")
        throw PaymentError.unknown
    }

    func restorePurchases() async throws {
        print("[Mock] restorePurchases invoked")
        throw PaymentError.unknown
    }
}
