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
    private let isSubscribed: Bool
    private let buttonAction: () -> Void
    
    public var body: some View {
        VStack {
            Text(terms)
                .font(.caption)
            Button {
                buttonAction()
            } label: {
                if isSubscribed {
                    Image(systemName: "checkmark")
                        .font(.title3) // Makes it similar in vertical size to the title
                } else {
                    Text(buttonTitle)
                }
            }
            .buttonStyle(.ftPrimary)
        }
    }
    
    /// Creates a subscribe button view.
    /// - Parameters:
    ///   - terms: Text displayed above the button (e.g., trial information).
    ///   - buttonTitle: The title of the action button.
    ///   - isSubscribed: A flag indicating whether the user is currently subscribed. Used to adjust the button style or visibility.
    ///   - buttonAction: The action to perform when the button is tapped.
    public init(
        terms: String,
        buttonTitle: String,
        isSubscribed: Bool,
        buttonAction: @escaping () -> Void
    ) {
        self.terms = terms
        self.buttonTitle = buttonTitle
        self.isSubscribed = isSubscribed
        self.buttonAction = buttonAction
    }
}

