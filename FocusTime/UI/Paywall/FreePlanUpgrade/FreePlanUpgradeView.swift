//
//  FreeplanUpgradeView.swift
//  FocusTime
//
//  Created by Maksym Horobets on 16.05.2025.
//

import SwiftUI
import FocusTimeUI

/// View, which displays the app's list of features and controls to subscribe.
struct FreePlanUpgradeView: View {
    // MARK: - Properties
    @State var viewModel: FreePlanUpgradeViewModel
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Image(.debugNightMountain)
                .resizable()
                .scaledToFill()
                .containerRelativeFrame([.horizontal])
            // VStack to push the elements down with a spacer.
            VStack {
                Spacer()
                VStack(spacing: Constants.Spacings.offerView) {
                    upgradePromptSection
                    
                    actionButtons
                        .padding(.vertical)
                    
                    SubscriptionUtilityLinksView(
                        viewModel: .init(paymentManager: viewModel.getCurrentPaymentManager())
                    )
                }
                .padding()
                .padding(.bottom) // Padding, so we don't hit the safe area
            }
        }
        .ignoresSafeArea()
        // Anything beyond xxLarge makes the UI look really bad.
        .dynamicTypeSize(...DynamicTypeSize.xxLarge)
        .toolbar {
            toolbarItems
        }
        .alert(
            Constants.Strings.errorHeader,
            isPresented: Binding(get: {
                viewModel.superState.error != nil
            }, set: { showError in
                viewModel.keepShowingError(showError: showError)
            }), actions: {
                // OK dismissal button by default
            }, message: {
                Text(viewModel.superState.error?.localizedDescription ?? "")
            }
        )
        .task {
            // Do NOT put these in the initializer
            await viewModel.fetchProducts()
            viewModel.selectRequestedProduct()
            viewModel.setupProductInfo()
        }
    }
    
    /// Text to upsell the user.
    private var upgradePromptSection: some View {
        Group {
            Text(Constants.Strings.title)
                .font(.title.bold())
            Text(Constants.Strings.upgradeMessage)
        }
    }
    
    /// Two main buttons on this screen.
    private var actionButtons: some View {
        VStack {
            FTSubscribeButtonView(
                terms: viewModel.state.trialPeriodDescription,
                buttonTitle: viewModel.state.purchaseButtonTitle,
                buttonAction: {
                    Task {
                        await viewModel.initiatePurchaseWithCurrentProduct()
                    }
                }
            )
            .disabled(viewModel.superState.isButtonDisabled)
            Button(
                Constants.Strings.viewPlansButton,
                action: viewModel.viewAllPlans
            )
            .buttonStyle(.plain)
            .opacity(0.8)
        }
    }
    
    /// Toolbar items.
    @ToolbarContentBuilder
    private var toolbarItems: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            // This will get adressed on the stage of incorporating
            // the business logic or navigation.
#warning("Dismiss action is empty")
            Button(
                Constants.Strings.dismissButtonTitle,
                systemImage: "xmark",
                action: {
                    // Dismiss this view with Flow Control in mind
                }
            )
        }
    }
    
}

// MARK: - Previews
#Preview("MockPaymentManagerWithError") {
    let productID = FTProduct.Mocks.weekly.product.id
    let paymentManager = MockPaymentManagerWithPurchaseError()
    NavigationStack {
        FreePlanUpgradeView(
            viewModel: .init(
                state: .init(requestedProductID: productID),
                superPaywallVM: .init(paymentManager: paymentManager)
            )
        )
        .preferredColorScheme(.dark)
    }
}

#Preview("NonTrialableProduct") {
    let productID = FTProduct.Mocks.monthly.product.id
    let paymentManager = MockPaymentManagerWithPurchaseError()
    NavigationStack {
        FreePlanUpgradeView(
            viewModel: .init(
                state: .init(requestedProductID: productID),
                superPaywallVM: .init(paymentManager: paymentManager)
            )
        )
        .preferredColorScheme(.dark)
    }
}

#Preview("StoreKitPaymentManager") {
    let productID = FTProduct.Mocks.monthly.product.id
    let paymentManager = StoreKitPaymentManager()
    NavigationStack {
        FreePlanUpgradeView(
            viewModel: .init(
                state: .init(requestedProductID: productID),
                superPaywallVM: .init(paymentManager: paymentManager)
            )
        )
        .preferredColorScheme(.dark)
    }
}
