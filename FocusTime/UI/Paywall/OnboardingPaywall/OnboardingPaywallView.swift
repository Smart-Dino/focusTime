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
    var viewModel: OnboardingPaywallViewModel
    
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
                Text(OnboardingPaywallConstants.Strings.navigationTitle)
                    .font(.system(
                        size: OnboardingPaywallConstants.FontSize.navigationTitle,
                        weight: .bold
                    ))
                    .foregroundColor(Color.white)
                    .padding()
                Spacer()
                contentCard
                    .overlay {
                        VStack {
                            features
                            
                            subscribeButtonSection
                                .padding()
                            
                            SubscriptionUtilityLinksView(
                                onTermsTapped: viewModel.openTermsOfService,
                                onPrivacyTapped: viewModel.openPrivacy,
                                onRestoreTapped: viewModel.restorePurchase
                            )
                        }
                        .padding()
                    }
            }
            .ignoresSafeArea(edges: [.horizontal, .bottom])
        }
        // Anything beyond Large breaks the UI on smaller screens.
        .dynamicTypeSize(...DynamicTypeSize.large)
        .toolbar {
            toolbarItems
        }
        .onAppear(perform: viewModel.loadPricing)
    }
    
    // MARK: - Computed properties
    /// Computes the shape underneath the feature list.
    private var contentCard: some View {
        Rectangle()
            .foregroundStyle(Color.ftBackground)
            .containerRelativeFrame(.vertical, { amount, axis in
                amount / 1.7
            })
            .clipShape(
                .rect(
                    topLeadingRadius: OnboardingPaywallConstants.CornerRadius.card,
                    topTrailingRadius: OnboardingPaywallConstants.CornerRadius.card
                )
            )
    }
    
    /// List of features.
    private var features: some View {
        VStack(alignment: .leading) {
            ForEach(viewModel.state.featureItems) { item in
                FTCheckmarkListItemView(item.rawValue)
                    .padding(.vertical, OnboardingPaywallConstants.Padding.featureList)
            }
        }
    }
    
    /// This section includes the subscribe button as well as the text on top of it.
    private var subscribeButtonSection: some View {
        VStack {
            Text(viewModel.state.trialTerms)
                .font(.caption)
            Button(
                OnboardingPaywallConstants.Strings.tryButtonTitle,
                action: viewModel.subscribe
            )
            .buttonStyle(FTPrimaryButtonStyle())
        }
    }
    
    /// Toolbar items.
    @ToolbarContentBuilder
    private var toolbarItems: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(
                OnboardingPaywallConstants.Strings.dismissButtonTitle,
                systemImage: "xmark",
                action: {}
            )
            .buttonStyle(PlainButtonStyle())
        }
    }
}

#Preview {
    NavigationStack {
        OnboardingPaywallView(
            viewModel: .init(paymentManager: MockPaymentManager())
        )
        .preferredColorScheme(.dark)
    }
}
