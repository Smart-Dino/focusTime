//
//  LivePaywallPresenter.swift
//  FocusTime
//
//  Created by Maksym Horobets on 01.09.2025.
//

import Foundation

@MainActor
final class LivePaywallPresenter: PaywallPresenter {
    weak var paywallCoordinator: PaywallPresenterDelegate?

    func requestPlanSelection() {
        paywallCoordinator?.didRequestPlanSelectionPaywall()
    }

    func requestFreePlan() {
        paywallCoordinator?.didRequestFreePlanPaywall()
    }

    func requestOnboarding() {
        paywallCoordinator?.didRequestOnboardingPaywall()
    }
}
