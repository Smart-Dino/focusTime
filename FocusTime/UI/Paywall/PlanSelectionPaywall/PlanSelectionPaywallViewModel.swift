//
//  PlanSelectionPaywallViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 19.05.2025.
//

import SwiftUI

/// ViewModel, responsible for managing the logic on ``PlanSelectionPaywallView``.
/// - Note: Use it in the ``PlanSelectionPaywallView``.
@MainActor
@Observable
final class PlanSelectionPaywallViewModel {
    // MARK: - Nested declarations
    struct State {
        var superState: SuperPaywallViewModel.State
        
        // MARK: Background Images
        let backgroudImages: [ImageResource] = [
            .debugNightMountain,
            .debugDayMountain
        ]
        var selectedImageIndex: Int? = .zero
        
        // MARK: Other
        static let stringConstants = PlanSelectionPaywallView.Constants.Strings.self
        var primaryButtonTitle: String = stringConstants.loadingTitle
        var subscribeButtonTerms: String = ""
        
        init(superState: SuperPaywallViewModel.State = .init()) {
            self.superState = superState
        }
    }
    
    
    // MARK: - Properties
    private(set) var state: State
    private let superPaywallVM: SuperPaywallViewModel
    private let flowDelegate: PaywallNavigationDelegate?
    
    // MARK: - Initializers
    init(
        state: State = State(),
        superState: SuperPaywallViewModel.State = .init(),
        superPaywallVM: SuperPaywallViewModel,
        flowDelegate: PaywallNavigationDelegate?
    ) {
        self.state = state
        self.superPaywallVM = superPaywallVM
        self.flowDelegate = flowDelegate
        superPaywallVM.delegate = self
    }
    
    // MARK: - Get/Set methods
    func getCurrentPaymentManager() -> PaymentManager {
        superPaywallVM.getCurrentPaymentManager()
    }
    
    func getCurrentFlowDelegate() -> PaywallNavigationDelegate? {
        flowDelegate
    }
    
    func updateSelectedImageIndex(index: Int?) {
        state.selectedImageIndex = index
    }
    
    func keepShowingError(showError: Bool) {
        if !showError {
            state.superState.error = nil
        }
    }
    
    // MARK: - Methods
    func fetchProducts() async {
        await superPaywallVM.fetchProducts(state: state.superState)
    }
    
    func checkIfUserIsEligibleForFreeTrial() async {
        await superPaywallVM.isUserEligibleForTrial(state: state.superState)
    }
    
    func selectFirstProductIfNeeded() {
        superPaywallVM.selectFirstProductIfNeeded(state: state.superState)
    }
    
    func selectProduct(_ product: FTProduct) {
        superPaywallVM.selectProduct(product, state: state.superState)
        configureBottomSectionForSelectedProduct()
    }
    
    func configureBottomSectionForSelectedProduct() {
        guard let product = state.superState.selectedProduct else { return }
        
        if product.trialPeriod != nil && state.superState.isEligibleForIntro {
            // Product is trialable and the user is eligible for trial
            state.primaryButtonTitle = State.stringConstants.startFreeTrial
            state.subscribeButtonTerms = State.stringConstants.noPaymentMessage
        } else if product.trialPeriod == nil || !state.superState.isEligibleForIntro {
            // No trial on product or it is already used
            let periodDesc = product.subscriptionPeriodDescription ?? State.stringConstants.paidOnce
            state.primaryButtonTitle = State.stringConstants.subscribeButtonTitle
            state.subscribeButtonTerms = periodDesc
        }
        
        configurePurchaseButtonAvailabilityBasedOnSelectedProduct()
    }
    
    private func configurePurchaseButtonAvailabilityBasedOnSelectedProduct() {
        guard let product = state.superState.selectedProduct else { return }
        
        Task {
            if await superPaywallVM.isProductPurchased(product) {
                state.superState.isButtonDisabled = true
                
                state.primaryButtonTitle =
                (product.subscriptionPeriod != nil)
                ? State.stringConstants.subscribedTitle
                : State.stringConstants.purchasedTitle
                
                
            } else {
                state.superState.isButtonDisabled = false
            }
        }
    }
    
    func getTrialTerms(for product: FTProduct) -> String {
        "Get \(product.trialPeriodString ?? "0 days") for free!"
    }
    
    // MARK: Actions
    func initiatePurchaseWithCurrentProduct() async {
        await superPaywallVM.subscribeToCurrentRequestedProduct(state: state.superState)
        configureBottomSectionForSelectedProduct()
    }
    
    func dismissView() {
        flowDelegate?.paywallDidRequestDismissal()
    }
}


extension PlanSelectionPaywallViewModel: SuperPaywallViewModelDelegate {
    func didChangeUserEntitlementStatus(isPro: Bool) {
        Task {
            await self.superPaywallVM.updatePurchaseResultForSelectedProduct(
                state: self.state.superState
            )
            configurePurchaseButtonAvailabilityBasedOnSelectedProduct()
            
            if isPro { flowDelegate?.paywallDidRequestDismissal() }
        }
    }
}
