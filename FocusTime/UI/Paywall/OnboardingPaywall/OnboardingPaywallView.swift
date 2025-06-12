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
            RadialGradient(
                colors: [
                    Constants.Gradient.glowColor,
                    Constants.Gradient.secondColor
                ],
                center: .top,
                startRadius: Constants.Gradient.startRadius,
                endRadius: Constants.Gradient.endRadius
            )
            .ignoresSafeArea()
            
            Image(.onboardingPaywallBackground)
                .resizable()
                .scaledToFill()
                .containerRelativeFrame([.vertical]) { amount, _ in
                    amount / 1.5
                }
                .scaleEffect(1.55, anchor: .leading)
            
            VStack(alignment: .leading) {
                
                VStack(alignment: .leading) {
                    Text(Constants.Strings.appName)
                        .font(.system(
                            size: Constants.FontSize.navigationTitle,
                            weight: .bold
                        ))
                        .foregroundColor(Color.white)
                    Text(Constants.Strings.appSlogan)
                        .font(.subheadline)
                        .foregroundStyle(.ftGray3)
                }
                .padding()
                
                Spacer()
                
                VStack {
                    Text(Constants.Strings.featuresTitle)
                        .font(.title2)
                        .bold()
                        .padding()
                    
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
                    .disabled(viewModel.state.superState.isButtonDisabled)
                    
                    SubscriptionUtilityLinksView(
                        viewModel: .init(
                            paymentManager: viewModel.getCurrentPaymentManager(),
                            flowDelegate: viewModel.getCurrentFlowDelegate()
                        )
                    )
                }
                .padding()
                .padding(.bottom) // Padding, so we don't hit the safe area
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
                viewModel.state.superState.error != nil
            }, set: { showError in
                viewModel.keepShowingError(showError: showError)
            }), actions: {
                // OK dismissal button by default
            }, message: {
                Text(viewModel.state.superState.error?.localizedDescription ?? "")
            }
        )
        .task {
            // Do NOT put these in the initializer
            await viewModel.fetchProducts()
            viewModel.selectRequestedProduct()
            viewModel.setupProductInfo()
        }
    }
    
    // MARK: - Computed properties
    /// Computes the shape underneath the feature list.
    private var contentCard: some View {
        Rectangle()
            .foregroundStyle(Color.onboardingPaywallContentPad)
            .opacity(0.6)
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
                FTListItemView(item.rawValue, systemImage: item.systemImage)
                    .padding(.vertical, Constants.Padding.featureList)
            }
        }
        .foregroundStyle(.ftGray3)
    }
    
    /// Toolbar items.
    @ToolbarContentBuilder
    private var toolbarItems: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            FTDismissToolbarButtonView(dismissAction: viewModel.dismissView)
        }
    }
}

#Preview {
    let paymentManager = MockPaymentManagerWithPurchaseError()
    NavigationStack {
        OnboardingPaywallView(
            viewModel: .init(
                state: .init(requestedProductID: FTProduct.Mocks.weekly.product.id),
                superPaywallVM: .init(paymentManager: paymentManager),
                flowDelegate: nil
            )
        )
        .preferredColorScheme(.dark)
    }
}
