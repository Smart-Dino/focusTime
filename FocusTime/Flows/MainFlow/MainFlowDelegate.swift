//
//  AppFlowNavigationDelegates.swift
//  FocusTime
//
//  Created by Maksym Horobets on 31.07.2025.
//

import Foundation

@MainActor
protocol MainFlowDelegate: AnyObject {
    func didRequestOnboarding()
    func didRequestPaywallPlanSelection()
    func didRequestPaywallFreePlan()
    func didRequestMainFlow()
}
