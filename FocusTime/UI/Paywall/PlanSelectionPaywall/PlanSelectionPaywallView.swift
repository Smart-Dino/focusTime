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
        // Won't add zero to constants since it will never change
        VStack(alignment: .leading, spacing: .zero) {
            
            TabView {
                ForEach(viewModel.state.backgroudImages, id: \.self) { imageResource in
                    Image(imageResource)
                        .resizable()
                        .scaledToFill()
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            // This line fixes image shifing up when switching images
            // using the PageIndex
            // See: https://developer.apple.com/forums/thread/762286?page=1#840153022
            .background(.red.opacity(0.001))
            
            VStack(alignment: .center) {
                contentCard
                    .overlay {
                        VStack {
                            features
                            
                            FTSubscribeButtonView(
                                terms: viewModel.state.subscribeButtonTerms,
                                buttonTitle: viewModel.state.primaryButtonTitle,
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
                        .padding(.bottom) // Padding, so we don't hit the safe area
                    }
            }
        }
        .ignoresSafeArea(edges: .vertical)
        // Anything beyond Large breaks the UI on smaller screens.
        .dynamicTypeSize(...DynamicTypeSize.xLarge)
        .toolbar {
            toolbarItems
        }
        .navigationTitle(
            PlanSelectionPaywallConstants.Strings.navigationTitle
        )
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.checkTrialAvailability()
            await viewModel.loadOffers()
        }
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
        ScrollView(.vertical) {
            VStack(spacing: PlanSelectionPaywallConstants.Padding.featuresSpacing) {
                ForEach(viewModel.state.products) { product in
                    // Check if the user hasn't tried trial yet and offer him one
                    let isTrial = product.isTrialable && !viewModel.state.isTrialUsed
                    // Precompute to flatten the call site:
                    let subtitle: String? = isTrial
                        ? product.trialOfferSubtitle
                        : nil

                    let descriptionText: String = isTrial
                        ? PlanSelectionPaywallConstants.Strings.trialDescription
                        : product.priceString
                    // View
                    FTProductOptionView(
                        leadingTitle: product.title,
                        leadingSubtitle: subtitle,
                        trailingDescription: descriptionText
                    )
                    .selected(viewModel.state.selectedProduct == product)
                    .onTapGesture {
                        viewModel.selectProduct(product)
                    }
                }
            }
            // Add this padding to make sure the views don't get clipped
            // Feel like this does not have to be carried over to the
            // constants file since it will always be 1
            .padding(1)
        }
        // Disable scroll if all items fit on top of the contentCard
        .scrollBounceBehavior(.basedOnSize, axes: [.vertical])
    }
    
    /// Toolbar items.
    @ToolbarContentBuilder
    private var toolbarItems: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            // This will get adressed on the stage of incorporating
            // the business logic or navigation.
#warning("Dismiss action is empty.")
            Button(
                OnboardingPaywallConstants.Strings.dismissButtonTitle,
                systemImage: "xmark",
                action: {}
            )
            .buttonStyle(PlainButtonStyle())
        }
    }
}

#Preview("Trial unused") {
    NavigationStack {
        PlanSelectionPaywallView(
            viewModel: .init(
                paymentManager: MockPaymentManager(trialUsed: false)
            )
        )
        .preferredColorScheme(.dark)
    }
}

#Preview("Trial used") {
    NavigationStack {
        PlanSelectionPaywallView(
            viewModel: .init(
                paymentManager: MockPaymentManager(trialUsed: true)
            )
        )
        .preferredColorScheme(.dark)
    }
}
