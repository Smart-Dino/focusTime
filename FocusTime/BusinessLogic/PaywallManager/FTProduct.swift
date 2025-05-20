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
        enum Unit: Equatable {
            case day, week, month, year
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
    /// Declares whether this product has a trial option on it.
    let isTrialable: Bool
    
    // MARK: Computed properties
    /// Returns a string for a price matching locale.
    var priceString: String {
        price.formatted(priceFormatStyle)
    }
    var trialOfferSubtitle: String? {
        guard let subscriptionPeriodString else { return nil }
        return price.description + " " + priceFormatStyle.currencyCode + "/" + subscriptionPeriodString
    }
    /// Returns a human-readable string describing the subscription period.
    /// Examples: "month", "every 2 months", "year".
    /// Returns `nil` if `subscriptionPeriod` is `nil`.
    var subscriptionPeriodString: String? {
        guard let period = subscriptionPeriod else {
            return nil
        }
        
        let unitName: String
        switch period.unit {
        case .day:
            unitName = period.value == 1 ? "day" : "days"
        case .week:
            unitName = period.value == 1 ? "week" : "weeks"
        case .month:
            unitName = period.value == 1 ? "month" : "months"
        case .year:
            unitName = period.value == 1 ? "year" : "years"
        }
        
        if period.value == 1 {
            return unitName
        } else {
            return "every \(period.value) \(unitName)"
        }
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
    ///   - trialable:        Declares whether this product has a trial option on it.
    init(
        id: String = UUID().uuidString,
        title: String,
        description: String,
        price: Decimal,
        priceFormatStyle: Decimal.FormatStyle.Currency,
        subscriptionPeriod: Self.SubscriptionPeriod? = nil,
        isTrialable: Bool = false
    ) {
        self.id                 = id
        self.title              = title
        self.description        = description
        self.price              = price
        self.priceFormatStyle   = priceFormatStyle
        self.subscriptionPeriod = subscriptionPeriod
        self.isTrialable        = isTrialable
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
    /// A convenience initializer to wrap a real StoreKit Product.
    init(skProduct: StoreKit.Product, isTrialable: Bool = false) {
        self.id                 = skProduct.id
        self.title              = skProduct.displayName
        self.description        = skProduct.description
        self.price              = skProduct.price as Decimal
        self.priceFormatStyle   = skProduct.priceFormatStyle
        self.subscriptionPeriod = Self.SubscriptionPeriod(
            skPeriod: skProduct.subscription?.subscriptionPeriod
        )
        self.isTrialable        = isTrialable
    }
}

extension FTProduct.SubscriptionPeriod {
    /// A convenience initializer to wrap a real StoreKit Product.SubscriptionPeriod.
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
    /// A convenience initializer to wrap a real StoreKit Product.PurchaseResult.
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
    static let mockWeekly = FTProduct(
        title:    "Weekly",
        description: "Unlock pro features for a month",
        price:    0.37,
        priceFormatStyle: .currency(code: "USD"),
        subscriptionPeriod: .weekly
    )
    static let mockMonthly = FTProduct(
        title:    "Monthly",
        description: "Unlock pro features for a month",
        price:    2.99,
        priceFormatStyle: .currency(code: "USD"),
        subscriptionPeriod: .monthly,
        isTrialable: true
    )
    static let mockYearly = FTProduct(
        title:    "Yearly",
        description: "Unlock pro features for a year",
        price:    29.99,
        priceFormatStyle: .currency(code: "USD"),
        subscriptionPeriod: .yearly
    )
    static let mockLifetime = FTProduct(
        title:    "Lifetime",
        description: "Unlock this app forever",
        price:    399.99,
        priceFormatStyle: .currency(code: "USD")
    )
}
