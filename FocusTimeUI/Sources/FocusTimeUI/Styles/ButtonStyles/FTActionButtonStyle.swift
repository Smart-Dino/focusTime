//
//  FTActionButtonStyle.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 27.08.2025.
//

import SwiftUI

/// A bold, full-width capsule button style for the FocusTime app.
///
/// - Appearance:
///   - Background: semi-transparent black fill (`opacity(0.8)`).
///   - Shape: capsule with rounded ends.
///   - Border: 2pt stroke in `ftMainBlue`.
///   - Expands to the maximum available width of its container.
///   - Pressed: reduces opacity to `0.8`.
///   - Disabled: reduces opacity to `0.3`.
///
/// - Usage:
///   Apply this style to any SwiftUI `Button` to create a prominent call-to-action:
///   ```swift
///   Button("Start Focus Session") {
///       // Action here
///   }
///   .buttonStyle(FTActionButtonStyle())
///   ```
public struct FTActionButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    
    /// Creates a new action button style.
    public init() { }

    /// Returns the styled body for the given button configuration.
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background {
                Color.black
                    .opacity(0.8)
            }
            .clipShape(.capsule)
            .overlay {
                Capsule()
                    .stroke(.ftMainBlue, lineWidth: 2)
            }
            .opacity(isEnabled ? (configuration.isPressed ? 0.8 : 1) : 0.3)
    }
}

#Preview {
    Button("Start Focusing") {
        // No action.
    }
    .buttonStyle(FTActionButtonStyle())
    .preferredColorScheme(.dark)
}
