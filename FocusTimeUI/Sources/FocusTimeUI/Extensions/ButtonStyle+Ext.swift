//
//  ButtonStyle+Ext.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 21.05.2025.
//

import SwiftUI

public extension ButtonStyle where Self == FTPrimaryButtonStyle {
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
    ///       .buttonStyle(.ftPrimary)
    ///   ```
    static var ftPrimary: Self { Self() }
}

public extension ButtonStyle where Self == FTSecondaryButtonStyle {
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
    ///       .buttonStyle(.ftSecondary)
    ///   ```
    static var ftSecondary: Self { Self() }
}

public extension ButtonStyle where Self == FTActionButtonStyle {
    /// A bold, full-width capsule button style used in the FocusTime app.
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
    ///   Apply this style to any SwiftUI `Button` where you need a primary call-to-action. For example:
    ///   ```swift
    ///   Button("Start Focus Session") { ... }
    ///       .buttonStyle(.ftAction)
    ///   ```
    static var ftAction: Self { Self() }
}

