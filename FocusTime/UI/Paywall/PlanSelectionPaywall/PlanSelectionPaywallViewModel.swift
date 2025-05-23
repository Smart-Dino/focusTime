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
    var state: State
    
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
    
    // MARK: - Methods
    func selectProduct(_ product: FTProduct) async {
        state.selectedProduct = product

        // Suspend here until trial check completes
        // if for some reason it is empty
        if state.isTrialUsed == nil {
            await checkTrialAvailability()
        }

        configureBottomSectionForSelectedPtoduct(product)
    }
    
    private func configureBottomSectionForSelectedPtoduct(_ product: FTProduct) {
        // Just a shortcut to constants
        let S = PlanSelectionPaywallView.Constants.Strings.self
        // This should never be nil whenever this method is called
        // but we will still make sure it is not
        guard let isTrialUsed = state.isTrialUsed else { return }
        // If this product is trialable and the user hasn't used
        // their trial yet - we say it is available
        let useTrial: Bool = product.isTrialable && !isTrialUsed
        
        if useTrial {
            state.primaryButtonTitle = S.startFreeTrial
            state.subscribeButtonTerms = S.noPaymentMessage
        } else {
            var terms: String
            
            if product.isSubscription {
                let formatter = FTProductFormatter(product)
                // Should never fail since isSubscription
                // propery is only true when the product has
                // a subscription period
                terms = formatter.subscriptionPeriodString!
            } else {
                terms = S.paidOnce
            }
            
            state.primaryButtonTitle = S.subscribeButtonTitle
            state.subscribeButtonTerms = terms
        }
    }
    
    func getTrialOfferSubtitle(for product: FTProduct) -> String? {
        let formatter = FTProductFormatter(product)
        return formatter.subscriptionPeriodString
    }
    
    func checkTrialAvailability() async {
        self.state.isTrialUsed = await paymentManager.trialUsed
    }
    
    func loadOffers() async {
        do {
            // Load products
            let products = try await paymentManager.getProducts()
            state.products = products
            
            // Set initial selected product
            // If there are no products - we don't select anything
            if let trialableProduct = products.first(where: { $0.isTrialable }) {
                await selectProduct(trialableProduct)
            } else if let product = products.first {
                await selectProduct(product)
            }
        } catch {
            state.error = error
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
