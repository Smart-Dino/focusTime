//
//  OnboardingPaywallViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 15.05.2025.
//

import Foundation

/// ViewModel, responsible for managing the logic on ``OnboardingPaywallView``.
/// - Note: Use it in the ``OnboardingPaywallView``.
@MainActor
@Observable
final class OnboardingPaywallViewModel {
    // MARK: - Nested declarations
    struct State {
        let requestedProductID: String
        var superState: SuperPaywallViewModel.State
        
        // Dynamic strings
        static let stringConstants = OnboardingPaywallView.Constants.Strings.self
        var trialPeriodDescription = stringConstants.loadingTitle
        var purchaseButtonTitle    = stringConstants.subscribeButtonTitle
        
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
        superPaywallVM.delegate = self
        
        setupView()
    }
    
    private func setupView() {
        Task {
            await fetchProducts()
            superPaywallVM.selectProductWithID(state.requestedProductID, state: state.superState)
            setupProductInfo()
        }
    }
    
    // MARK: - Methods
    // MARK: State setter methods
    func setErrorVisibility(_ isVisible: Bool) {
        if !isVisible {
            state.superState.error = nil
        }
    }
    
    // MARK: Setup
    func fetchProducts() async {
        await superPaywallVM.fetchProducts(state: state.superState)
        state.superState.isButtonDisabled = false
    }
    
    func getCurrentPaymentManager() -> PaymentManager {
        superPaywallVM.getCurrentPaymentManager()
    }
    
    func getCurrentFlowDelegate() -> PaywallNavigationDelegate? {
        flowDelegate
    }

    func setupProductInfo() {
        guard let product = state.superState.selectedProduct else {
            let error = PaymentError.productNotFound
            state.superState.error = error
            state.trialPeriodDescription = error.localizedDescription
            // Dismiss view?
            return
        }
        
        state.purchaseButtonTitle = if product.trialPeriod != nil {
            State.stringConstants.tryButtonTitle
        } else {
            State.stringConstants.subscribeButtonTitle
        }
        state.trialPeriodDescription = product.offerDescription
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
        }
    }
    
    // MARK: Actions
    func initiatePurchaseWithCurrentProduct() async {
        await superPaywallVM.subscribeToCurrentRequestedProduct(state: state.superState)
        updateUIBasedOnPurchaseResult()
    }
    
    func dismissView() {
        flowDelegate?.paywallDidRequestDismissal()
    }
}

extension OnboardingPaywallViewModel: SuperPaywallViewModelDelegate {
    func didChangeUserEntitlementStatus(isPro: Bool) {
        Task {
            await self.superPaywallVM.updatePurchaseResultForSelectedProduct(
                state: self.state.superState
            )
            updateUIBasedOnPurchaseResult()
            
            if isPro { flowDelegate?.paywallDidRequestDismissal() }
        }
    }
}
