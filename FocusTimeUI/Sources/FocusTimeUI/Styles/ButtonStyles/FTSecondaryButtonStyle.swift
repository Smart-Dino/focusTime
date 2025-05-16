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
/// - Usage:
///   Apply this style to any SwiftUI `Button` where you need a secondary call-to-action. For example:
///   ```swift
///   Button("Restore Purchases") { ... }
///       .buttonStyle(FTSecondaryButtonStyle())
///   ```
public struct FTSecondaryButtonStyle: ButtonStyle {
    
    /// Initializes the primary button style.
    public init() { }
    
    /// Builds the button's body.
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical, 7)
            .background(Material.ultraThinMaterial)
            .clipShape(Capsule())
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
    
}
