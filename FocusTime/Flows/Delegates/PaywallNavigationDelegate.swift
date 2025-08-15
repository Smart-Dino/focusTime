//
//  FlowNavigationDelegates.swift
//  FocusTime
//
//  Created by Maksym Horobets on 10.06.2025.
//

import Foundation

@MainActor
protocol PaywallNavigationDelegate: AnyObject {
    /// Navigate to the full list of purchase options.
    func paywallDidRequestPlanSelection()
    /// View's request to dismiss itself.
    func paywallDidRequestDismissal()
    /// Request **Terms of Service**.
    func paywallDidRequestTermsOfService()
    /// Request **Privacy**.
    func paywallDidRequestPrivacyPolicy()
}
