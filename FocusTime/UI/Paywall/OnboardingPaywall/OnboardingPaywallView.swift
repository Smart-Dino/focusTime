//
//  PaywallView.swift
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
        ZStack {
            // Background image pushed to the top of the view.
            VStack {
                Image(.debugNightMountain)
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFit()
                Spacer()
            }
            VStack(alignment: .leading) {
                // Text replicating Navigation Title, since
                // the Navigation Title does not support
                // multiline text.
                Text(OnboardingPaywall.Strings.navigationTitle)
                    .font(.system(
                        size: OnboardingPaywall.FontSize.navigationTitle,
                        weight: .bold
                    ))
                    .foregroundColor(Color.white)
                    .padding()
                Spacer()
                contentCard
                    .overlay {
                        VStack {
                            features
                            
                            FTSubscribeButtonView(
                                terms: OnboardingPaywall.Strings.trialTerms,
                                buttonTitle: OnboardingPaywall.Strings.tryButtonTitle,
                                buttonAction: viewModel.subscribe
                            )
                            .padding()
                            
                            FTSubscriptionUtilityLinksView(
                                onTermsTapped: viewModel.openTermsOfService,
                                onPrivacyTapped: viewModel.openPrivacy,
                                onRestoreTapped: viewModel.restorePurchase
                            )
                        }
                        .padding()
                    }
            }
            .ignoresSafeArea(edges: .bottom)
        }
        // Anything beyond Large breaks the UI on smaller screens.
        .dynamicTypeSize(...DynamicTypeSize.large)
        .toolbar {
            toolbarItems
        }
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
                    topLeadingRadius: OnboardingPaywall.CornerRadius.card,
                    topTrailingRadius: OnboardingPaywall.CornerRadius.card
                )
            )
    }
    
    /// List of features.
    private var features: some View {
        VStack(alignment: .leading) {
            ForEach(viewModel.featureItems) { item in
                FTCheckmarkListItemView(item.title)
                    .padding(.vertical, OnboardingPaywall.Padding.featureList)
            }
        }
    }
    
    /// Toolbar items.
    @ToolbarContentBuilder
    private var toolbarItems: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            // This will get adressed on the stage of incorporating
            // the business logic.
#warning("Dismiss action is empty.")
            Button(
                OnboardingPaywall.Strings.dismissButtonTitle,
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
            viewModel: OnboardingPaywallViewModel(actionDelegate: nil)
        )
        .preferredColorScheme(.dark)
    }
}
