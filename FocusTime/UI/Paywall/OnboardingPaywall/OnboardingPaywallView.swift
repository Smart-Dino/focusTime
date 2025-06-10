//
//  OnboardingPaywallView.swift
//  FocusTime
//
//  Created by Maksym Horobets on 15.05.2025.
//

import SwiftUI
import FocusTimeUI

/// View, which displays the app's list of features and controls to subscribe.
struct OnboardingPaywallView: View {
    // MARK: - Properties
    @State var viewModel: OnboardingPaywallViewModel
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .leading) {
            Image(.debugNightMountain)
                .resizable()
                .scaledToFill()
            // Used to prevent image from shifting off the screen
                .containerRelativeFrame([.horizontal])
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                Text(viewModel.state.navigationTitle)
                    .font(.system(
                        size: Constants.FontSize.navigationTitle,
                        weight: .bold
                    ))
                    .foregroundColor(Color.white)
                    .padding()
                Spacer()
                VStack {
                    features
                    
                    FTSubscribeButtonView(
                        terms: viewModel.state.trialPeriodDescription,
                        buttonTitle: viewModel.state.purchaseButtonTitle,
                        buttonAction: {
                            Task {
                                await viewModel.initiatePurchaseWithCurrentProduct()
                            }
                        }
                    )
                    .padding()
                    .disabled(viewModel.state.isButtonDisabled)
                    
                    SubscriptionUtilityLinksView(
                        viewModel: .init(paymentManager: viewModel.getCurrentPaymentManager())
                    )
                }
                .containerRelativeFrame(.vertical) { amount, _ in
                    amount / 1.8
                }
                .padding()
                .background {
                    contentCard
                }
            }
            .ignoresSafeArea(edges: [.horizontal, .bottom])
        }
        // Anything beyond Large breaks the UI on smaller screens.
        .dynamicTypeSize(...DynamicTypeSize.large)
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
        .onAppear {
            // Do NOT put these in the initializer
            viewModel.fetchIU()
        }
    }
    
    // MARK: - Computed properties
    /// Computes the shape underneath the feature list.
    private var contentCard: some View {
        Rectangle()
            .foregroundStyle(Color.ftBackground)
            .clipShape(
                .rect(
                    topLeadingRadius: Constants.CornerRadius.card,
                    topTrailingRadius: Constants.CornerRadius.card
                )
            )
    }
    
    /// List of features.
    private var features: some View {
        VStack(alignment: .leading) {
            ForEach(Constants.FeatureItems.allCases) { item in
                FTCheckmarkListItemView(item.rawValue)
                    .padding(.vertical, Constants.Padding.featureList)
            }
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
                action: {}
            )
        }
    }
}

#Preview {
    NavigationStack {
        OnboardingPaywallView(
            viewModel: .init(
                requestedProductID: FTProduct.Mocks.weekly.product.id,
                superPaywallVM: SuperPaywallViewModel(
                    paymentManager: MockPaymentManagerWithPurchaseError()
                )
            )
        )
        .preferredColorScheme(.dark)
    }
}
