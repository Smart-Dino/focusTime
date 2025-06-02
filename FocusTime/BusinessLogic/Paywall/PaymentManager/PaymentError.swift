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
    case unknown

    /// A user-friendly description for each payment error.
    var errorDescription: String? {
        switch self {
        case .pending:
            "The purchase is pending approval, possibly requiring parental or bank authorization. You'll be notified once it's complete."
        case .userCancelled:
            "The purchase was cancelled by the user."
        case .failedVerification:
            "The purchase could not be verified. Please try again later."
        case .purchaseInProgress:
            "A purchase is already in progress. Please wait until it completes."
        case .productNotFound:
            "The requested product could not be found."
        case .unknown:
            "An unknown error occurred during the purchase."
        }
    }
}
