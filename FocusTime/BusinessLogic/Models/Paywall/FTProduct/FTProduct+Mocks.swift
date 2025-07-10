//
//  FTProduct+Mocks.swift
//  FocusTime
//
//  Created by Maksym Horobets on 27.06.2025.
//

import Foundation

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
