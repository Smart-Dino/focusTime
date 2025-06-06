//
//  OnboardingPaywallViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 15.05.2025.
//

import Foundation
import StoreKit

/// ViewModel, responsible for managing the logic on ``OnboardingPaywallView``.
/// - Note: Use it in the ``OnboadingPaywallView``.
@MainActor
@Observable
final class OnboardingPaywallViewModel {
    // MARK: - Nested declarations
    struct State {
        var superState: SuperPaywallViewModel.State!
        var error: Error? {
            superState.error
        }
        
        // Button state
        var isButtonDisabled = true
        
        // Dynamic strings
        static let stringConstants = OnboardingPaywallView.Constants.Strings.self
        var navigationTitle        = stringConstants.loadingMessage
        var trialPeriodDescription = stringConstants.loadingMessage
        var purchaseButtonTitle    = stringConstants.tryButtonTitle
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
        
        // Additional setup
        self.state.superState = superPaywallVM.state
        self.state.superState.requestedProductID = requestedProductID

    }
    
    // MARK: - Methods
    
    // MARK: State setter methods
    
    func fetchIU() {
        Task {
            var stateCopy = state.superState!
            await superPaywallVM.fetchProducts(state: &stateCopy)
            print("FETCHED PRODUCTS")
            state.superState = stateCopy
            setupProductInfo()
            state.isButtonDisabled = false
        }
    }
    
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
    
    // MARK: Actions
    func initiatePurchaseWithCurrentProduct() async {
        Task {
            var stateCopy = state.superState!
            await superPaywallVM.subscribeToCurrentRequestedProduct(state: &stateCopy)
            state.superState = stateCopy
        }
    }
    
}

