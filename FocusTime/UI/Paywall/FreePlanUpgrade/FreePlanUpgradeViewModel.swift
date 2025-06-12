//
//  FreeplanUpgradeViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 16.05.2025.
//

import Foundation

/// ViewModel, responsible for managing the logic on ``FreePlanUpgradeView``.
/// - Note: Use it in the ``FreePlanUpgradeView``.
@MainActor
@Observable
final class FreePlanUpgradeViewModel {
    // MARK: - Nested declarations
    struct State {
        let requestedProductID: String
        var superState: SuperPaywallViewModel.State
        
        // Dynamic strings
        static let stringConstants = FreePlanUpgradeView.Constants.Strings.self
        var purchaseButtonTitle    = stringConstants.tryButtonTitle
        var trialPeriodDescription = stringConstants.loadingTitle
        
        init(
            requestedProductID: String,
            superState: SuperPaywallViewModel.State = .init()
        ) {
            self.requestedProductID = requestedProductID
            self.superState = superState
        }
    }
    
    // MARK: - Properties
    private(set) var state: State
    private var superPaywallVM: SuperPaywallViewModel
    
    // The flow delegate property is accessed by SubscriptionUtilityLinksView in the view
    let flowDelegate: PaywallNavigationDelegate?
    
    // MARK: - Initializers
    init(
        state: State,
        superPaywallVM: SuperPaywallViewModel,
        flowDelegate: PaywallNavigationDelegate?
    ) {
        self.state = state
        self.superPaywallVM = superPaywallVM
        self.flowDelegate = flowDelegate
        superPaywallVM.delegate = self
    }
    
    
    // MARK: - Methods
    // MARK: State setter methods
    func keepShowingError(showError: Bool) {
        if !showError {
            state.superState.error = nil
        }
    }
    
    // MARK: Setup
    func fetchProducts() async {
        await superPaywallVM.fetchProducts(state: state.superState)
        state.superState.isButtonDisabled = false
    }
    
    func selectRequestedProduct() {
        superPaywallVM.selectProductWithID(state.requestedProductID, state: state.superState)
    }
    
    func getCurrentPaymentManager() -> PaymentManager {
        superPaywallVM.getCurrentPaymentManager()
    }
    
    func setupProductInfo() {
        guard let product = state.superState.selectedProduct else {
            let error = PaymentError.productNotFound
            state.superState.error = error
            state.trialPeriodDescription = error.localizedDescription
            // Dismiss view?
            return
        }
        
        if let description = product.trialPeriodDescription {
            state.trialPeriodDescription = description
        }
    }
    
    func initiatePurchaseWithCurrentProduct() async {
        Task { [weak self] in
            guard let self else { return }
            
            await superPaywallVM.subscribeToCurrentRequestedProduct(state: state.superState)
            updateUIBasedOnPurchaseResult()
        }
    }
    
    private func updateUIBasedOnPurchaseResult() {
        guard let purchaseResult = state.superState.purchaseResult else { return }
        
        switch purchaseResult {
        case .success:
            state.purchaseButtonTitle = State.stringConstants.subscribedTitle
            state.superState.isButtonDisabled = true
            state.superState.error = nil
            
        case .pending:
            state.purchaseButtonTitle = State.stringConstants.pendingTitle
            state.superState.isButtonDisabled = true
            state.superState.error = PaymentError.pending
            
        case .userCancelled:
            state.purchaseButtonTitle = State.stringConstants.tryButtonTitle
            state.superState.isButtonDisabled = false
            state.superState.error = PaymentError.userCancelled
        }
    }
    
    func dismissView() {
        flowDelegate?.paywallDidRequestDismissal()
    }
    
    func viewAllPlans() {
        flowDelegate?.paywallDidRequestPlanSelection()
    }
}

extension FreePlanUpgradeViewModel: SuperPaywallViewModelDelegate {
    func didChangeUserEntitlementStatus(isPro: Bool) {
        Task { [weak self] in
            guard let self else { return }
            
            await self.superPaywallVM.updatePurchaseResultForSelectedProduct(
                state: self.state.superState
            )
            updateUIBasedOnPurchaseResult()
            
            if isPro { flowDelegate?.paywallDidRequestDismissal() }
        }
    }
}
