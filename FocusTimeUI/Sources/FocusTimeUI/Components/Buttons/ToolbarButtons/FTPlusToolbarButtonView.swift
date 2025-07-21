//
//  FTPlusToolbarButtonView.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 12.06.2025.
//

import SwiftUI

/// A button, that represents an addition, meant to be used in the toolbar.
///
/// This view renders a plain "+" button with a dark blue color style, suitable for
/// placing in navigation toolbars or overlays where an addition action is needed.
public struct FTPlusToolbarButtonView: View {
    /// Action to perform when the button is tapped.
    private let buttonAction: () -> Void
    
    public var body: some View {
        Button(
            "Add a block",
            systemImage: "plus.circle",
            action: {
                buttonAction()
            }
        )
    }
    
    /// Creates a new dismiss toolbar button view.
    /// - Parameter dismissAction: A closure that handles dismissing the current screen.
    public init(action: @escaping () -> Void) {
        self.buttonAction = action
    }
}
