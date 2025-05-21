//
//  File.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 21.05.2025.
//

import SwiftUI

public extension ToggleStyle where Self == FTCheckboxToggleStyle {
    /// A toggle style that displays a checkbox in place of the system switch,
    /// with optional text label and configurable color and spacing.
    ///
    /// Usage examples:
    /// ```swift
    /// Toggle("Enable notifications?", isOn: $isOn)
    ///     .toggleStyle(
    ///         .ftCheckbox.labelsHidden()
    ///     )
    /// ```
    /// - Note: The `.labelsHidden` modifier is applied to the style, not the view.
    static var ftCheckbox: Self {
        Self()
    }

    /// A configurable checkbox toggle style that replaces the default switch.
    ///
    /// Use this variant to customize the color and spacing of the checkbox.
    ///
    /// Usage example:
    /// ```swift
    /// Toggle("Enable notifications?", isOn: $isOn)
    ///     .toggleStyle(
    ///         .ftCheckbox(color: .green, spacing: 30)
    ///     )
    ///     .bold()
    /// ```
    /// - Parameters:
    ///   - color: The color of the checkbox and checkmark. Default is `.blue`.
    ///   - spacing: The space between the checkbox and the label. Default is `8`.
    /// - Returns: A `FTCheckboxToggleStyle` configured with the given parameters.
    static func ftCheckbox(
        color: Color = .blue,
        spacing: CGFloat = 8
    ) -> Self {
        Self(color: color, spacing: spacing)
    }
}
