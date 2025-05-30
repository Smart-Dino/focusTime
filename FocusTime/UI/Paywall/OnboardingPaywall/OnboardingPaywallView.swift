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
                    
#warning("Action is empty")
                    FTSubscribeButtonView(
                        terms: viewModel.state.trialProduct?.trialPeriodDescription ?? Constants.Strings.paidOnce,
                        buttonTitle: Constants.Strings.tryButtonTitle,
                        buttonAction: {
                            viewModel.subscribeToFreeTrial()
                        }
                    )
                    .padding()
                    
                    SubscriptionUtilityLinksView(
                        onTermsTapped: viewModel.openTermsOfService,
                        onPrivacyTapped: viewModel.openPrivacy,
                        onRestoreTapped: viewModel.restorePurchase
                    )
                }
                .containerRelativeFrame(.vertical, { amount, axis in
                    amount / 1.8
                })
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
                viewModel.state.error != nil
            }, set: { showError in
                viewModel.updateError(showError: showError)
            }), actions: {
                // OK dismissal button by default
            }, message: {
                Text(viewModel.state.error?.localizedDescription ?? "")
            }
        )
        .task {
            await viewModel.loadFirstTrialOffer()
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
            ForEach(viewModel.state.featureItems) { item in
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
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    NavigationStack {
        OnboardingPaywallView(
            viewModel: .init(
                paymentManager: MockPaymentManagerWithPurchaseError()
            )
        )
        .preferredColorScheme(.dark)
    }
}
