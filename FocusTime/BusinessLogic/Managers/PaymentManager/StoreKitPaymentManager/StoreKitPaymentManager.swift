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
    static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "org.dino.smart.FocusTime",
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
    var continuation: AsyncStream<Bool>.Continuation?
    
    init(productIdentifiers: [String] = StoreKitProductIdentifiers.allCases.map { $0.id }) async {
        // FTProducts
        self.products = []
        self.purchasedProducts = []
        
        // StoreKit Products
        self.skProducts = []
        self.productIdentifiers = productIdentifiers
        
        await setup()
    }
    
    deinit {
        self.updateListenerTask?.cancel()
        continuation?.finish()
    }
    
    func setup() async {
        try? await reloadData()
        let task = listenForTransactions()
        self.updateListenerTask = task
    }
}

// MARK: - Internal Helpers
extension StoreKitPaymentManager {
    // PLEASE DO NOT USE MOCKS WITH THIS METHOD!
    // As they do not have appropriate IDs.
    func skProduct(for ftProduct: FTProduct) -> Product? {
        skProducts.first(where: { $0.id == ftProduct.id })
    }

    func checkVerified<T>(_ result: VerificationResult<T>) throws(PaymentError) -> T {
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

    func updateCustomerProductStatus() async {
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

    func listenForTransactions() -> Task<Void, Error> {
        return Task {
            //Iterate through any transactions that don't come from a direct call to `purchase()`.
            for await result in Transaction.updates {
                Self.logger.trace("New incoming transaction update: \(result.jwsRepresentation)")
                do {
                    let transaction = try self.checkVerified(result)
                    
                    // Deliver products to the user.
                    await self.updateCustomerProductStatus()
                    
                    // Always finish a transaction.
                    await transaction.finish()
                } catch {
                    //StoreKit has a transaction that fails verification. Don't deliver content to the user.
                    Self.logger.critical("StoreKit failed to verify transaction: \(error.localizedDescription)")
                }
            }
        }
    }

    func getProducts() async throws {
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
        self.products = ftProducts.sorted()
        self.skProducts = storeProducts
    }
}
