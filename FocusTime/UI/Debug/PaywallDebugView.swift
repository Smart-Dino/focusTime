//
//  StoreKitPaymentManagerDebugView.swift
//  FocusTime
//
//  Debug view for StoreKitPaymentManager using iOS 17 APIs
//

import SwiftUI
import StoreKit

struct StoreKitPaymentManagerDebugView: View {
    let paymentManager: PaymentManager
    
    @State private var products: [FTProduct] = []
    @State private var purchasedProducts: [FTProduct] = []
    @State private var trialUsed: Bool = false
    @State private var isRefreshing: Bool = false
    @State private var errorMessage: String?
    @State private var lastRefresh: Date = Date()
    
    var body: some View {
        NavigationStack {
            List {
                // Status Section
                Section("Manager Status") {
                    StatusRow(
                        title: "Trial Used",
                        value: trialUsed ? "Yes" : "No",
                        systemImage: trialUsed ? "checkmark.circle.fill" : "xmark.circle.fill",
                        color: trialUsed ? .red : .green
                    )
                    
                    StatusRow(
                        title: "Total Products",
                        value: "\(products.count)",
                        systemImage: "cart.fill",
                        color: .blue
                    )
                    
                    StatusRow(
                        title: "Purchased Products",
                        value: "\(purchasedProducts.count)",
                        systemImage: "checkmark.seal.fill", color: .green
                    )
                    
                    StatusRow(
                        title: "Last Refresh",
                        value: DateFormatter.debugFormatter.string(from: lastRefresh),
                        systemImage: "clock.fill", color: .orange
                    )
                }
                
                // Error Section
                if let errorMessage = errorMessage {
                    Section("Error") {
                        Label {
                            Text(errorMessage)
                                .foregroundStyle(.red)
                                .font(.caption)
                        } icon: {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.red)
                        }
                    }
                }
                
                // Products Section
                if !products.isEmpty {
                    Section("Available Products") {
                        ForEach(products, id: \.id) { product in
                            ProductDebugRow(
                                product: product,
                                isPurchased: purchasedProducts.contains(product),
                                paymentManager: paymentManager
                            )
                        }
                    }
                }
                
                // Purchased Products Section
                if !purchasedProducts.isEmpty {
                    Section("Purchased Products") {
                        ForEach(purchasedProducts, id: \.id) { product in
                            PurchasedProductRow(product: product)
                        }
                    }
                }
                
                // Actions Section
                Section("Actions") {
                    Button {
                        Task { await refreshData() }
                    } label: {
                        Label("Refresh Data", systemImage: "arrow.clockwise")
                    }
                    .disabled(isRefreshing)
                    
                    Button {
                        Task { await restorePurchases() }
                    } label: {
                        Label("Restore Purchases", systemImage: "arrow.down.circle")
                    }
                    .disabled(isRefreshing)
                }
            }
            .navigationTitle("Payment Manager Debug")
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                await refreshData()
            }
            .overlay {
                if isRefreshing {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.regularMaterial)
                }
            }
        }
        .task {
            await loadInitialData()
        }
    }
    
    @MainActor
    private func loadInitialData() async {
        await refreshData()
    }
    
    @MainActor
    private func refreshData() async {
        isRefreshing = true
        errorMessage = nil
        
        // Fetch all data from the actor
        async let productsTask = paymentManager.products
        async let purchasedTask = paymentManager.purchasedProducts
        async let trialUsedTask = paymentManager.trialUsed
        
        let fetchedProducts = await productsTask
        let fetchedPurchased = await purchasedTask
        let fetchedTrialUsed = await trialUsedTask
        
        products = fetchedProducts
        purchasedProducts = fetchedPurchased
        trialUsed = fetchedTrialUsed
        lastRefresh = Date()
        
        isRefreshing = false
    }
    
    @MainActor
    private func restorePurchases() async {
        isRefreshing = true
        errorMessage = nil
        
        do {
            try await paymentManager.restorePurchases()
            await refreshData()
        } catch {
            errorMessage = "Failed to restore purchases: \(error.localizedDescription)"
            isRefreshing = false
        }
    }
}

// MARK: - Supporting Views
struct StatusRow: View {
    let title: String
    let value: String
    let systemImage: String
    let color: Color
    
    var body: some View {
        HStack {
            Label {
                Text(title)
                    .font(.body)
            } icon: {
                Image(systemName: systemImage)
                    .foregroundStyle(color)
            }
            
            Spacer()
            
            Text(value)
                .font(.body.monospaced())
                .foregroundStyle(.secondary)
        }
    }
}

struct ProductDebugRow: View {
    let product: FTProduct
    let isPurchased: Bool
    let paymentManager: PaymentManager
    
    @State private var isPurchasing: Bool = false
    @State private var purchaseError: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.title)
                        .font(.headline)
                    
                    Text("ID: \(product.id)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textSelection(.enabled)
                    
                    Text(product.description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    if isPurchased {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(.green)
                    } else {
                        Text(product.priceString)
                            .font(.headline)
                            .foregroundStyle(.primary)
                    }
                }
            }
            
            if !isPurchased {
                Button {
                    Task { await purchaseProduct() }
                } label: {
                    HStack {
                        if isPurchasing {
                            ProgressView()
                                .scaleEffect(0.8)
                        }
                        Text(isPurchasing ? "Purchasing..." : "Purchase")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(isPurchasing)
            }
            
            if let error = purchaseError {
                Text("Error: \(error)")
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
        .padding(.vertical, 4)
    }
    
    @MainActor
    private func purchaseProduct() async {
        isPurchasing = true
        purchaseError = nil
        
        do {
            let result = try await paymentManager.purchase(product)
            
            switch result {
            case .success:
                // Purchase successful
                break
            case .userCancelled:
                purchaseError = "Purchase cancelled by user"
            case .pending:
                purchaseError = "Purchase is pending"
            case .none:
                purchaseError = "Unknown purchase result"
            }
        } catch {
            purchaseError = error.localizedDescription
        }
        
        isPurchasing = false
    }
}

struct PurchasedProductRow: View {
    let product: FTProduct
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(product.title)
                    .font(.body)
                
                Text("ID: \(product.id)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .textSelection(.enabled)
            }
            
            Spacer()
            
            Image(systemName: "checkmark.seal.fill")
                .foregroundStyle(.green)
        }
    }
}

// MARK: - Extensions
extension DateFormatter {
    static let debugFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        return formatter
    }()
}

// MARK: - Preview
#Preview {
    Text("Purchases do not work in previews.")
        .navigationTitle("Debug Preview")
}
