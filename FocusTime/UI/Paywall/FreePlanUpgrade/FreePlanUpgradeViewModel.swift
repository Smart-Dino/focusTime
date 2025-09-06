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
        
        var proState: ProState
        var superState: SuperPaywallViewModel.State
        
        // Dynamic strings
        static let stringConstants = FreePlanUpgradeView.Constants.Strings.self
        var purchaseButtonTitle    = stringConstants.loadingTitle
        var trialPeriodDescription = stringConstants.loadingTitle
        
        init(
            requestedProductID: String,
            proState: ProState,
            superState: SuperPaywallViewModel.State = .init()
        ) {
            self.requestedProductID = requestedProductID
            self.proState = proState
            self.superState = superState
        }
    }
    
    // MARK: - Properties
    private(set) var state: State
    private var superPaywallVM: SuperPaywallViewModel
    
    // The flow delegate property is accessed by SubscriptionUtilityLinksView in the view
    let flowDelegate: PaywallNavigationDelegate?
    
    private var analyticsManager: AnalyticsManagerProtocol

    // MARK: - Initializers
    init(
        state: State,
        superPaywallVM: SuperPaywallViewModel,
        flowDelegate: PaywallNavigationDelegate?,
        analyticsManager: AnalyticsManagerProtocol = LiveAnalyticsManager()
    ) {
        self.state = state
        self.superPaywallVM = superPaywallVM
        self.flowDelegate = flowDelegate
        self.analyticsManager = analyticsManager
        
        setupView()
    }
    
    func setupView() {
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
    
    func setupProductInfo() {
        guard let product = state.superState.selectedProduct else {
            let error = PaymentError.productNotFound
            state.superState.error = error
            state.trialPeriodDescription = error.localizedDescription
            // Dismiss view?
            return
        }
        
        state.purchaseButtonTitle = if product.trialPeriod != nil && state.superState.isEligibleForIntro {
            State.stringConstants.tryButtonTitle(product: product)
        } else {
            State.stringConstants.subscribeButtonTitle(product: product)
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
            setupProductInfo()
            state.superState.isButtonDisabled = false
        }
    }
    
    func initiatePurchaseWithCurrentProduct() async {
        /// - Analytics
        analyticsManager.logEvent(name: "free_plan_upgrade_purchase_initiated", parameters: nil)
        
        await superPaywallVM.subscribeToCurrentRequestedProduct(state: state.superState)
        updateUIBasedOnPurchaseResult()
    }
    
    func dismissView() {
        flowDelegate?.paywallDidRequestDismissal()
    }
    
    func viewAllPlans() {
        /// - Analytics
        analyticsManager.logEvent(name: "free_plan_upgrade_view_all_plans_tapped", parameters: nil)
        
        flowDelegate?.paywallDidRequestPlanSelection()
    }
    
    func onChangeOfIsPro() {
        Task {
            await self.superPaywallVM.updatePurchaseResultForSelectedProduct(
                state: self.state.superState
            )
            updateUIBasedOnPurchaseResult()
            
            if state.proState.status.isPro { flowDelegate?.paywallDidRequestDismissal() }
        }
    }
}
