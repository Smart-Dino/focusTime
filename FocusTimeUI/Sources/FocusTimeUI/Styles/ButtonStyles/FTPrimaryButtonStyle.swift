//
//  FPPrimaryButtonStyle.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 14.05.2025.
//

import SwiftUI

/// A bold, full-width capsule button used in the FocusTime app.
///
/// - Appearance:
///   - Background: solid blue fill.
///   - Shape: capsule-clip for rounded ends.
///   - Expands to the maximum available width of its container.
///
/// - Usage:
///   Apply this style to any SwiftUI `Button` where you need a prominent call-to-action. For example:
///   ```swift
///   Button("Start Focus Session") { ... }
///       .buttonStyle(FTPrimaryButtonStyle())
///   ```
public struct FTPrimaryButtonStyle: ButtonStyle {
    
    /// Initializes the primary button style.
    public init() { }

    /// Builds the button's body.
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical, 7)
            .background(Color.blue)
            .clipShape(Capsule())
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}
