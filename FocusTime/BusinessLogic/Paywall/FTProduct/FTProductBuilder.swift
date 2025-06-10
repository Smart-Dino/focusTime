//
//  FTProductBuilder.swift
//  FocusTime
//
//  Created by Maksym Horobets on 23.05.2025.
//

import Foundation

// Custom error for the builder
enum FTProductBuilderError: LocalizedError {
    case missingPrice
    case missingCurrency

    var errorDescription: String? {
        switch self {
        case .missingPrice:       "Product price is required."
        case .missingCurrency:    "Product currency format style is required."
        }
    }
}

final class FTProductBuilder {
    private var id: String?
    private var title: String?
    private var description: String?
    private var price: Decimal?
    private var priceFormatStyle: Decimal.FormatStyle.Currency?
    private var subscriptionPeriod: Int?
    private var trialPeriod: Int?

    init() {
        reset()
    }
    
    func reset() {
        self.id = nil
        self.title = nil
        self.description = nil
        self.price = nil
        self.priceFormatStyle = nil
        self.subscriptionPeriod = nil
        self.trialPeriod = nil
    }
    
    func set(id: String) -> Self {
        self.id = id
        return self
    }

    func set(title: String) -> Self {
        self.title = title
        return self
    }

    func set(description: String) -> Self {
        self.description = description
        return self
    }

    func set(price: Decimal) -> Self {
        self.price = price
        return self
    }

    func set(currency: Decimal.FormatStyle.Currency) -> Self {
        self.priceFormatStyle = currency
        return self
    }
    
    func set(subscriptionPeriod: Int?) -> Self {
        self.subscriptionPeriod = subscriptionPeriod
        return self
    }
    
    func set(trialPeriod: Int?) -> Self {
        self.trialPeriod = trialPeriod
        return self
    }

    func build() throws(FTProductBuilderError) -> FTProduct {
        guard let price = self.price else {
            throw .missingPrice
        }
        guard let priceFormatStyle = self.priceFormatStyle else {
            throw .missingCurrency
        }

        return FTProduct(
            id:                 self.id ?? UUID().uuidString,
            title:              title ?? "Product title",
            description:        description ?? "Product description",
            price:              price,
            priceFormatStyle:   priceFormatStyle,
            subscriptionPeriod: self.subscriptionPeriod,
            trialPeriod:        self.trialPeriod
        )
    }
}
