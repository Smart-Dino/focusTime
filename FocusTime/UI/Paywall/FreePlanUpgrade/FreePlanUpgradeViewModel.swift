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
        var requestedProductID: String
        
        // Dynamic strings
        static let stringConstants = FreePlanUpgradeView.Constants.Strings.self
        var purchaseButtonTitle    = stringConstants.tryButtonTitle
        @SafeSharedValue(factory: { .init() }) var superState: SuperPaywallViewModel.State
        var trialPeriodDescription = stringConstants.loadingTitle
    }
    
    // MARK: - Properties
    private(set) var state: State
    private(set) var superState: SuperPaywallViewModel.State!
    private var superPaywallVM: SuperPaywallViewModel
    
    // The flow delegate property is accessed by SubscriptionUtilityLinksView in the view
    let flowDelegate: PaywallNavigationDelegate?
    
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
    
    func selectRequestedProduct() {
        superPaywallVM.selectProductWithID(state.requestedProductID, state: superState)
    }
    
    func getCurrentPaymentManager() -> PaymentManager {
        superPaywallVM.getCurrentPaymentManager()
    }
    
    func setupProductInfo() {
        guard let product = superState.selectedProduct else {
            let error = PaymentError.productNotFound
            superState.error = error
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
            
            await superPaywallVM.subscribeToCurrentRequestedProduct(state: superState)
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
            state.purchaseButtonTitle = State.stringConstants.loadingTitle
            superState.isButtonDisabled = true
            superState.error = PaymentError.pending

        case .userCancelled:
            state.purchaseButtonTitle = State.stringConstants.tryButtonTitle
            superState.isButtonDisabled = false
            superState.error = PaymentError.userCancelled
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
        superPaywallVM.updatePurchaseResultForSelectedProduct(state: superState)
        updateUIBasedOnPurchaseResult()
    }
}
