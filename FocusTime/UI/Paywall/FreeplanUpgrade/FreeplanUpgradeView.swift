//
//  FreeplanUpgradeView.swift
//  FocusTime
//
//  Created by Maksym Horobets on 16.05.2025.
//

import SwiftUI
import FocusTimeUI

/// View, which displays the app's list of features and controls to subscribe.
struct FreeplanUpgradeView: View {
    // MARK: - Properties
    var viewModel: FreeplanUpgradeViewModel
    
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
                VStack(spacing: 15) {
                    upgradePromptSection
                    
                    actionButtons
                        .padding(.vertical)
                    
                    FTSubscriptionUtilityLinksView(
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
    }
    
    /// Text to upsell the user.
    private var upgradePromptSection: some View {
        Group {
            Text(Paywall.Upgrade.Strings.title)
                .font(.title.bold())
            Text(Paywall.Upgrade.Strings.upgradeMessage)
        }
    }
    
    /// Two main buttons on this screen.
    private var actionButtons: some View {
        VStack {
            FTSubscribeButtonView(
                terms: Paywall.Upgrade.Strings.trialTerms,
                buttonTitle: Paywall.Upgrade.Strings.tryButtonTitle,
                buttonAction: {}
            )
            Button(
                Paywall.Upgrade.Strings.viewPlansButton,
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
            // the business logic.
#warning("Dismiss action is empty.")
            Button(
                Paywall.Onboarding.Strings.dismissButtonTitle,
                systemImage: "xmark",
                action: {}
            )
            .buttonStyle(PlainButtonStyle())
        }
    }
    
}

#Preview {
    NavigationStack {
        FreeplanUpgradeView(
            viewModel: FreeplanUpgradeViewModel(actionDelegate: nil)
        )
        .preferredColorScheme(.dark)
    }
}
