//
//  FreeplanUpgradeViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 16.05.2025.
//

import Foundation

/// ViewModel, responsible for managing logic on the ``FreeplanUpgradeView``.
/// - Note: Use it in the ``FreeplanUpgradeView``.
@MainActor
@Observable
final class FreeplanUpgradeViewModel {
    // MARK: - Nested declarations
    struct State {
        
    }
    
    // MARK: - Properties
    /// Property contatining values that may trigger UI redraw.
    private(set) var state: State
    
    // Made this property private becase it is injected
    // through the initializer, not a property.
    private weak var actionDelegate: PaywallActionDelegate?
    
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
    
    func viewAllPlans() {
        actionDelegate?.didTapViewAllPlans()
    }
    
    func openTermsOfService() {
        actionDelegate?.didTapOpenTermsOfService()
    }
    
    func openPrivacy() {
        actionDelegate?.didTapOpenPrivacy()
    }
    
}

