//
//  FTProduct+StoreKit.swift
//  FocusTime
//
//  Created by Maksym Horobets on 23.05.2025.
//

import Foundation
import StoreKit

extension FTProduct {
    /// Builds an FTProduct via LiveFTProductBuilder.
    ///
    /// - Throws: Any FTProductBuilderError if mandatory fields are missing.
    static func fromStoreKit(_ skProduct: StoreKit.Product) throws -> FTProduct {
        let unit: PeriodConverter.Unit? = switch skProduct.subscription?.subscriptionPeriod.unit {
        case .day: .day
        case .week: .week
        case .month: .month
        case .year: .year
        case .none: nil
        @unknown default: fatalError("Unknown subscription period unit")
        }
        
        // This will be nil if either value or the unit is nil
        let seconds = PeriodConverter.customByUnit(
            value: skProduct.subscription?.subscriptionPeriod.value,
            unit: unit
        ).durationInSeconds
        
        return try FTProductBuilder()
            .set(id: skProduct.id)
            .set(title: skProduct.displayName)
            .set(description: skProduct.description)
            .set(price: skProduct.price)
            .set(currency: skProduct.priceFormatStyle)
            .set(isTrialable: skProduct.subscription?.introductoryOffer != nil)
            .set(subscriptionPeriod: seconds)
            .build()
    }
}
