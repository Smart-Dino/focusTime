//
//  FTSubscriptionUtilityLinksView.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 16.05.2025.
//

import SwiftUI

/// A view displaying standard subscription utility links: "Terms", "Privacy", and "Restore Purchase".
///
/// This view arranges the links horizontally, separated by bold dots.
/// Tapping on each link triggers a corresponding closure provided during initialization.
/// The overall font for the links is `.callout`.
public struct SubscriptionUtilityLinksView: View {
    // MARK: - UI Constants
    private let separatorDotFontSize: CGFloat = 20
    private let horizontalSpacing: CGFloat = 20
    
    // MARK: - Closure properties
    public var onTermsTapped: () -> Void
    public var onPrivacyTapped: () -> Void
    public var onRestoreTapped: () -> Void

    /// Public initializer to accept the action closures.
    /// - Parameters:
    ///   - onTermsTapped: Closure, called on **Terms** press.
    ///   - onPrivacyTapped: Closure, called on **Privacy** press.
    ///   - onRestoreTapped: Closure, called on **Pestore Purchase** press.
    public init(
        onTermsTapped: @escaping () -> Void,
        onPrivacyTapped: @escaping () -> Void,
        onRestoreTapped: @escaping () -> Void
    ) {
        self.onTermsTapped = onTermsTapped
        self.onPrivacyTapped = onPrivacyTapped
        self.onRestoreTapped = onRestoreTapped
    }

    public var body: some View {
        HStack(spacing: horizontalSpacing) {
            Button("Terms") {
                onTermsTapped() // Call the provided closure
            }
            Text("•")
                .font(.system(
                    size: separatorDotFontSize,
                    weight: .heavy
                ))
            Button("Privacy") {
                onPrivacyTapped() // Call the provided closure
            }
            Text("•")
                .font(.system(
                    size: separatorDotFontSize,
                    weight: .heavy
                ))
            Button("Restore Purchase") {
                onRestoreTapped() // Call the provided closure
            }
        }
        .buttonStyle(PlainButtonStyle())
        .font(.callout)
    }
}
