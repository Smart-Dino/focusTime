//
//  FTProduct.swift
//  FocusTime
//
//  Created by Maksym Horobets on 19.05.2025.
//

import Foundation

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
    let subscriptionPeriod: Int?
    /// Declares whether this product has a trial option on it.
    let trialPeriod: Int?
    /// Tells if this product is meant to be a subscription.
    
    // MARK: - UI-specific properties
    let priceString: String
    let priceAndPeriodString: String?
    let periodString: String?
    let trialPeriodString: String?
    let trialOfferSubtitle: String?
    let subscriptionPeriodDescription: String?
    let trialPeriodDescription: String?
    
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
        trialPeriod: Int? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.price = price
        self.priceFormatStyle = priceFormatStyle
        self.subscriptionPeriod = subscriptionPeriod
        self.trialPeriod = trialPeriod
        self.priceString = price.formatted(priceFormatStyle)
        
        if let subscriptionPeriod {
            let periodStr = Self.periodDescription(from: subscriptionPeriod)
            self.periodString = periodStr
            self.priceAndPeriodString = "\(priceString) / \(periodStr)"
            self.subscriptionPeriodDescription = Self.subscriptionDescription(price: price, format: priceFormatStyle, period: periodStr)
            self.trialOfferSubtitle = "\(price.description) \(priceFormatStyle.currencyCode)/\(periodStr)"
        } else {
            self.periodString = nil
            self.priceAndPeriodString = nil
            self.subscriptionPeriodDescription = nil
            self.trialOfferSubtitle = nil
        }

        if let trialPeriod {
            let trialStr = Self.periodDescription(from: trialPeriod)
            self.trialPeriodString = trialStr
            self.trialPeriodDescription = "\(trialStr) free trial, then \(priceString), cancel anytime"
        } else {
            self.trialPeriodString = nil
            self.trialPeriodDescription = nil
        }
    }

    // MARK: - Helpers
    private static func periodDescription(from seconds: Int) -> String {
        PeriodConverter
            .approximateComponents(seconds: seconds)
            .descriptiveLargestUnitString
    }

    private static func subscriptionDescription(price: Decimal, format: Decimal.FormatStyle.Currency, period: String) -> String {
        "\(price.description) \(format.currencyCode) / \(period)"
    }

}


// MARK: - Mocks
extension FTProduct {
    enum Mocks {
        case weekly
        case monthly
        
        var product: FTProduct {
            get throws {
                switch self {
                case .weekly:
                    try FTProductBuilder()
                        .set(title: "Weekly")
                        .set(description: "Unlock pro features for a week")
                        .set(price: 0.37)
                        .set(currency: .currency(code: "USD"))
                        .set(subscriptionPeriod: PeriodConverter.weekly.durationInSeconds)
                        .set(trialPeriod: 86400 * 3)
                        .build()
                case .monthly:
                    try FTProductBuilder()
                        .set(title: "Monthly")
                        .set(description: "Unlock pro features for a month")
                        .set(price: 2.99)
                        .set(currency: .currency(code: "USD"))
                        .set(subscriptionPeriod: PeriodConverter.monthly.durationInSeconds)
                        .build()
                }
            }
        }
    }
}
