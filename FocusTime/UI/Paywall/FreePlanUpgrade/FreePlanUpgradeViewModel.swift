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
        var superState: SuperPaywallViewModel.State!
        var error: Error? {
            superState.error
        }
        
        // Button state
        var isButtonDisabled = true
        
        // Dynamic strings
        static let stringConstants = FreePlanUpgradeView.Constants.Strings.self
        var purchaseButtonTitle    = stringConstants.tryButtonTitle
        var trialPeriodDescription = stringConstants.loadingMessage
    }
    
    // MARK: - Properties
    private(set) var state: State
    private var superPaywallVM: SuperPaywallViewModel
    
    // MARK: - Initializers
    init(
        state: State = State(),
        requestedProductID: String,
        superPaywallVM: SuperPaywallViewModel,
    ) {
        // Init
        self.state = state
        self.superPaywallVM = superPaywallVM
        superPaywallVM.delegate = self
        
        // Additional setup
        self.state.superState.requestedProductID = requestedProductID
        self.state.superState = superPaywallVM.state
        
    }
    
    // MARK: - Methods
    // MARK: State setter methods
    func keepShowingError(showError: Bool) {
        if !showError {
            state.superState.error = nil
        }
    }
    // MARK: Setup
    func getCurrentPaymentManager() -> PaymentManager {
        superPaywallVM.getCurrentPaymentManager()
    }
    
    func setupProductInfo() {
        guard let product = state.superState.product else {
            let error = PaymentError.productNotFound
            state.superState.error = error
            state.trialPeriodDescription = error.localizedDescription
            // Dismiss view?
            return
        }
        
        if let description = state.superState.product?.trialPeriodDescription {
            state.trialPeriodDescription = description
        }
    }
    
    func initiatePurchaseWithCurrentProduct() async {
        Task {
            var stateCopy = state.superState!
            await superPaywallVM.subscribeToCurrentRequestedProduct(state: &stateCopy)
            state.superState = stateCopy
        }
    }
    
    private func updateUIBasedOnPurchaseResult(_ purchaseResult: FTProduct.PurchaseResult) {
        switch purchaseResult {
        case .success:
            state.purchaseButtonTitle = State.stringConstants.subscribedMessage
            state.isButtonDisabled = true
            state.superState.error = nil

        case .pending:
            state.purchaseButtonTitle = State.stringConstants.pendingMessage
            state.isButtonDisabled = true
            state.superState.error = PaymentError.pending

        case .userCancelled:
            state.purchaseButtonTitle = State.stringConstants.tryButtonTitle
            state.isButtonDisabled = false
            state.superState.error = PaymentError.userCancelled
        }
    }
    
    func viewAllPlans() {
        // Tell the flow that the all plans view was requested
    }
}

extension FreePlanUpgradeViewModel: SuperPaywallViewModelDelegate {
    func didFinishLoadingProducts(_ products: [FTProduct]) {
    #warning("Method is not implemented")
    }
    
    func didFinishCurrentPurchaseWithResult(_ purchaseResult: FTProduct.PurchaseResult) {
        updateUIBasedOnPurchaseResult(purchaseResult)
    }
}
