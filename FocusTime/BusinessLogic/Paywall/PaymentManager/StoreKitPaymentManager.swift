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
    
    private(set) var products: [FTProduct]
    private(set) var purchasedProducts: [FTProduct]
    
    private var skProducts: [Product]
    
    private let productIdentifiers: [String: String]
    
    private var updateListenerTask: Task<Void, Error>? = nil
    
    var trialUsed: Bool {
        // StoreKit check
        return false
    }
    
    init() {
        // FTProducts
        self.products = []
        self.purchasedProducts = []
        // StoreKit Products
        self.skProducts = []
        
        self.productIdentifiers = Self.loadProductIdentifiers()

        Task {
            let task = await listenForTransactions()
            await setTask(task)
            
            do {
                try await getProducts()
                await updateCustomerProductStatus()
            } catch {
                Self.logger.critical("Could not load products: \(error.localizedDescription)")
            }
        }
    }
    
    private func setTask(_ task: Task<Void, Error>) {
        self.updateListenerTask = task
    }
    
    private static func loadProductIdentifiers() -> [String: String] {
        guard let path = Bundle.main.path(forResource: "StoreKitProductsIdentifiers", ofType: "plist") else {
            logger.critical("\(#function) - Could not find resource for path.")
            return [:]
        }
        guard let plist = FileManager.default.contents(atPath: path) else {
            logger.critical("Could not read the plist at \(path.debugDescription)")
            return [:]
        }
        guard let data = try? PropertyListSerialization.propertyList(from: plist, format: nil) as? [String: String] else {
            logger.critical("Could not serialize the plist at \(path.debugDescription)")
            return [:]
        }
        
        logger.trace("Successfully retrieved data from the plist: \(data.count.description)")
        return data
    }
    
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            //Iterate through any transactions that don't come from a direct call to `purchase()`.
            for await result in Transaction.updates {
                do {
                    let transaction = try await self.checkVerified(result)

                    //Deliver products to the user.
                    await self.updateCustomerProductStatus()

                    //Always finish a transaction.
                    await transaction.finish()
                } catch {
                    //StoreKit has a transaction that fails verification. Don't deliver content to the user.
                    Self.logger.critical("StoreKit failed to veriify transaction: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func getProducts() async throws {
        // Request products from the App Store using the identifiers that
        // the StoreKitProductIdentifiers.plist file defines
        let storeProducts = try await Product.products(for: productIdentifiers.keys)
        
        var ftProducts: [FTProduct] = []
        for product in storeProducts {
            let ftProduct = FTProduct.fromStoreKit(product)
            ftProducts.append(ftProduct)
        }
        Self.logger.trace("Successfully retrieved and converted \(storeProducts.count.description) StoreKit products into FTProducts")
        self.products = ftProducts.sortByTrialThenPrice()
        self.skProducts = storeProducts
    }
    
    func purchase(_ product: FTProduct) async throws -> FTProduct.PurchaseResult? {
        let skProduct = skProducts.first(where: { $0.id == product.id })
        
        let result = try await skProduct?.purchase()
        
        switch result {
        case .success(let verificationResult):
            //Check whether the transaction is verified
            // If it isn't - this function rethrows the verification error
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
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws(PaymentError) -> T {
        //Check whether the JWS passes StoreKit verification.
        switch result {
        case .unverified:
            //StoreKit parses the JWS, but it fails verification.
            throw .failedVerification
        case .verified(let safe):
            //The result is verified. Return the unwrapped value.
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
        self.purchasedProducts = purchasedProducts.map {
            FTProduct.fromStoreKit($0)
        }
    }
    
    func restorePurchases() async throws {
        #warning("Empty method")
    }
    
    func isPurchased(_ product: FTProduct) async throws -> Bool {
        purchasedProducts.contains(product)
    }
}
