//
//  FPSecondaryButtonStyle.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 14.05.2025.
//

import SwiftUI

/// A semi-transparent, full-width capsule button used in the FocusTime app.
///
/// - Appearance:
///   - Background: system's UltraThinMaterial material.
///   - Shape: capsule-clip for rounded ends.
///   - Expands to the maximum available width of its container.
///
/// - Important: Use `.init(paddingDisabled: true)` to use your custom padding instead.
///
/// - Usage:
///   Apply this style to any SwiftUI `Button` where you need a secondary call-to-action. For example:
///   ```swift
///   Button("Restore Purchases") { ... }
///       .buttonStyle(FTSecondaryButtonStyle())
///   ```
public struct FTSecondaryButtonStyle: ButtonStyle {
    private let paddingDisabled: Bool
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical, 7)
            .background(Material.ultraThinMaterial)
            .clipShape(Capsule())
            .padding(.horizontal, paddingDisabled ? 0 : fTUniversalPadding)
    }
    
    /// Initializes the primary button style.
    ///
    /// - Parameter paddingDisabled: If `true`, disables the package-provided horizontal padding.
    public init(paddingDisabled: Bool = false) {
        self.paddingDisabled = paddingDisabled
    }
}
