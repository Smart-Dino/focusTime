//
//  FTDismissToolbarButtonView.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 16.06.2025.
//

import SwiftUI

/// A toolbar button that dismisses the current screen when tapped.
///
/// This view renders a plain "X" button with a dark blue color style, suitable for
/// placing in navigation toolbars or overlays where a dismiss action is needed.
public struct FTDismissToolbarButtonView: View {
    /// Action to perform when the button is tapped.
    private let dismissAction: () -> Void
    
    public var body: some View {
        Button(
            "Dismiss current screen.", // This one is not String - LocalizedStringKey, so it will appear in xcstrings.
            systemImage: "xmark",
            action: dismissAction
        )
        .buttonStyle(.plain)
        .foregroundStyle(.ftDarkBlue)
    }
    
    /// Creates a new dismiss toolbar button view.
    /// - Parameter dismissAction: A closure that handles dismissing the current screen.
    public init(dismissAction: @escaping () -> Void) {
        self.dismissAction = dismissAction
    }
}
