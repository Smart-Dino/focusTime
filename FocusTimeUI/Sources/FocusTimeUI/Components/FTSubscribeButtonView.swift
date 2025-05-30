//
//  FTSubscribeButtonView.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 16.05.2025.
//

import SwiftUI

/// A view displaying subscription terms and a configurable action button.
public struct FTSubscribeButtonView: View {
    private let terms: String
    private let buttonTitle: String
    private let buttonAction: () -> Void

    public var body: some View {
        VStack {
            Text(terms)
                .font(.caption)
            Button(buttonTitle, action: buttonAction)
                .buttonStyle(.ftPrimary)
        }
    }

    /// Creates a subscribe button view.
    /// - Parameters:
    ///   - terms: Text displayed above the button (e.g., trial information).
    ///   - buttonTitle: The title of the action button.
    ///   - buttonAction: The action to perform when the button is tapped.
    public init(
        terms: String,
        buttonTitle: String,
        buttonAction: @escaping () -> Void
    ) {
        self.terms = terms
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
    }
}

