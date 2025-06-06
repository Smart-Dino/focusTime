//
//  PlanSelectionPaywallViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 19.05.2025.
//
import SwiftUI
import StoreKit

/// ViewModel, responsible for managing the logic on ``PlanSelectionPaywallView``.
/// - Note: Use it in the ``PlanSelectionPaywallView``.
@MainActor
@Observable
final class PlanSelectionPaywallViewModel {
    // MARK: - Nested declarations
    struct State {
        var superState: SuperPaywallViewModel.State!
        var error: Error? { // Alerts are not implemented yet
            superState.error
        }
        var selectedProductID: String? {
            superState.requestedProductID
        }
        var products: [FTProduct] {
            superState.allProducts
        }
        
        
        // MARK: Background Images
        let backgroudImages: [ImageResource] = [
            .debugNightMountain,
            .debugDayMountain
        ]
        var selectedImageIndex: Int? = .zero
        
        // Button state
        var isButtonDisabled = true
        
        
        static let loadingMessage = PlanSelectionPaywallView.Constants.Strings.loadingMessage
        // MARK: Trial view
        var trialOfferSubtitle: String = loadingMessage
        
        // MARK: Other
        var primaryButtonTitle: String = loadingMessage
        var subscribeButtonTerms: String = ""
    }
    
    // MARK: - Properties
    private(set) var state: State
    private var superPaywallVM: SuperPaywallViewModel
    
    // MARK: - Initializers
    init(superPaywallVM: SuperPaywallViewModel) {
        self.superPaywallVM = superPaywallVM
        self.state = State(superState: superPaywallVM.state)
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
            state.superState.error = nil
        }
    }
    
    // MARK: - Methods
    func fetchIU() {
        Task {
            // Fetch products and select first
            var stateCopy = state.superState!
            await superPaywallVM.fetchProducts(state: &stateCopy)
            state.superState = stateCopy
            selectFirstProductIfNeeded()
            
            // Check user's eligibility for free trial
            stateCopy = state.superState!
            await superPaywallVM.isUserEligibleForTrial(state: &stateCopy)
            state.superState = stateCopy
            
            print("FETCHED PRODUCTS")
            state.isButtonDisabled = false
        }
    }
    
    func selectProduct(_ product: FTProduct) {
        // Immediately store the selected product ID so `superState.product` is correct:
        state.superState.requestedProductID = product.id
        
        configureBottomSection(for: product)
    }
    
    private func configureBottomSection(for product: FTProduct) {
        let shortcut = PlanSelectionPaywallView.Constants.Strings.self
        
        Task {
            if await superPaywallVM.isProductPurchased(product.id) {
                state.isButtonDisabled = true
            } else {
                state.isButtonDisabled = false
            }
        }
        
        if product.trialPeriod != nil {
            state.primaryButtonTitle = shortcut.startFreeTrial
            state.subscribeButtonTerms = shortcut.noPaymentMessage
            state.trialOfferSubtitle = "Get \(product.trialPeriodString ?? "0 days") free!"
        } else {
            // No trial or already used
            let periodDesc = product.subscriptionPeriodDescription ?? shortcut.paidOnce
            state.primaryButtonTitle = shortcut.subscribeButtonTitle
            state.subscribeButtonTerms = periodDesc
            state.trialOfferSubtitle = periodDesc
        }
    }
    
    func getTrialTerms(for product: FTProduct) -> String {
        "Get \(product.trialPeriodString ?? "0 days") for free!"
    }
    
    func selectFirstProductIfNeeded() {
        let products = state.superState.allProducts
        // If nothing selected yet, pick the first trialable, or the first overall:
        if state.superState.requestedProductID == nil {
            if let trialable = products.first(where: { $0.trialPeriod != nil }) {
                selectProduct(trialable)
            } else if let first = products.first {
                selectProduct(first)
            }
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


extension PlanSelectionPaywallViewModel: SuperPaywallViewModelDelegate {
    func didFinishCurrentPurchaseWithResult(_ purchaseResult: FTProduct.PurchaseResult) {
//        updateUIBasedOnPurchaseResult(purchaseResult)
        // Dissmis?
    }
}
