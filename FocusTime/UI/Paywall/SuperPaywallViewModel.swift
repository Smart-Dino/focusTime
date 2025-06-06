//
//  SuperPaywallViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 05.06.2025.
//

import Foundation

@MainActor
protocol SuperPaywallViewModelDelegate: AnyObject {
    func didFinishCurrentPurchaseWithResult(_ purchaseResult: FTProduct.PurchaseResult)
}

@MainActor
@Observable
final class SuperPaywallViewModel {
    // MARK: - Nested Declarations
    struct State {
        // Variables
        var error: Error?
        var purchaseResult: FTProduct.PurchaseResult?
        var isEligibleForIntro = false
        
        // Product
        var allProducts: [FTProduct] = []
        //        var trialProducts: [FTProduct] {
        //            allProducts.filter({ $0.trialPeriod != nil })
        //        }
        
        // Purchase
        var requestedProductID: String? = nil
        var product: FTProduct? {
            allProducts.first(where: {$0.id == requestedProductID})
        }
    }
    
    // MARK: - Properties
    private(set) var state: State
    
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
        subscriptionTask?.cancel()
        
        subscriptionTask = Task { [weak self] in
            guard let self else { return }
            for await _ in await self.paymentManager.isProUserChangesStream() {
                self.updatePurchaseResult()
            }
        }
    }
    
    private func updatePurchaseResult() {
        Task { [weak self] in
            guard let self, let product = state.product else { return }
            
            let isPurchased = await paymentManager.isPurchased(product)
            
            let result: FTProduct.PurchaseResult? = isPurchased ? .success : nil
            state.purchaseResult = result
            
            if let result {
                delegate?.didFinishCurrentPurchaseWithResult(result)
            }
        }
    }
    
    // MARK: - Public Methods
    func fetchProducts(state: inout State) async {
        let products = await paymentManager.products
        state.allProducts = products
    }
    
    func getCurrentPaymentManager() -> PaymentManager {
        paymentManager
    }
    
    func isProductPurchased(_ productID: String) async -> Bool {
        await paymentManager.purchasedProducts.contains(where: { $0.id == productID })
    }
    
    // So far we only have one subscriptions group in our app,
    // so checking one product would automatically check if the user
    // is eligible for any type of introductory offer
    func isUserEligibleForTrial(state: inout State) async {
        guard let product = state.product else {
            state.error = PaymentError.productNotFound
            return
        }
        do {
            state.isEligibleForIntro = try await paymentManager.eligibleForIntro(product: product)
        } catch {
            state.error = PaymentError.eligibilityCheckFail
        }
    }
    
    
    func subscribeToCurrentRequestedProduct(state: inout State) async {
        guard let product = state.product else {
            state.error = PaymentError.productNotFound
            return
        }
        
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
                state.purchaseResult = .pending
            }
            
            delegate?.didFinishCurrentPurchaseWithResult(result)
        } catch {
            state.error = error
        }
    }
    
    
    
}
