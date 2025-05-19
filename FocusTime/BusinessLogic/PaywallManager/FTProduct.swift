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
struct FTProduct: Identifiable, Equatable {
    // MARK: - Nested declarations
    struct SubscriptionPeriod: Equatable {
        /// The order is matched with `StoreKit.Product.SubcriptionPeriod.Unit`.
        enum Unit: Int, Equatable {
            case day   = 0
            case week  = 1
            case month = 2
            case year  = 3
        }
        let value: Int
        let unit: Self.Unit
    }
    
    enum PurchaseResult: Equatable {
        case success/*(VerificationResult<Transaction>)*/
        case userCancelled
        case pending
    }
    
    // MARK: - Properties
    let id: String
    let title: String
    let description: String
    let price: Decimal // Using Decimal to avoid binary rounding.
    let priceFormatStyle: Decimal.FormatStyle.Currency
    let subscriptionPeriod: Self.SubscriptionPeriod?
    
    // MARK: Computed properties
    /// Returns a string for a price matching locale.
    var priceString: String {
        price.formatted(priceFormatStyle)
    }
    
    // MARK: - Initializer
    /// Initializes a new `FTProduct` with the provided metadata and optional subscription period.
    ///
    /// - Parameters:
    ///   - id:               The unique identifier of the product (e.g. `"com.myapp.monthly"`).
    ///   - title:            The localized display name of the product.
    ///   - description:      A localized description of what the product offers.
    ///   - price:            The cost of the product as a `Decimal`, avoiding binary‑floating rounding issues.
    ///   - priceLocale:      The `Locale` used to format the `price` (currency, numbering, etc.).
    ///   - subscriptionPeriod: An optional subscription period describing the billing interval
    ///                         (nil for one‑time purchases).
    init(
        id: String,
        title: String,
        description: String,
        price: Decimal,
        priceFormatStyle: Decimal.FormatStyle.Currency,
        subscriptionPeriod: Self.SubscriptionPeriod? = nil
    ) {
        self.id                 = id
        self.title              = title
        self.description        = description
        self.price              = price
        self.priceFormatStyle   = priceFormatStyle
        self.subscriptionPeriod = subscriptionPeriod
    }
}

// MARK: - Extensions
// These are just convenience methods, they do not adapt anything
// nor they are necessary.
// But StoreKit has these, so I decided to add them too.
extension FTProduct.SubscriptionPeriod {
    /// A subscription period of six months (180 days).
    /// - Returns: A `SubscriptionPeriod` representing a six‑month billing cycle.
    static var everySixMonths: Self {
        .init(value: 6, unit: .month)
    }

    /// A subscription period of three days.
    /// - Returns: A `SubscriptionPeriod` representing a three‑day billing cycle.
    static var everyThreeDays: Self {
        .init(value: 3, unit: .day)
    }

    /// A subscription period of three months (approximately 90 days).
    /// - Returns: A `SubscriptionPeriod` representing a three‑month billing cycle.
    static var everyThreeMonths: Self {
        .init(value: 3, unit: .month)
    }

    /// A subscription period of two months (approximately 60 days).
    /// - Returns: A `SubscriptionPeriod` representing a two‑month billing cycle.
    static var everyTwoMonths: Self {
        .init(value: 2, unit: .month)
    }

    /// A subscription period of two weeks (14 days).
    /// - Returns: A `SubscriptionPeriod` representing a bi‑weekly billing cycle.
    static var everyTwoWeeks: Self {
        .init(value: 2, unit: .week)
    }

    /// A subscription period of one month (30 days).
    /// - Returns: A `SubscriptionPeriod` representing a standard monthly billing cycle.
    static var monthly: Self {
        .init(value: 1, unit: .month)
    }

    /// A subscription period of one week (7 days).
    /// - Returns: A `SubscriptionPeriod` representing a standard weekly billing cycle.
    static var weekly: Self {
        .init(value: 1, unit: .week)
    }

    /// A subscription period of one year (12 months).
    /// - Returns: A `SubscriptionPeriod` representing an annual billing cycle.
    static var yearly: Self {
        .init(value: 1, unit: .year)
    }
}


// MARK: - Adapter Extensions
extension FTProduct {
    /// 2) A convenience initializer to wrap a real StoreKit Product.
    init(skProduct: StoreKit.Product) {
        self.id                 = skProduct.id
        self.title              = skProduct.displayName
        self.description        = skProduct.description
        self.price              = skProduct.price as Decimal
        self.priceFormatStyle   = skProduct.priceFormatStyle
        self.subscriptionPeriod = Self.SubscriptionPeriod(skPeriod: skProduct.subscription?.subscriptionPeriod)
    }
}

extension FTProduct.SubscriptionPeriod {
    init?(skPeriod: StoreKit.Product.SubscriptionPeriod?) {
        guard let skPeriod else { return nil }
        
        let unit: Self.Unit = switch skPeriod.unit {
        case .day: .day
        case .week: .week
        case .month: .month
        case .year: .year
        @unknown default: .month
        }
        
        self.value = skPeriod.value
        self.unit = unit
    }
}

extension FTProduct.PurchaseResult {
    init(skResult: StoreKit.Product.PurchaseResult) throws {
        self = switch skResult {
        case .success(let verificationResult): .success
        case .userCancelled: .userCancelled
        case .pending: .pending
        @unknown default: throw NSError() // TODO: Come up with some error or a conversion failure case
        }
    }
}

// MARK: - Mocks
extension FTProduct {
    /// 3) A handy “mock” you can use in tests or previews
    static let mockMonthly = FTProduct(
        id:       "com.yourapp.monthly",
        title:    "Monthly Pro",
        description: "Unlock pro features for a month",
        price:    2.99,
        priceFormatStyle: .currency(code: "USD"),
        subscriptionPeriod: .monthly
    )
    static let mockYearly = FTProduct(
        id:       "com.yourapp.yearly",
        title:    "Yearly Pro",
        description: "Unlock pro features for a year",
        price:    29.99,
        priceFormatStyle: .currency(code: "USD"),
        subscriptionPeriod: .yearly
    )
}
