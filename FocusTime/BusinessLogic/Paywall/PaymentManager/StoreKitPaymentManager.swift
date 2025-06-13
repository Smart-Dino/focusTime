//
//  StoreKitPaymentManager.swift
//  FocusTime
//
//  Created by Maksym Horobets on 27.05.2025.
//

import Foundation
import StoreKit
import os

actor StoreKitPaymentManager: PaymentManager {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: StoreKitPaymentManager.self)
    )
    
    // We do not need a property containing pending products:
    // https://developer.apple.com/forums/thread/706277
    
    // Status
    private(set) var isPro: Bool = false
    
    // FTProduct
    private(set) var products: [FTProduct]
    private(set) var purchasedProducts: [FTProduct]
    
    // StoreKit-related
    private var skProducts: [Product]
    private let productIdentifiers: [String]
    
    // Async updates
    private var updateListenerTask: Task<Void, Error>? = nil
    private var continuation: AsyncStream<Bool>.Continuation?
    
    init() {
        // FTProducts
        self.products = []
        self.purchasedProducts = []
        
        // StoreKit Products
        self.skProducts = []
        self.productIdentifiers = Self.loadProductIdentifiers()
        
        Task {
            await reloadData()
            let task = await listenForTransactions()
            await setTask(task)
        }
    }
    
    deinit {
        self.updateListenerTask?.cancel()
        continuation?.finish()
    }
}

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
    
    func reloadData() async {
        do {
            try await getProducts()
            await updateCustomerProductStatus()
        } catch {
            Self.logger.critical("Could not load products: \(error.localizedDescription)")
        }
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
    
    private func sendStreamUpdate(isPro: Bool) {
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

// MARK: - Internal Helpers
extension StoreKitPaymentManager {
    private func setTask(_ task: Task<Void, Error>) {
        self.updateListenerTask = task
    }

    // PLEASE DO NOT USE MOCKS WITH THIS METHOD
    private func skProduct(for ftProduct: FTProduct) -> Product? {
        skProducts.first(where: { $0.id == ftProduct.id })
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws(PaymentError) -> T {
        // Check whether the JWS passes StoreKit verification.
        switch result {
        case .unverified:
            // StoreKit parses the JWS, but it fails verification.
            throw .failedVerification
        case .verified(let safe):
            // The result is verified. Return the unwrapped value.
            return safe
        }
    }

    private func updateCustomerProductStatus() async {
        var purchasedProducts: [Product] = []
        
        // Iterate through all of the user's purchased products.
        for await result in Transaction.currentEntitlements {
            do {
                // Check whether the transaction is verified. If it isn’t, catch `failedVerification` error.
                let transaction = try checkVerified(result)
                
                // Get the corresponding product from the store.
                if let product = skProducts.first(where: { $0.id == transaction.productID }) {
                    purchasedProducts.append(product)
                }
            } catch {
                Self.logger.critical("Could not validate the transaction: \(error.localizedDescription)")
            }
        }
        
        Self.logger.trace("Successfully updated customer's products with \(purchasedProducts.count) products")
        
        // Convert to FTProduct.
        self.purchasedProducts = purchasedProducts.map {
            FTProduct.fromStoreKit($0)
        }
        
        // Update status.
        let status = !purchasedProducts.isEmpty
        isPro = status
        sendStreamUpdate(isPro: status)
    }

    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            //Iterate through any transactions that don't come from a direct call to `purchase()`.
            for await result in Transaction.updates {
                Self.logger.trace("New incoming transaction update: \(result.jwsRepresentation)")
                do {
                    let transaction = try await self.checkVerified(result)
                    
                    // Deliver products to the user.
                    await self.updateCustomerProductStatus()
                    
                    // Always finish a transaction.
                    await transaction.finish()
                } catch {
                    //StoreKit has a transaction that fails verification. Don't deliver content to the user.
                    Self.logger.critical("StoreKit failed to veriify transaction: \(error.localizedDescription)")
                }
            }
        }
    }

    private func getProducts() async throws {
        // Request products from the App Store.
        let storeProducts = try await Product.products(for: productIdentifiers)
        
        // Convert products into FTProducts.
        let ftProducts: [FTProduct] = storeProducts.map {
            FTProduct.fromStoreKit($0)
        }
        
        Self.logger.trace(
            "Successfully retrieved and converted \(storeProducts.count.description) StoreKit products into FTProducts"
        )
        
//        try? await Task.sleep(for: .seconds(3)) // Simulate loading.
        // Set the values.
        self.products = ftProducts.sortByTrialThenPrice()
        self.skProducts = storeProducts
    }
}

// MARK: - Static Helpers
extension StoreKitPaymentManager {
    private static func loadProductIdentifiers() -> [String] {
        StoreKitProductIdentifiers.allCases.map { $0.id }
    }
}
