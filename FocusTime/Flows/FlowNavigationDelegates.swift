//
//  FlowNavigationDelegates.swift
//  FocusTime
//
//  Created by Maksym Horobets on 10.06.2025.
//

import Foundation

@MainActor
protocol PaywallNavigationDelegate: AnyObject {
    func paywallDidRequestPlanSelection()
    func paywallDidRequestDismissal()
}
