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
                VStack(spacing: FreePlanUpgradeConstants.Spacings.offerView) {
                    upgradePromptSection
                    
                    actionButtons
                        .padding(.vertical)
                    
                    SubscriptionUtilityLinksView(
                        onTermsTapped: viewModel.openTermsOfService,
                        onPrivacyTapped: viewModel.openPrivacy,
                        onRestoreTapped: viewModel.restorePurchase
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
        .onAppear(perform: viewModel.loadPricing)
    }
    
    /// Text to upsell the user.
    private var upgradePromptSection: some View {
        Group {
            Text(FreePlanUpgradeConstants.Strings.title)
                .font(.title.bold())
            Text(FreePlanUpgradeConstants.Strings.upgradeMessage)
        }
    }
    
    /// Two main buttons on this screen.
    private var actionButtons: some View {
        VStack {
            FTSubscribeButtonView(
                terms: viewModel.state.trialTerms,
                buttonTitle: FreePlanUpgradeConstants.Strings.tryButtonTitle,
                buttonAction: {}
            )
            Button(
                FreePlanUpgradeConstants.Strings.viewPlansButton,
                action: viewModel.viewAllPlans
            )
            .buttonStyle(PlainButtonStyle())
            .opacity(0.8)
        }
    }
    
    /// Toolbar items.
    @ToolbarContentBuilder
    private var toolbarItems: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            // This will get adressed on the stage of incorporating
            // the business logic or navigation.
#warning("Dismiss action is empty.")
            Button(
                FreePlanUpgradeConstants.Strings.dismissButtonTitle,
                systemImage: "xmark",
                action: {}
            )
            .buttonStyle(PlainButtonStyle())
        }
    }
    
}

#Preview {
    NavigationStack {
        FreePlanUpgradeView(
            viewModel: .init(paymentManager: MockPaymentManager())
        )
        .preferredColorScheme(.dark)
    }
}
