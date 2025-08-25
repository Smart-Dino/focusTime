//
//  FTBackgroundGradientViewModifier.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 25.08.2025.
//

import SwiftUI

public struct FTBackgroundGradientViewModifier: ViewModifier {
    /// Applies a gradient background behind the provided content, ensuring the background covers the entire safe area.
    /// - Parameter content: The view content to display above the gradient background.
    /// - Returns: A view with the gradient background layered beneath the content.
    public func body(content: Content) -> some View {
        content
            .background {
                FTBackgroundGradientView()
            }
    }
}

public extension View {
    /// Applies a gradient background with blurred elliptical circles behind the view.
    /// - Returns: A view with the gradient background applied.
    func gradientBackground() -> some View {
        self.modifier(FTBackgroundGradientViewModifier())
    }
}
