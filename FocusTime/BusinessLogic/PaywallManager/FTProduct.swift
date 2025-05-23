//
//  FTProduct.swift
//  FocusTime
//
//  Created by Maksym Horobets on 19.05.2025.
//

import Foundation
import StoreKit

/// An abstracted structure for a purchase product used as an intermediate level between the app
/// and the payment processing system.
struct FTProduct: Identifiable, Equatable, Sendable {
    // MARK: - Nested declarations
    enum PurchaseResult: Equatable {
        case success/*(VerificationResult<Transaction>)*/
        case userCancelled
        case pending
    }

    // MARK: - Properties
    let id: String
    let title: String
    let description: String
    let price: Decimal // Using Decimal to avoid binary rounding
    let priceFormatStyle: Decimal.FormatStyle.Currency
    let subscriptionPeriod: Int? // Now an Int, representing number of seconds
    /// Declares whether this product has a trial option on it.
    let isTrialable: Bool
    /// Tells if this product is meant to be a subscription.
    let isSubscription: Bool
    
    // MARK: - Initializer
    /// Initializes a new `FTProduct` with the provided metadata and optional subscription period.
    ///
    /// - Parameters:
    ///   - id:               The unique identifier of the product (e.g. `"com.myapp.monthly"`).
    ///   - title:            The localized display name of the product.
    ///   - description:      A localized description of what the product offers.
    ///   - price:            The cost of the product as a `Decimal`, avoiding binary‑floating rounding issues.
    ///   - priceFormatStyle: The `Decimal.FormatStyle.Currency` used to format the `price`.
    ///   - subscriptionPeriod: An optional subscription period as an `Int` (number of seconds).
    ///                         (nil for one‑time purchases).
    ///   - trialable:        Declares whether this product has a trial option on it.
    init(
        id: String = UUID().uuidString,
        title: String,
        description: String,
        price: Decimal,
        priceFormatStyle: Decimal.FormatStyle.Currency,
        subscriptionPeriod: Int? = nil,
        isTrialable: Bool = false
    ) {
        self.id                 = id
        self.title              = title
        self.description        = description
        self.price              = price
        self.priceFormatStyle   = priceFormatStyle
        self.subscriptionPeriod = subscriptionPeriod
        self.isTrialable        = isTrialable
        
        self.isSubscription = subscriptionPeriod != nil
    }
}


// MARK: - Mocks
extension FTProduct {
    enum Mocks {
        case weekly
        case monthly
        case yearly
        case lifetime
        
        var product: FTProduct {
            switch self {
            case .weekly:
                FTProduct(
                    title: "Weekly",
                    description: "Unlock pro features for a week",
                    price: 0.37,
                    priceFormatStyle: .currency(code: "USD"),
                    subscriptionPeriod: PeriodConverter.weekly.durationInSeconds
                )
            case .monthly:
                FTProduct(
                    title: "Monthly",
                    description: "Unlock pro features for a month",
                    price: 2.99,
                    priceFormatStyle: .currency(code: "USD"),
                    subscriptionPeriod: PeriodConverter.monthly.durationInSeconds,
                    isTrialable: true
                )
            case .yearly:
                FTProduct(
                    title: "Yearly",
                    description: "Unlock pro features for a year",
                    price: 29.99,
                    priceFormatStyle: .currency(code: "USD"),
                    subscriptionPeriod: PeriodConverter.yearly.durationInSeconds
                )
            case .lifetime:
                FTProduct(
                    title: "Lifetime",
                    description: "Unlock this app forever",
                    price: 399.99,
                    priceFormatStyle: .currency(code: "USD")
                    // subscriptionPeriod is nil for lifetime
                )
            }
        }
    }
}
