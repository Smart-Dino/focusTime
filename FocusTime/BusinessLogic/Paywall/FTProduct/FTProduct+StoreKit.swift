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
        var builder = FTProductBuilder()
            .set(id: skProduct.id)
            .set(title: skProduct.displayName)
            .set(description: skProduct.description)
            .set(price: skProduct.price)
            .set(currency: skProduct.priceFormatStyle)
            .set(isTrialable: skProduct.subscription?.introductoryOffer != nil)
        
        // Set subscription period if available
        if let period = skProduct.subscription?.subscriptionPeriod {
            let unit: PeriodConverter.Unit = switch period.unit {
            case .day: .day
            case .week: .week
            case .month: .month
            case .year: .year
            @unknown default: fatalError("Unknown subscription period unit")
            }
            
            let seconds = PeriodConverter.customByUnit(
                value: period.value,
                unit: unit
            ).durationInSeconds
            builder = builder.set(subscriptionPeriod: seconds)
        }
        
        return try builder.build()
    }
}
