//
//  PlanSelectionPaywallView.swift
//  FocusTime
//
//  Created by Maksym Horobets on 19.05.2025.
//

import SwiftUI
import FocusTimeUI

/// View, which displays the app's list of features and controls to subscribe.
struct PlanSelectionPaywallView: View {
    // MARK: - Properties
    @State var viewModel: PlanSelectionPaywallViewModel
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .leading) {
            Image(.debugNightMountain)
                .resizable()
                .scaledToFill()
            // Used to prevent image from shifting off the screen
                .containerRelativeFrame([.horizontal])
                .ignoresSafeArea()
            VStack(alignment: .center) {
                Spacer()
                contentCard
                    .overlay {
                        VStack {
                            features
                            
                            FTSubscribeButtonView(
                                terms: "No payment due now!",
                                buttonTitle: FreePlanUpgradeConstants.Strings.tryButtonTitle,
                                buttonAction: {}
                            )
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
        .navigationTitle("Get DeepWave Pro")
        .navigationBarTitleDisplayMode(.inline)
//        .onAppear(perform: viewModel.loadPricing)
    }
    
    // MARK: - Computed properties
    /// Computes the shape underneath the feature list.
    private var contentCard: some View {
        Rectangle()
            .foregroundStyle(Color.ftBackground)
            .containerRelativeFrame(.vertical, { amount, axis in
                amount / 1.8
            })
    }
    
    /// List of features.
    private var features: some View {
        VStack(alignment: .leading, spacing: 20) {
            FTProductOptionView(
                leadingTitle: "Monthly",
                leadingSubtitle: "3 USD/month",
                trailingDescription: "Try Free For 3 days",
            )
            .descriptionStyle(Color.secondary)
            FTProductOptionView(
                leadingTitle: "Weekly",
                trailingDescription: "0.37 USD",
            )
            FTProductOptionView(
                leadingTitle: "Lifetime",
                trailingDescription: "399.9 USD",
            )
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
        PlanSelectionPaywallView(
            viewModel: .init(paymentManager: MockPaymentManager())
        )
        .preferredColorScheme(.dark)
    }
}
