//
//  PaywallView.swift
//  FocusTime
//
//  Created by Maksym Horobets on 15.05.2025.
//

import SwiftUI
import FocusTimeUI

/// `PaywallView`, which displays the app's list of features and controls to subscribe.
struct OnboardingPaywallView: View {
    // MARK: - Properties
    @State var viewModel: OnboardingPaywallViewModel
    
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
                Text("Get started with\n a 3 day free trial")
                    .font(.system(
                        size: Paywall.Onboarding.FontSize.navigationTitle,
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
                    topLeadingRadius: Paywall.Onboarding.CornerRadius.card,
                    topTrailingRadius: Paywall.Onboarding.CornerRadius.card
                )
            )
    }
    
    /// List of features.
    private var features: some View {
        VStack(alignment: .leading) {
            ForEach(viewModel.featureItems) { item in
                FTCheckmarkListItemView(item.title)
                    .padding(.vertical, Paywall.Onboarding.Padding.featureList)
            }
        }
    }
    
    /// This section includes the subscribe button as well as the text on top of it.
    private var subscribeButtonSection: some View {
        VStack {
            Text("3-day free trial, then $3 / month, cancel anytime")
                .font(.caption)
            Button("Try free and subscribe.", action: viewModel.subscribe)
                .buttonStyle(FTPrimaryButtonStyle())
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
