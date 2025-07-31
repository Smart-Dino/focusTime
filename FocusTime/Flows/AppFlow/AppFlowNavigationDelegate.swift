//
//  AppFlowNavigationDelegates.swift
//  FocusTime
//
//  Created by Maksym Horobets on 31.07.2025.
//

import Foundation

protocol AppFlowNavigationDelegate {
    func didRequestOnboarding()
    func didRequestPaywallScreen(with: PaywallScreen)
    func didRequestMainFlow()
}
