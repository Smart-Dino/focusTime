//
//  PaywallActionDelegate.swift
//  FocusTime
//
//  Created by Maksym Horobets on 16.05.2025.
//

/// Handles user actions originating from a paywall view.
@MainActor
protocol PaywallActionDelegate: AnyObject {
    /// Called when the user taps the subscribe action.
    func didTapSubscribe()
    /// Called when the user taps the restore purchase action.
    func didTapRestorePurchase()
    /// Called when the user taps to open terms of service.
    func didTapOpenTermsOfService()
    /// Called when the user taps to open the privacy policy.
    func didTapOpenPrivacy()
}
