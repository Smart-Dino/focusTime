//
//  PaywallPresenterDelegate.swift
//  FocusTime
//
//  Created by Maksym Horobets on 31.07.2025.
//

import Foundation

@MainActor
protocol PaywallPresenterDelegate: AnyObject {
    func didRequestOnboardingPaywall()
    func didRequestPlanSelectionPaywall()
    func didRequestFreePlanPaywall()
}
