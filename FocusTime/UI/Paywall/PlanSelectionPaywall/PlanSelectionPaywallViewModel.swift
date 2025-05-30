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
        static let loadingMessage = PlanSelectionPaywallView.Constants.Strings.loadingMessage
        var error: Error? // Alerts are not implemented yet
        
        // MARK: Background Images
        let backgroudImages: [ImageResource] = [
            .debugNightMountain,
            .debugDayMountain
        ]
        var selectedImageIndex: Int? = .zero
        
        // MARK: Product-related
        var products: [FTProduct] = []
        /// - Important:
        /// Set this property through the `PlanSelectionPaywallViewModel.selectProduct(_:)`.
        fileprivate(set) var selectedProduct: FTProduct?
        
        // MARK: Trial view
        var isTrialUsed: Bool?
        var trialOfferSubtitle: String = loadingMessage
        
        // MARK: Other
        var primaryButtonTitle: String = loadingMessage
        var subscribeButtonTerms: String = loadingMessage
    }
    
    // MARK: - Properties
    /// Property contatining values that may trigger UI redraw.
    private(set) var state: State
    
    // Made this property private becase it is injected
    // through the initializer, not a property.
    private let paymentManager: PaymentManager
    
    // MARK: - Initializers
    init(
        state: State = State(),
        paymentManager: PaymentManager
    ) {
        self.state = state
        self.paymentManager = paymentManager
    }
    
    // MARK: - State setter methods
    func updateSelectedImageIndex(index: Int?) {
        state.selectedImageIndex = index
    }
    
    func updateError(showError: Bool) {
        if !showError {
            state.error = nil
        }
    }
    
    // MARK: - Methods
    func selectProduct(_ product: FTProduct) async {
        state.selectedProduct = product
        
        // Suspend here until trial check completes
        // if for some reason it is empty
        if state.isTrialUsed == nil {
            await checkTrialAvailability()
        }
        
        guard let isTrialUsed = state.isTrialUsed else {
            state.error = PlanSelectionPaywallError.missingTrialInfo
            return
        }
        
        configureBottomSectionForSelectedPtoduct(product, isTrialUsed: isTrialUsed)
        
    }
    
    private func configureBottomSectionForSelectedPtoduct(
        _ product: FTProduct,
        isTrialUsed: Bool
    ) {
        // Just a shortcut to constants
        let shortcut = PlanSelectionPaywallView.Constants.Strings.self
        
        // If this product is trialable and the user hasn't used
        // their trial yet - we say it is available
        let useTrial: Bool = product.trialPeriod != nil && !isTrialUsed
        
        if useTrial {
            state.primaryButtonTitle = shortcut.startFreeTrial
            state.subscribeButtonTerms = shortcut.noPaymentMessage
        } else {
            var terms: String
            
            if let periodDescription = product.subscriptionPeriodDescription {
                terms = periodDescription
            } else {
                terms = shortcut.paidOnce
            }
            
            state.primaryButtonTitle = shortcut.subscribeButtonTitle
            state.subscribeButtonTerms = terms
        }
    }
    
    func checkTrialAvailability() async {
        self.state.isTrialUsed = await paymentManager.trialUsed
    }
    
    func getTrialTerms(for product: FTProduct) -> String {
        "Get \(product.trialPeriodString ?? "0 days") for free!"
    }
    
    func loadOffers() async {
        // Load products
        let products = await paymentManager.products
        state.products = products
        
        // Set initial selected product
        // If there are no products - we don't select anything
        if let trialableProduct = products.first(where: { $0.trialPeriod != nil }) {
            await selectProduct(trialableProduct)
        } else if let product = products.first {
            await selectProduct(product)
        }
    }
    
    func subscribe(with product: FTProduct) {
        Task {
            do {
                let _ = try await paymentManager.purchase(product)
            } catch {
                state.error = error
            }
        }
    }
    
    func restorePurchase() {
        // I've decided to make this method sync to keep the visual harmony of
        // SubscriptionUtilityLinksView(
        //      onTermsTapped: viewModel.openTermsOfService,
        //      onPrivacyTapped: viewModel.openPrivacy,
        //      onRestoreTapped: viewModel.restorePurchase
        // )
        Task {
            do {
                try await paymentManager.restorePurchases()
            } catch {
                state.error = error
            }
        }
    }
    
    func openTermsOfService() {
        // Open ToS
    }
    
    func openPrivacy() {
        // Open Privacy
    }
    
}
