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
            String(localized: "payment_error_pending_description", table: "PaywallLocalizable")
        case .userCancelled:
            String(localized: "payment_error_user_cancelled_description", table: "PaywallLocalizable")
        case .failedVerification:
            String(localized: "payment_error_failed_verification_description", table: "PaywallLocalizable")
        case .purchaseInProgress:
            String(localized: "payment_error_purchase_in_progress_description", table: "PaywallLocalizable")
        case .productNotFound:
            String(localized: "payment_error_product_not_found_description", table: "PaywallLocalizable")
        case .eligibilityCheckFail:
            String(localized: "payment_error_eligibility_check_fail_description", table: "PaywallLocalizable")
        case .unknown:
            String(localized: "payment_error_unknown_description", table: "PaywallLocalizable")
        }
    }
}
