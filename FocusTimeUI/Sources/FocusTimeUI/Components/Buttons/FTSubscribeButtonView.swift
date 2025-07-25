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
                .foregroundStyle(.ftGray3Light)
                .multilineTextAlignment(.center)
            Button(buttonTitle, action: buttonAction)
                .buttonStyle(.ftPrimary)
        }
    }
    
    /// Creates a subscribe button view.
    /// - Parameters:
    ///   - terms: Text displayed above the button (e.g., trial information).
    ///   - buttonTitle: The title of the action button.
    ///   - action: The action to perform when the button is tapped.
    public init(
        terms: String,
        buttonTitle: String,
        action: @escaping () -> Void
    ) {
        self.terms = terms
        self.buttonTitle = buttonTitle
        self.buttonAction = action
    }
}

