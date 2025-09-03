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
        var proState: ProState
        var superState: SuperPaywallViewModel.State
        
        var selectedViewIndex: Int? = .zero
        
        // MARK: Other
        static let stringConstants = PlanSelectionPaywallView.Constants.Strings.self
        var primaryButtonTitle: String = stringConstants.loadingTitle
        var subscribeButtonTerms: String = String()
        
        init(
            proState: ProState,
            superState: SuperPaywallViewModel.State = .init()
        ) {
            self.proState = proState
            self.superState = superState
        }
    }
    
    
    // MARK: - Properties
    private(set) var state: State
    private let superPaywallVM: SuperPaywallViewModel
    private let flowDelegate: PaywallNavigationDelegate?
    
    // MARK: - Initializers
    init(
        state: State,
        superPaywallVM: SuperPaywallViewModel,
        flowDelegate: PaywallNavigationDelegate?
    ) {
        self.state = state
        self.superPaywallVM = superPaywallVM
        self.flowDelegate = flowDelegate
        
        setupView()
    }
    
    func setupView() {
        Task {
            await fetchProducts()
            selectFirstProductIfNeeded()
            configureBottomSectionForSelectedProduct()
        }
    }
    
    // MARK: - Get/Set methods
    func getCurrentPaymentManager() -> PaymentManager {
        superPaywallVM.getCurrentPaymentManager()
    }
    
    func getCurrentFlowDelegate() -> PaywallNavigationDelegate? {
        flowDelegate
    }
    
    func updateSelectedViewIndex(index: Int?) {
        state.selectedViewIndex = index
    }
    
    func setErrorVisibility(_ isVisible: Bool) {
        if !isVisible {
            state.superState.error = nil
        }
    }
    
    // MARK: - Methods
    func fetchProducts() async {
        await superPaywallVM.fetchProducts(state: state.superState)
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
            state.subscribeButtonTerms = product.trialPeriodDescription ?? product.priceString
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
        let fallback = String(localized: "common_zero_days", table: "PaywallLocalizable")
        let formatString = String(localized: "plan_selection_get_trial_for_free", table: "PaywallLocalizable")
        return String(format: formatString, product.trialPeriodString ?? fallback)
    }
    
    // MARK: Actions
    func initiatePurchaseWithCurrentProduct() async {
        await superPaywallVM.subscribeToCurrentRequestedProduct(state: state.superState)
        configureBottomSectionForSelectedProduct()
    }
    
    func dismissView() {
        flowDelegate?.paywallDidRequestDismissal()
    }
    
    func onChangeOfIsPro() {
        Task {
            await self.superPaywallVM.updatePurchaseResultForSelectedProduct(
                state: self.state.superState
            )
            configurePurchaseButtonAvailabilityBasedOnSelectedProduct()
        }
    }
}
