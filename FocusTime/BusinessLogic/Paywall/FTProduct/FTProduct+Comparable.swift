//
//  FTProduct+Comparable.swift
//  FocusTime
//
//  Created by Maksym Horobets on 27.06.2025.
//

import Foundation

extension FTProduct: Comparable {
    static func < (lhs: FTProduct, rhs: FTProduct) -> Bool {
        let lhsHasTrial = lhs.trialPeriod != nil
        let rhsHasTrial = rhs.trialPeriod != nil
        if lhsHasTrial == rhsHasTrial { // If both products are trial - sort by price instead.
            // Products with a trial come first
            return lhs.price < rhs.price
        } else { // Otherwise trial come first.
            return lhsHasTrial && !rhsHasTrial
        }
    }
}
