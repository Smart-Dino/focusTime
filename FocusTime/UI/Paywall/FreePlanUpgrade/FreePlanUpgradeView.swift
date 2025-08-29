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
            Image(
                ImageResource
                    .PaywallImages
                    .freePlanBackground
            )
            .resizable()
            .scaledToFill()
            .containerRelativeFrame([.horizontal])
            .scaleEffect(1.05, anchor: .bottom) // Scale it to the top a bit
            .overlay {
                Color.ftMainBlue.opacity(0.1)
            }
            .ignoresSafeArea()
            // VStack to push the elements down with a spacer.
            VStack(spacing: Constants.Spacings.offerView) {
                Spacer()
                upgradePromptSection
                
                actionButtons
                    .padding(.vertical)
                
                SubscriptionUtilityLinksView(
                    viewModel: .init(
                        paymentManager: viewModel.getCurrentPaymentManager()
                    )
                )
            }
            .padding()
            .containerRelativeFrame([.vertical])
        }
        // Anything beyond xxLarge makes the UI look really bad.
        .dynamicTypeSize(...DynamicTypeSize.xxLarge)
        .toolbar {
            toolbarItems
        }
        .alert(
            SharedConstants.Strings.errorHeader,
            isPresented: Binding(
                get: { viewModel.state.superState.error != nil },
                set: { viewModel.setErrorVisibility($0) }
            ),
            actions: { /* OK dismissal button by default */ },
            message: { Text(viewModel.state.superState.error?.localizedDescription ?? String()) }
        )
        .onChange(of: viewModel.state.proState.status) {
            viewModel.onChangeOfIsPro()
        }
    }
    
    /// Text to upsell the user.
    private var upgradePromptSection: some View {
        Group {
            Text(Constants.Strings.title)
                .font(.title3.bold())
            Text(Constants.Strings.upgradeMessage)
                .multilineTextAlignment(.center)
                .foregroundStyle(.ftGray3Light)
        }
    }
    
    /// Two main buttons on this screen.
    private var actionButtons: some View {
        VStack {
            FTSubscribeButtonView(
                terms: viewModel.state.trialPeriodDescription,
                buttonTitle: viewModel.state.purchaseButtonTitle,
                action: {
                    Task {
                        await viewModel.initiatePurchaseWithCurrentProduct()
                    }
                }
            )
            .disabled(viewModel.state.superState.isButtonDisabled)
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
            FTDismissToolbarButtonView(dismissAction: viewModel.dismissView)
        }
    }
    
}

// MARK: - Previews
#Preview("MockPaymentManagerWithError") {
    if let productID = try? FTProduct.Mocks.weekly.product.id {
        let paymentManager = MockPaymentManagerWithPurchaseError()
        NavigationStack {
            FreePlanUpgradeView(
                viewModel: .init(
                    state: .init(requestedProductID: productID, proState: paymentManager.state),
                    superPaywallVM: .init(paymentManager: paymentManager),
                    flowDelegate: nil
                )
            )
            .preferredColorScheme(.dark)
        }
    } else {
        Text("Could not initialize the product.")
    }
}

#Preview("NonTrialableProduct") {
    if let productID = try? FTProduct.Mocks.monthly.product.id {
        let paymentManager = MockPaymentManagerWithPurchaseError()
        NavigationStack {
            FreePlanUpgradeView(
                viewModel: .init(
                    state: .init(requestedProductID: productID, proState: paymentManager.state),
                    superPaywallVM: .init(paymentManager: paymentManager),
                    flowDelegate: nil
                )
            )
            .preferredColorScheme(.dark)
        }
    } else {
        Text("Could not initialize the product.")
    }
}
