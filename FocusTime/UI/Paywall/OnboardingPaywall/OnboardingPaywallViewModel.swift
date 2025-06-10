//
//  OnboardingPaywallViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 15.05.2025.
//

import Foundation

/// ViewModel, responsible for managing the logic on ``OnboardingPaywallView``.
/// - Note: Use it in the ``OnboadingPaywallView``.
@MainActor
@Observable
final class OnboardingPaywallViewModel {
    // MARK: - Nested declarations
    struct State {
        var requestedProductID: String
        
        // Dynamic strings
        static let stringConstants = OnboardingPaywallView.Constants.Strings.self
        var navigationTitle        = stringConstants.loadingTitle
        var trialPeriodDescription = stringConstants.loadingTitle
        var purchaseButtonTitle    = stringConstants.tryButtonTitle
    }
    
    // MARK: - Properties
    private(set) var state: State
    private(set) var superState: SuperPaywallViewModel.State!
    private let superPaywallVM: SuperPaywallViewModel
    private let flowDelegate: PaywallNavigationDelegate?
    
    // MARK: - Initializers
    init(
        state: State,
        superState: SuperPaywallViewModel.State = .init(),
        superPaywallVM: SuperPaywallViewModel,
        flowDelegate: PaywallNavigationDelegate?
    ) {
        self.state = state
        self.superPaywallVM = superPaywallVM
        self.superState = superState
        self.flowDelegate = flowDelegate
        superPaywallVM.delegate = self
    }
    
    
    // MARK: - Methods
    // MARK: State setter methods
    func keepShowingError(showError: Bool) {
        if !showError {
            superState.error = nil
        }
    }
    
    // MARK: Setup
    func fetchProducts() async {
        await superPaywallVM.fetchProducts(state: superState)
        superState.isButtonDisabled = false
    }
    
    func getCurrentPaymentManager() -> PaymentManager {
        superPaywallVM.getCurrentPaymentManager()
    }
    
    func getCurrentFlowDelegate() -> PaywallNavigationDelegate? {
        flowDelegate
    }
    
    func selectRequestedProduct() {
        superPaywallVM.selectProductWithID(state.requestedProductID, state: superState)
    }

    func setupProductInfo() {
        guard let product = superState.selectedProduct else {
            let error = PaymentError.productNotFound
            superState.error = error
            state.trialPeriodDescription = error.localizedDescription
            state.navigationTitle = State.stringConstants.errorHeader
            // Dismiss view?
            return
        }
        
        if let description = product.trialPeriodDescription {
            state.trialPeriodDescription = description
        }
        if let trialDuration = product.trialPeriodString {
            state.navigationTitle = """
            Get started with
            a \(trialDuration) free trial
            """
        }
    }
    
    private func updateUIBasedOnPurchaseResult() {
        guard let purchaseResult = superState.purchaseResult else { return }
        
        switch purchaseResult {
        case .success:
            state.purchaseButtonTitle = State.stringConstants.subscribedTitle
            superState.isButtonDisabled = true
            superState.error = nil
            
        case .pending:
            state.purchaseButtonTitle = State.stringConstants.pendingTitle
            superState.isButtonDisabled = true
            superState.error = PaymentError.pending
            
        case .userCancelled:
            state.purchaseButtonTitle = State.stringConstants.tryButtonTitle
            superState.isButtonDisabled = false
            superState.error = PaymentError.userCancelled
        }
    }
    
    // MARK: Actions
    func initiatePurchaseWithCurrentProduct() async {
        Task { [weak self] in
            guard let self else { return }
            
            await superPaywallVM.subscribeToCurrentRequestedProduct(state: superState)
        }
    }
    
    func dismissView() {
        flowDelegate?.paywallDidRequestDismissal()
    }
}

extension OnboardingPaywallViewModel: SuperPaywallViewModelDelegate {
    func didChangeUserEntitlementStatus(isPro: Bool) {
        superPaywallVM.updatePurchaseResultForSelectedProduct(state: superState)
        updateUIBasedOnPurchaseResult()
    }
}
