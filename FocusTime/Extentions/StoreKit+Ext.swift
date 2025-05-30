//
//  StoreKit+Ext.swift
//  FocusTime
//
//  Created by Maksym Horobets on 29.05.2025.
//

import StoreKit

extension StoreKit.Product.SubscriptionPeriod.Unit {
    var ftUnit: PeriodConverter.Unit {
        switch self {
        case .day: .day
        case .week: .week
        case .month: .month
        case .year: .year
        @unknown default: fatalError("Unknown subscription period unit")
        }
    }
}
