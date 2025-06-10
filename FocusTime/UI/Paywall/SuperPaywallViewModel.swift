//
//  SuperPaywallViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 05.06.2025.
//

import Foundation

@MainActor
protocol SuperPaywallViewModelDelegate: AnyObject {
    func didChangeUserEntitlementStatus(isPro: Bool)
}

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
        //        var trialProducts: [FTProduct] {
        //            allProducts.filter({ $0.trialPeriod != nil })
        //        }
        
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
    // Made this private because there is no reason for anybody
    // to access it
    private var state: State
    
    private let paymentManager: PaymentManager
    private var subscriptionTask: Task<Void, Never>?
    
    // Delegation
    weak var delegate: SuperPaywallViewModelDelegate?
    
    // MARK: - Init, Deinit
    init(
        state: State = State(),
        paymentManager: PaymentManager
    ) {
        self.state = state
        self.paymentManager = paymentManager
        
        startListeningToSubscriptionUpdates()
    }
    
    // A deinitializer is called immediately before a class instance is deallocated
    // - so we should have access to self.state before it deinits?
    deinit {
        Task { [weak self] in
            await self?.subscriptionTask?.cancel()
        }
    }
    
    // MARK: - Private Methods
    
    private func startListeningToSubscriptionUpdates() {
        print(#function)
        subscriptionTask?.cancel()
        
        subscriptionTask = Task { [weak self] in
            guard let self else { return }
            for await isPro in await self.paymentManager.isProUserChangesStream() {
                self.delegate?.didChangeUserEntitlementStatus(isPro: isPro)
            }
        }
    }
    
    // MARK: Product selection
    
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
    
    func updatePurchaseResultForSelectedProduct(state: State) {
        Task { [weak self] in
            guard let self, let product = state.selectedProduct else { return }
            
            let isPurchased = await paymentManager.isPurchased(product)
            
            let result: FTProduct.PurchaseResult? = isPurchased ? .success : nil
            state.purchaseResult = result
        }
    }
    
    // MARK: - Public Methods
    func fetchProducts(state: State) async {
        await paymentManager.reloadData()
        let products = await paymentManager.products
        state.allProducts = products
    }
    
    func getCurrentPaymentManager() -> PaymentManager {
        paymentManager
    }
    
    func isProductPurchased(_ product: FTProduct) async -> Bool {
        await paymentManager.isPurchased(product)
    }
    
    // So far we only have one subscriptions group in our app,
    // so checking one product would automatically check if the user
    // is eligible for any type of introductory offer
    func isUserEligibleForTrial(state: State) async {
        guard let product = state.selectedProduct else {
            state.error = PaymentError.productNotFound
            return
        }
        do {
            state.isEligibleForIntro = try await paymentManager.eligibleForIntro(product: product)
        } catch {
            state.error = PaymentError.eligibilityCheckFail
        }
    }
    
    
    func subscribeToCurrentRequestedProduct(state: State) async {
        guard let product = state.selectedProduct else {
            state.error = PaymentError.productNotFound
            return
        }
        
        let wasEligibleForIntro = try? await paymentManager.eligibleForIntro(product: product)
        
        do {
            guard let result = try await paymentManager.purchase(product) else {
                state.error = PaymentError.unknown
                return
            }
            
            switch result {
            case .success:
                state.purchaseResult = .success
            case .userCancelled:
                state.purchaseResult = .userCancelled
            case .pending:
                guard product.trialPeriod == nil && !(wasEligibleForIntro ?? false) else {
                    // Then pretty sure it was a trial purchase so it is successful
                    state.purchaseResult = .success
                    delegate?.didChangeUserEntitlementStatus(isPro: true)
                    break
                }
                state.purchaseResult = .pending
                state.error = PaymentError.pending
                delegate?.didChangeUserEntitlementStatus(isPro: false)
            }
            
//            delegate?.didFinishCurrentPurchaseWithResult(result)
        } catch {
            state.error = error
        }
    }
    
}
