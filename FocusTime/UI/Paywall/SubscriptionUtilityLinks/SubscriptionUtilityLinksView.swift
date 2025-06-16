//
//  SubscriptionUtilityLinksView.swift
//  FocusTime
//
//  Created by Maksym Horobets on 16.05.2025.
//

import SwiftUI
import FocusTimeUI

/// A view displaying standard subscription utility links: "Terms", "Privacy", and "Restore Purchase".
struct SubscriptionUtilityLinksView: View {
    // MARK: - Properties
    @State var viewModel: SubscriptionUtilityLinksViewModel
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: Constants.Spacings.horizontalSpacing) {
            Button(Constants.Strings.terms, action: viewModel.openTermsOfService)
            Text(Constants.Strings.separatorDot)
                .font(.system(
                    size: Constants.FontSize.separatorDotFontSize,
                    weight: .heavy
                ))
            Button(Constants.Strings.privacy, action: viewModel.openPrivacy)
            Text(Constants.Strings.separatorDot)
                .font(.system(
                    size: Constants.FontSize.separatorDotFontSize,
                    weight: .heavy
                ))
            Button(Constants.Strings.restorePurchases, action: viewModel.restorePurchase)
        }
        .buttonStyle(.plain)
        .font(.callout)
        .foregroundStyle(.ftGray3)
        .alert(
            Constants.Strings.errorHeader,
            isPresented: Binding(get: {
                viewModel.state.error != nil
            }, set: { showError in
                viewModel.keepShowingError(showError: showError)
            }), actions: {
                // OK dismissal button by default
            }, message: {
                Text(viewModel.state.error?.localizedDescription ?? "")
            }
        )
    }
}

#Preview {
    SubscriptionUtilityLinksView(
        viewModel: .init(
            paymentManager: MockPaymentManagerWithPurchaseError(),
            flowDelegate: nil
        )
    )
}
