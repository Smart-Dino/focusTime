//
//  PaymentError.swift
//  FocusTime
//
//  Created by Maksym Horobets on 02.06.2025.
//

import Foundation

/// Represents errors that can occur during the payment process.
enum PaymentError: LocalizedError {
    // View-specific
    case pending
    case userCancelled
    // Other
    case failedVerification
    case purchaseInProgress
    case productNotFound
    // Eligibility
    case eligibilityCheckFail
    // Unknown
    case unknown

    /// A user-friendly description for each payment error.
    var errorDescription: String? {
        switch self {
        case .pending:
            String(localized: "The purchase is pending approval, possibly requiring parental or bank authorization. You'll be notified once it's complete.", table: "ErrorLocalizable")
        case .userCancelled:
            String(localized: "The purchase was cancelled by the user.", table: "ErrorLocalizable")
        case .failedVerification:
            String(localized: "The purchase could not be verified. Please try again later.", table: "ErrorLocalizable")
        case .purchaseInProgress:
            String(localized: "A purchase is already in progress. Please wait until it completes.", table: "ErrorLocalizable")
        case .productNotFound:
            String(localized: "The requested product could not be found.", table: "ErrorLocalizable")
        case .eligibilityCheckFail:
            String(localized: "Could not check whether the user is eligible for trial for the given subscription group.", table: "ErrorLocalizable")
        case .unknown:
            String(localized: "An unknown error occurred during the purchase.", table: "ErrorLocalizable")
        }
    }
}
