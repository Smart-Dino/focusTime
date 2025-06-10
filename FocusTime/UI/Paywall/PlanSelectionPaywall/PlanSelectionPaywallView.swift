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
        ZStack(alignment: .leading) {
            let selectedImageIndex = Binding {
                viewModel.state.selectedImageIndex
            } set: { index in
                viewModel.updateSelectedImageIndex(index: index)
            }
            
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: .zero) {
                        // Could use Array(zip(items.indices, items)
                        // but that is harder to understand...
                        ForEach(viewModel.state.backgroudImages.indices, id: \.self) { index in
                            let imageResource = viewModel.state.backgroudImages[index]
                            Image(imageResource)
                                .resizable()
                                .scaledToFit()
                                .containerRelativeFrame(.horizontal)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.paging)
                .scrollPosition(id: selectedImageIndex)
                
                // The images are behind the bottom VStack
                // and pushed to the top of the view
                Spacer()
            }
            VStack(alignment: .center) {
                // The content card is above the images
                // and pushed to the bottom
                Spacer()
                
                FTPageControlView(
                    viewModel.state.backgroudImages,
                    selectedItem: selectedImageIndex
                )
                // Should tell the design team to make it brighter?
                .foregroundTint(Color.ftPageControlBlue)
                
                VStack(spacing: .zero) {
                    if viewModel.superState.allProducts.isEmpty {
                        Spacer()
                        ProgressView()
                        Spacer()
                    } else {
                        features
                    }
                    
                    FTSubscribeButtonView(
                        terms: viewModel.state.subscribeButtonTerms,
                        buttonTitle: viewModel.state.primaryButtonTitle,
                        buttonAction: {
                            Task {
                                await viewModel.initiatePurchaseWithCurrentProduct()
                            }
                        }
                    )
                    .disabled(viewModel.superState.isButtonDisabled)
                    .padding()
                    
                    SubscriptionUtilityLinksView(
                        viewModel: .init(paymentManager: viewModel.getCurrentPaymentManager())
                    )
                }
                .containerRelativeFrame(.vertical, { amount, axis in
                    amount / 2.5
                })
                .padding()
                .padding(.bottom) // Padding, so we don't hit the safe area
                .background {
                    contentCard
                }
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
            Constants.Strings.errorHeader,
            isPresented: Binding(get: {
                viewModel.superState.error != nil
            }, set: { showError in
                viewModel.keepShowingError(showError: showError)
            }), actions: {
                // OK dismissal button by default
            }, message: {
                Text(viewModel.superState.error?.localizedDescription ?? "")
            }
        )
        .onAppear {
            viewModel.fetchIU()
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
                ForEach(viewModel.superState.allProducts) { product in
                    let isTrial = (product.trialPeriod != nil)
                    && (viewModel.superState.isEligibleForIntro)
                    
                    let subtitle: String? = isTrial
                    ? product.subscriptionPeriodDescription
                    : nil
                    
                    let descriptionText: String = isTrial
                    ? viewModel.getTrialTerms(for: product)
                    : product.priceString
                    
                    Button {
                        viewModel.selectProduct(product)
                    } label: {
                        FTProductOptionView(
                            leadingTitle: product.title,
                            leadingSubtitle: subtitle,
                            trailingDescription: descriptionText
                        )
                        .selected(viewModel.superState.selectedProduct == product)
                    }
                    .buttonStyle(.plain)
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
            // This will get addressed on the stage of incorporating
            // the business logic or navigation.
#warning("Dismiss action is empty")
            Button(
                Constants.Strings.dismissButtonTitle,
                systemImage: "xmark",
                action: {}
            )
        }
    }
}

#Preview("Trial unused") {
    PlanSelectionPaywallView(
        viewModel: .init(
            superPaywallVM: SuperPaywallViewModel(
                paymentManager: MockPaymentManagerWithPurchaseError(trialUsed: false)
            )
        )
    )
    .preferredColorScheme(.dark)
}

#Preview("Trial used") {
    NavigationStack {
        PlanSelectionPaywallView(
            viewModel: .init(
                superPaywallVM: SuperPaywallViewModel(
                    paymentManager: MockPaymentManagerWithPurchaseError(trialUsed: true)
                )
            )
        )
        .preferredColorScheme(.dark)
    }
}


#Preview("StoreKit Manager") {
    NavigationStack {
        PlanSelectionPaywallView(
            viewModel: .init(
                superPaywallVM: SuperPaywallViewModel(
                    paymentManager: StoreKitPaymentManager()
                )
            )
        )
        .preferredColorScheme(.dark)
    }
}
