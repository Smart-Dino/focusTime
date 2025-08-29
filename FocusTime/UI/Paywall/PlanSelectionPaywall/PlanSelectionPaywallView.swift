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
            let selectedViewIndex = Binding {
                viewModel.state.selectedViewIndex
            } set: { index in
                viewModel.updateSelectedViewIndex(index: index)
            }
            
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: .zero) {
                        Group {
                            PlanSelectionFirstPromoView().id(0)
                            PlanSelectionSecondPromoView().id(1)
                        }
                        .containerRelativeFrame(.horizontal)
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.paging)
                .scrollPosition(id: selectedViewIndex)
            }
            .overlay {
                VStack {
                    Spacer()
                    FTPageControlView(
                        [0, 1],
                        selectedItem: selectedViewIndex
                    )
                    // Should tell the design team to make it brighter?
                    .foregroundTint(.ftMainBlue)
                }
            }
            
            VStack(spacing: .zero) {
                if viewModel.state.superState.allProducts.isEmpty {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else {
                    features
                }
                
                FTSubscribeButtonView(
                    terms: viewModel.state.subscribeButtonTerms,
                    buttonTitle: viewModel.state.primaryButtonTitle,
                    action: {
                        Task {
                            await viewModel.initiatePurchaseWithCurrentProduct()
                        }
                    }
                )
                .disabled(viewModel.state.superState.isButtonDisabled)
                .padding()
                
                SubscriptionUtilityLinksView(
                    viewModel: .init(
                        paymentManager: viewModel.getCurrentPaymentManager()
                    )
                )
            }
            .containerRelativeFrame(.vertical, { amount, _ in
                amount / 2.5
            })
            .padding()
            .padding(.bottom) // Padding, so we don't hit the safe area
            .background {
                contentCard
            }
        }
        .ignoresSafeArea(edges: .vertical)
        // Anything beyond Large breaks the UI on smaller screens.
        .dynamicTypeSize(...DynamicTypeSize.xLarge)
        .navigationTitle(
            Constants.Strings.navigationTitle
        )
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            toolbarItems
        }
        .alert(
            SharedConstants.Strings.errorHeader,
            isPresented: Binding(
                get: { viewModel.state.superState.error != nil },
                set: { viewModel.setErrorVisibility($0) }
            ),
            actions: { /* OK dismissal button by default */ },
            message: { Text(viewModel.state.superState.error?.localizedDescription ?? String()) }
        )
        .onChange(of: viewModel.state.proState.status) {
            viewModel.onChangeOfIsPro()
        }
    }
    
    // MARK: - Computed properties
    /// Computes the shape underneath the feature list.
    private var contentCard: some View {
        Rectangle()
            .foregroundStyle(Color.ftBackground)
    }
    
    /// List of features.
    private var features: some View {
        ScrollView(.vertical) {
            VStack(spacing: Constants.Padding.featuresSpacing) {
                ForEach(viewModel.state.superState.allProducts) { product in
                    setupCell(for: product)
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
            FTDismissToolbarButtonView(dismissAction: viewModel.dismissView)
        }
    }
    
    func setupCell(for product: FTProduct) -> some View {
        let isTrial = (product.trialPeriod != nil)
        && (viewModel.state.superState.isEligibleForIntro)
        
        let subtitle = isTrial
        ? viewModel.getTrialTerms(for: product)
        : nil
        
        let descriptionText = product.priceAndPeriodString ?? product.priceString
        
        return Button {
            viewModel.selectProduct(product)
        } label: {
            FTProductOptionView(
                leadingTitle: product.title,
                leadingSubtitle: subtitle,
                trailingDescription: descriptionText
            )
            .selected(viewModel.state.superState.selectedProduct == product)
        }
        .buttonStyle(.plain)
    }
}

#Preview("Trial unused") {
    let paymentManager = MockPaymentManagerWithPurchaseError(trialUsed: false)
    NavigationStack {
        PlanSelectionPaywallView(
            viewModel: .init(
                state: .init(proState: paymentManager.state), superPaywallVM: .init(paymentManager: paymentManager),
                flowDelegate: nil
            )
        )
        .preferredColorScheme(.dark)
    }
}

#Preview("Trial used") {
    let paymentManager = MockPaymentManagerWithPurchaseError(trialUsed: true)
    NavigationStack {
        PlanSelectionPaywallView(
            viewModel: .init(
                state: .init(proState: paymentManager.state), superPaywallVM: .init(paymentManager: paymentManager),
                flowDelegate: nil
            )
        )
        .preferredColorScheme(.dark)
    }
}
