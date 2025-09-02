//
//  PaywallPresenter.swift
//  FocusTime
//
//  Created by Maksym Horobets on 01.09.2025.
//

import Foundation


@MainActor
protocol PaywallPresenter: AnyObject {
    var paywallCoordinator: PaywallPresenterDelegate? { get set }
    
    func requestPlanSelection()
    func requestFreePlan()
    func requestOnboarding()
}
