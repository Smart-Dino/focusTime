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
        
        var error: Error?
        // Background Images
        let backgroudImages: [ImageResource] = [
            .debugNightMountain,
            .debugDayMountain
        ]
        var selectedImage: Int = .zero
        // Product-related
        var products: [FTProduct] = []
        /// - Important:
        /// Set this property through the `PlanSelectionPaywallViewModel.selectProduct(_:)`.
        fileprivate(set) var selectedProduct: FTProduct?
        
        // Trial view
        var isTrialUsed: Bool = false
        var trialOfferSubtitle: String = loadingMessage
        
        // Other
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
    func selectProduct(_ product: FTProduct?) {
        // Set selected product if not nil
        guard let product else { return }
        state.selectedProduct = product
        
        // Just a shortcut to constants
        let strShortcut = PlanSelectionPaywallView.Constants.Strings.self
        
        // Set title for subscribe button based on selected product
        state.primaryButtonTitle = product.isTrialable
        ? strShortcut.startFreeTrial
        : strShortcut.subscribeButtonTitle
        
        // Set terms above the subscribe button based on selected product
        state.subscribeButtonTerms = product.isTrialable
        ? strShortcut.noPaymentMessage
        : product.trialOfferSubtitle ?? strShortcut.paidOnce
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
            selectProduct(products.first(where: { $0.isTrialable }))
        } catch {
            state.error = error
        }
    }
    
    func subscribe() {
        Task {
            do {
                let _ = try await paymentManager.purchase(FTProduct.mockMonthly)
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
