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
        // Button state
        var isButtonDisabled = true
        
        // Dynamic strings
        static let stringConstants = FreePlanUpgradeView.Constants.Strings.self
        var purchaseButtonTitle    = stringConstants.tryButtonTitle
        var trialPeriodDescription = stringConstants.loadingTitle
    }
    
    // MARK: - Properties
    private(set) var state: State
    private(set) var superState: SuperPaywallViewModel.State!
    private var superPaywallVM: SuperPaywallViewModel
    
    // MARK: - Initializers
    init(
        state: State = State(),
        superState: SuperPaywallViewModel.State = .init(),
        requestedProductID: String,
        superPaywallVM: SuperPaywallViewModel,
    ) {
        // Init
        self.state = state
        self.superPaywallVM = superPaywallVM
        
        // Additional setup
        self.superState = superState
        
        superPaywallVM.selectProductWithID(requestedProductID, state: superState)
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
    
    private func updateUIBasedOnPurchaseResult(_ purchaseResult: FTProduct.PurchaseResult) {
        switch purchaseResult {
        case .success:
            state.purchaseButtonTitle = State.stringConstants.loadingTitle
            state.isButtonDisabled = true
            superState.error = nil

        case .pending:
            state.purchaseButtonTitle = State.stringConstants.loadingTitle
            state.isButtonDisabled = true
            superState.error = PaymentError.pending

        case .userCancelled:
            state.purchaseButtonTitle = State.stringConstants.tryButtonTitle
            state.isButtonDisabled = false
            superState.error = PaymentError.userCancelled
        }
    }
    
    func viewAllPlans() {
        // Tell the flow that the all plans view was requested
    }
}

extension FreePlanUpgradeViewModel: SuperPaywallViewModelDelegate {
    func didChangeUserEntitlementStatus(isPro: Bool) {
        #warning("Method is not implemented")
    }
}
