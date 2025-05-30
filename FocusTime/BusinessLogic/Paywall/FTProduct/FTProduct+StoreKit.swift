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
        
        let subscriptionPeriod = skProduct.subscription?.subscriptionPeriod
        let periodInSeconds = PeriodConverter.customByUnit(
            value: subscriptionPeriod?.value,
            unit: subscriptionPeriod?.unit.ftUnit
        ).durationInSeconds
        
        let trialPeriod = skProduct.subscription?.introductoryOffer?.period
        let trialPeriodInSeconds = PeriodConverter.customByUnit(
            value: trialPeriod?.value,
            unit: trialPeriod?.unit.ftUnit
        ).durationInSeconds
        
        return try FTProductBuilder()
            .set(id: skProduct.id)
            .set(title: skProduct.displayName)
            .set(description: skProduct.description)
            .set(price: skProduct.price)
            .set(currency: skProduct.priceFormatStyle)
            .set(subscriptionPeriod: periodInSeconds)
            .set(trialPeriod: trialPeriodInSeconds)
            .build()
    }
}
