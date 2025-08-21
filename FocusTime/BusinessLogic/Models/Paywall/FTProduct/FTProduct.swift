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
    /// The subscription period in seconds
    let subscriptionPeriod: Int?
    /// The trial period in seconds. Declares whether this product has a trial option on it.
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
    
    var offerDescription: String {
        self.trialPeriodDescription ?? self.priceAndPeriodString ?? self.priceString
    }
    
    // MARK: - Initializer
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
            self.trialOfferSubtitle = "\(priceString)/\(periodStr)"
        } else {
            self.periodString = nil
            self.priceAndPeriodString = nil
            self.subscriptionPeriodDescription = nil
            self.trialOfferSubtitle = nil
        }

        if let trialPeriod {
            let trialStr = Self.periodDescription(from: trialPeriod)
            self.trialPeriodString = trialStr
            self.trialPeriodDescription = String(localized: "\(trialStr) free trial, then \(priceString), cancel anytime",
                                                 table: "PaywallLocalizable",
                                                 comment: "Trial period description with price")
        } else {
            self.trialPeriodString = nil
            self.trialPeriodDescription = nil
        }
    }

    // MARK: - Helpers
    private static func periodDescription(from seconds: Int) -> String {
        PeriodConverter
            .localizedConciseTimeString(from: seconds)
    }

    private static func subscriptionDescription(price: Decimal, format: Decimal.FormatStyle.Currency, period: String) -> String {
        let formattedPrice = price.formatted(format)
        return "\(formattedPrice) / \(period)"
    }

}
