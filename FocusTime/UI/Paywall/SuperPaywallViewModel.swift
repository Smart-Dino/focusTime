//
//  SuperPaywallViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 05.06.2025.
//

import Foundation

@MainActor
//@Observable
final class SuperPaywallViewModel {
    // MARK: - Nested Declarations
    // This State was made a reference type so it can be passed and mutated
    // in a non-sendable way
    @Observable
    final class State {
        // Variables
        var error: Error?
        var purchaseResult: FTProduct.PurchaseResult?
        var isEligibleForIntro: Bool
        
        // Product
        var allProducts: [FTProduct] = []
        
        // Purchase
        var selectedProduct: FTProduct?
        var isButtonDisabled: Bool
        
        init(
            error: Error? = nil,
            purchaseResult: FTProduct.PurchaseResult? = nil,
            isEligibleForIntro: Bool = false,
            allProducts: [FTProduct] = [],
            selectedProduct: FTProduct? = nil,
            isButtonDisabled: Bool = true
        ) {
            self.error = error
            self.purchaseResult = purchaseResult
            self.isEligibleForIntro = isEligibleForIntro
            self.allProducts = allProducts
            self.selectedProduct = selectedProduct
            self.isButtonDisabled = isButtonDisabled
        }
    }
    
    // MARK: - Properties
    private let paymentManager: PaymentManager
    private var subscriptionTask: Task<Void, Never>?
    
    private var analyticsManager: AnalyticsManagerProtocol
    
    // MARK: - Init, Deinit
    init(
        paymentManager: PaymentManager,
        analyticsManager: AnalyticsManagerProtocol = LiveAnalyticsManager()
    ) {
        self.paymentManager = paymentManager
        self.analyticsManager = analyticsManager
    }
    
    deinit {
        self.subscriptionTask?.cancel()
        self.subscriptionTask = nil
    }
    
    // MARK: - Return
    func getProState() -> ProState {
        paymentManager.state
    }
    
    func getCurrentPaymentManager() -> PaymentManager {
        paymentManager
    }
    
    func isProductPurchased(_ product: FTProduct) async -> Bool {
        await paymentManager.isPurchased(product)
    }
    
    // MARK: - Product selection
    func selectProductWithID(_ id: String, state: State) {
        // We can replace this line with PaymentManager.productForID(_ id: ) instead.
        state.selectedProduct = state.allProducts.first(where: { $0.id == id })
    }
    
    func selectFirstProductIfNeeded(state: State) {
        // If nothing selected yet, pick the first trialable, or the first overall:
        if state.selectedProduct == nil {
            if let trialable = state.allProducts.first(where: { $0.trialPeriod != nil }) {
                selectProduct(trialable, state: state)
            } else if let first = state.allProducts.first {
                selectProduct(first, state: state)
            }
        }
    }
    
    func selectProduct(_ product: FTProduct, state: State) {
        // Immediately store the selected product ID so `superState.product` is correct:
        state.selectedProduct = product
    }
    
    // MARK: - Update state
    func fetchProducts(state: State) async {
        do {
            try await paymentManager.reloadData()
            let products = await paymentManager.products
            state.allProducts = products
            
            
            // So far we only have one subscriptions group in our app,
            // so checking one product would automatically check if the user
            // is eligible for any type of introductory offer
            if let first = products.first {
                state.isEligibleForIntro = try await paymentManager.eligibleForIntro(product: first)
            }
            
            /// - Analytics
            analyticsManager.logEvent(name: AnalyticsEventsConstants.PaywallViewModelsAnalyticsConstants.AnalyticsEvents.superPaywallProductsFetched.rawValue, parameters: [AnalyticsEventsConstants.PaywallViewModelsAnalyticsConstants.AnalyticsEventsParameters.productCount.rawValue: products.count])
            
        } catch {
            state.error = error
            
            /// - Analytics
            analyticsManager.logEvent(name: AnalyticsEventsConstants.PaywallViewModelsAnalyticsConstants.AnalyticsEvents.superPaywallFetchFailed.rawValue, parameters: [AnalyticsEventsConstants.PaywallViewModelsAnalyticsConstants.AnalyticsEventsParameters.error.rawValue: error.localizedDescription])
        }
    }
    
    func updatePurchaseResultForSelectedProduct(state: State) async {
        guard let product = state.selectedProduct else { return }
        
        let isPurchased = await paymentManager.isPurchased(product)
        
        let result: FTProduct.PurchaseResult? = isPurchased ? .success : nil
        state.purchaseResult = result
    }
    
    func subscribeToCurrentRequestedProduct(state: State) async {
        guard let product = state.selectedProduct else {
            state.error = PaymentError.productNotFound
            
            /// - Analytics
            analyticsManager.logEvent(name: AnalyticsEventsConstants.PaywallViewModelsAnalyticsConstants.AnalyticsEvents.superPaywallPurchaseFailed.rawValue, parameters: [AnalyticsEventsConstants.PaywallViewModelsAnalyticsConstants.AnalyticsEventsParameters.error.rawValue: AnalyticsEventsConstants.PaywallViewModelsAnalyticsConstants.AnalyticsEventsParameters.productNotFound.rawValue])
            
            return
        }
        
        do {
            guard let result = try await paymentManager.purchase(product) else {
                state.error = PaymentError.unknown
                
                /// - Analytics
                analyticsManager.logEvent(name: AnalyticsEventsConstants.PaywallViewModelsAnalyticsConstants.AnalyticsEvents.superPaywallPurchaseFailed.rawValue, parameters: [AnalyticsEventsConstants.PaywallViewModelsAnalyticsConstants.AnalyticsEventsParameters.error.rawValue: AnalyticsEventsConstants.PaywallViewModelsAnalyticsConstants.AnalyticsEventsParameters.unknown.rawValue])
                
                return
            }
            
            switch result {
            case .success:
                state.purchaseResult = .success
                /// - Analytics
                analyticsManager.logEvent(name: AnalyticsEventsConstants.PaywallViewModelsAnalyticsConstants.AnalyticsEvents.superPaywallPurchaseSucceeded.rawValue, parameters: [AnalyticsEventsConstants.PaywallViewModelsAnalyticsConstants.AnalyticsEventsParameters.productId.rawValue: product.id])
                
            case .userCancelled:
                state.purchaseResult = .userCancelled
                /// - Analytics
                analyticsManager.logEvent(name: AnalyticsEventsConstants.PaywallViewModelsAnalyticsConstants.AnalyticsEvents.superPaywallPurchaseCancelled.rawValue, parameters: [AnalyticsEventsConstants.PaywallViewModelsAnalyticsConstants.AnalyticsEventsParameters.productId.rawValue: product.id])
           
            case .pending:
                state.purchaseResult = .pending
                state.error = PaymentError.pending
                /// - Analytics
                analyticsManager.logEvent(name: AnalyticsEventsConstants.PaywallViewModelsAnalyticsConstants.AnalyticsEvents.superPaywallPurchasePending.rawValue, parameters: [AnalyticsEventsConstants.PaywallViewModelsAnalyticsConstants.AnalyticsEventsParameters.productId.rawValue: product.id])
            
            }
        } catch {
            state.error = error
            /// - Analytics
            analyticsManager.logEvent(name: AnalyticsEventsConstants.PaywallViewModelsAnalyticsConstants.AnalyticsEvents.superPaywallPurchaseFailed.rawValue, parameters: [AnalyticsEventsConstants.PaywallViewModelsAnalyticsConstants.AnalyticsEventsParameters.error.rawValue: error.localizedDescription])
        }
    }
    
}
