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
    }
    
    
    // MARK: - Properties
    private(set) var state: State
    private(set) var superState: SuperPaywallViewModel.State!
    private var superPaywallVM: SuperPaywallViewModel
    
    // MARK: - Initializers
    init(
        state: State = State(),
        superState: SuperPaywallViewModel.State = .init(),
        superPaywallVM: SuperPaywallViewModel
    ) {
        self.state = state
        self.superPaywallVM = superPaywallVM
        self.superState = superState
        superPaywallVM.delegate = self
    }
    
    // MARK: - State setter methods
    func getCurrentPaymentManager() -> PaymentManager {
        superPaywallVM.getCurrentPaymentManager()
    }
    
    func updateSelectedImageIndex(index: Int?) {
        state.selectedImageIndex = index
    }
    
    func keepShowingError(showError: Bool) {
        if !showError {
            superState.error = nil
        }
    }
    
    // MARK: - Methods
    func fetchIU() {
        Task { [weak self] in
            guard let self else { return }
            // Fetch products and select first
            await superPaywallVM.fetchProducts(state: superState)
            superPaywallVM.selectFirstProductIfNeeded(state: superState)
            
            // Check user's eligibility for free trial
            await superPaywallVM.isUserEligibleForTrial(state: superState)
            
            configureBottomSectionForSelectedProduct()
            
            print("FETCHED PRODUCTS")
        }
    }
    
    func selectProduct(_ product: FTProduct) {
        print("PlanSelectionPaywallViewModel instance:", ObjectIdentifier(self))
        superPaywallVM.selectProduct(product, state: superState)
        configureBottomSectionForSelectedProduct()
    }
    
    private func configurePurchaseButtonAvailabilityBasedOnSelectedProduct() {
        guard let product = superState.selectedProduct else { return }
        superState.isButtonDisabled = true
        
        Task { [weak self] in
            guard let self else { return }
            
            if await superPaywallVM.isProductPurchased(product) {
                superState.isButtonDisabled = true
                
                state.primaryButtonTitle =
                (product.subscriptionPeriod != nil)
                ? State.stringConstants.subscribedTitle
                : State.stringConstants.purchasedTitle
                
                
            } else {
                superState.isButtonDisabled = false
            }
        }
    }
    
    private func configureBottomSectionForSelectedProduct() {
        guard let product = superState.selectedProduct else { return }
        
        if product.trialPeriod != nil && superState.isEligibleForIntro {
            // Product is trialable and the user is eligible for trial
            state.primaryButtonTitle = State.stringConstants.startFreeTrial
            state.subscribeButtonTerms = State.stringConstants.noPaymentMessage
        } else if product.trialPeriod == nil || !superState.isEligibleForIntro {
            // No trial on product or it is already used
            let periodDesc = product.subscriptionPeriodDescription ?? State.stringConstants.paidOnce
            state.primaryButtonTitle = State.stringConstants.subscribeButtonTitle
            state.subscribeButtonTerms = periodDesc
        }
        
        configurePurchaseButtonAvailabilityBasedOnSelectedProduct()
    }
    
    func getTrialTerms(for product: FTProduct) -> String {
        "Get \(product.trialPeriodString ?? "0 days") for free!"
    }
    
    // MARK: Actions
    func initiatePurchaseWithCurrentProduct() async {
        Task { [weak self] in
            guard let self else { return }
            await superPaywallVM.subscribeToCurrentRequestedProduct(state: superState)
            configureBottomSectionForSelectedProduct()
        }
    }
}


extension PlanSelectionPaywallViewModel: SuperPaywallViewModelDelegate {
    func didChangeUserEntitlementStatus(isPro: Bool) {
        superPaywallVM.updatePurchaseResultForSelectedProduct(state: superState)
        configurePurchaseButtonAvailabilityBasedOnSelectedProduct()
        #warning("Dissmis?")
    }
}
