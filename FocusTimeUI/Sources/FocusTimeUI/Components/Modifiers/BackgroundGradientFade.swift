//
//  BackgroundGradientFade.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 27.08.2025.
//

import SwiftUI

/// A view modifier that applies a vertical black-to-clear gradient background
/// fading from the bottom upwards. The gradient extends into the safe area
/// at the bottom of the screen.
public struct BackgroundGradientFade: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .background {
                LinearGradient(
                    colors: [.black, .clear],
                    startPoint: .bottom,
                    endPoint: .top
                )
                .ignoresSafeArea(edges: .bottom)
            }
    }
}

public extension View {
    /// Applies a vertical black-to-clear gradient fade background
    /// that starts at the bottom of the screen and fades upward.
    ///
    /// - Returns: A view with the gradient fade applied.
    func backgroundGradientFade() -> some View {
        self.modifier(BackgroundGradientFade())
    }
}
