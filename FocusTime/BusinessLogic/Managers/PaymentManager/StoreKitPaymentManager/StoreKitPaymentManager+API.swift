//
//  StoreKitPaymentManager+API.swift
//  FocusTime
//
//  Created by Maksym Horobets on 27.06.2025.
//

import StoreKit
import Foundation

// MARK: - Public Interface
extension StoreKitPaymentManager {
    func restorePurchases() async throws {
        try await AppStore.sync()
    }
    
    func isPurchased(_ product: FTProduct) async -> Bool {
        purchasedProducts.contains(product)
    }
    
    func productForID(_ id: String) throws(PaymentError) -> FTProduct {
        if let product = products.first(where: { $0.id == id }) {
            return product
        } else {
            throw .productNotFound
        }
    }
    
    func reloadData() async throws {
        try await getProducts()
        await updateCustomerProductStatus()
    }
    
    func eligibleForIntro(product: FTProduct) async throws(PaymentError) -> Bool {
        guard let skProduct = skProduct(for: product) else { throw .productNotFound }
        
        guard let renewableSubscription = skProduct.subscription else {
            // No renewable subscription is available for this product.
            return false
        }
        if await renewableSubscription.isEligibleForIntroOffer {
            // The product is eligible for an introductory offer.
            return true
        }
        return false
    }

    func purchase(_ product: FTProduct) async throws -> FTProduct.PurchaseResult? {
        let skProduct = skProduct(for: product)
        
        let result = try await skProduct?.purchase()
        
        switch result {
        case .success(let verificationResult):
            // Check whether the transaction is verified.
            // If it isn't - this function rethrows the verification error.
            let transaction = try checkVerified(verificationResult)
            
            await updateCustomerProductStatus()
            
            await transaction.finish()
            
            return .success
        case .userCancelled:
            return .userCancelled
        case .pending:
            return .pending
        default:
            return nil
        }
    }
}

// MARK: - AsyncStream
extension StoreKitPaymentManager {
    func isProUserChangesStream() -> AsyncStream<Bool> {
        let stream = AsyncStream<Bool> { continuation in
            self.continuation = continuation
        }
        
        self.continuation?.onTermination = { @Sendable reason in
            Task { await self.handleTermination(reason) }
        }
        
        return stream
    }
    
    func sendStreamUpdate(isPro: Bool) {
        guard let cont = continuation else {
            // Either: nobody’s listening yet, or they already cancelled.
            return
        }
        cont.yield(isPro)
    }
    
    private func handleTermination(_ reason: AsyncStream<Bool>.Continuation.Termination) {
        // Swift marked the stream as terminated,
        // finishing the continuation.
        continuation?.finish()
        continuation = nil
        
        // switch reason {
        //   case .cancelled:   …
        //   case .finished:    …
        // }
    }
}
