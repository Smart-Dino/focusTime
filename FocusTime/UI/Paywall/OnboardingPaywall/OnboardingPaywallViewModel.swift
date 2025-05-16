//
//  PaywallViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 15.05.2025.
//

import Foundation

/// `PaywallViewModel`, responsible for managing logic on the `PaywallView`.
/// - Note: Use it in the `PaywallView`.
@MainActor
@Observable
final class OnboardingPaywallViewModel {
    // MARK: - Nested declarations
    struct State {
        
    }
    
    // MARK: - Properties
    /// Property contatining values that may trigger UI redraw.
    private(set) var state: State
    
    // Made this property private becase it is injected
    // through the initializer, not a property.
    private weak var actionDelegate: PaywallActionDelegate?
    
    /// Main features of the paid 
    let featureItems: [PaywallFeatureItem] = [
        PaywallFeatureItem(title: "Unlimited repeating sessions"),
        PaywallFeatureItem(title: "Unlimited number of blocking apps"),
        PaywallFeatureItem(title: "Deep Focus mode"),
        PaywallFeatureItem(title: "White noise for better concentration"),
        PaywallFeatureItem(title: "Priority updates and new features")
    ]
    
    // MARK: - Initializers
    init(
        state: State = State(),
        actionDelegate: PaywallActionDelegate?
    ) {
        self.state = state
        self.actionDelegate = actionDelegate
    }
    
    // MARK: - Methods
    func subscribe() {
        actionDelegate?.didTapSubscribe()
    }
    
    func restorePurchase() {
        actionDelegate?.didTapRestorePurchase()
    }
    
    func openTermsOfService() {
        actionDelegate?.didTapOpenTermsOfService()
    }
    
    func openPrivacy() {
        actionDelegate?.didTapOpenPrivacy()
    }
    
}
