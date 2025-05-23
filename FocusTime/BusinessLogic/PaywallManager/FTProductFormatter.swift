//
//  FTProductFormatter.swift
//  FocusTime
//
//  Created by Maksym Horobets on 23.05.2025.
//

import Foundation

struct FTProductFormatter: Sendable {
    private let product: FTProduct

    init(_ product: FTProduct) {
        self.product = product
    }

    var priceString: String {
        product.price.formatted(product.priceFormatStyle)
    }
    
    var periodString: String? {
        guard let period = product.subscriptionPeriod else { return nil }
        
        let components = PeriodConverter.components(
            fromSubscriptionSeconds: period
        )
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1

        guard let string = formatter.string(from: components) else {
            // This should ideally not happen with valid component.
            fatalError("Could not calculate string for components. Component: \(components).")
        }

        var strArray = string.components(separatedBy: .whitespaces)
        strArray.removeAll(where: { $0 == "1" })
        
        return strArray.joined(separator: " ")
    }

    var trialOfferSubtitle: String? {
        guard product.subscriptionPeriod != nil else { return nil }
        guard let periodString else { return nil }
        
        let code = product.priceFormatStyle.currencyCode
        return "\(product.price.description) \(code)/\(periodString)"
    }

    var subscriptionPeriodString: String? {
        guard let periodString else { return nil }

        return product.price.description + " " + product.priceFormatStyle.currencyCode + "/" + periodString
    }
}
