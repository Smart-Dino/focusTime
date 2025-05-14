//
//  FTCheckboxToggleStyle.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 14.05.2025.
//

import SwiftUI

/// A toggle style that displays a checkbox in place of the system switch,
/// with optional text label and configurable color and spacing.
///
/// Usage examples:
/// ```swift
/// // Basic checkbox with green tint and default spacing
/// Toggle("Enable notifications?", isOn: $isOn)
///     .toggleStyle(
///         FTCheckboxToggleStyle(color: .green)
///             .labelsHidden()
///     )
///
/// // Checkbox with green tint, custom spacing, and bold label
/// Toggle("Enable notifications?", isOn: $isOn)
///     .toggleStyle(
///         FTCheckboxToggleStyle(color: .green, spacing: 30)
///     )
///     .bold()
/// ```
///
/// Managing multiple items in a list of options:
/// ```swift
/// struct ExampleOption: Identifiable {
///     let id = UUID()
///     var title: String
///     var isSelected: Bool
/// }
///
/// @Previewable @State private var options = [
///     ExampleOption(title: "Hello", isSelected: false),
///     ExampleOption(title: "This", isSelected: false),
///     ExampleOption(title: "Is", isSelected: false),
///     ExampleOption(title: "A", isSelected: false),
///     ExampleOption(title: "Test", isSelected: false)
/// ]
///
/// VStack(alignment: .leading) {
///     ForEach($options) { $option in
///         Toggle(option.title, isOn: $option.isSelected)
///             .toggleStyle(FTCheckboxToggleStyle())
///     }
/// }
/// ```
public struct FTCheckboxToggleStyle: ToggleStyle {
    /// Whether the toggle’s label is visible.
    private var showsLabel: Bool

    /// Color used for checkbox border and fill.
    private let color: Color

    /// Horizontal spacing between the checkbox and label.
    private let spacing: CGFloat

    /// Underlying shape of the checkbox.
    private let rectangle = RoundedRectangle(cornerRadius: 2)

    /// View for the unchecked state (border only).
    private var offState: some View {
        rectangle
            .stroke(lineWidth: 1.4)
            .foregroundStyle(color)
    }

    /// View for the checked state (filled with checkmark overlay).
    private var onState: some View {
        rectangle
            .foregroundStyle(color)
            .overlay {
                Image(systemName: "checkmark")
                    .font(.system(size: 12))
            }
    }

    /// Initializes a checkbox style.
    ///
    /// - Parameters:
    ///   - color: Tint for the checkbox border and fill (default: `.blue`).
    ///   - spacing: Gap between the checkbox and its label (default: `8`).
    public init(
        color: Color = .blue,
        spacing: CGFloat = 8
    ) {
        self.showsLabel = true
        self.color = color
        self.spacing = spacing
    }

    /// Builds the toggle body combining the checkbox button and optional label.
    public func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: spacing) {
            Button {
                configuration.isOn.toggle()
            } label: {
                Group {
                    if configuration.isOn {
                        onState
                    } else {
                        offState
                    }
                }
            }
            .frame(width: 20, height: 20)
            .buttonStyle(.plain)

            if showsLabel {
                configuration.label
            }
        }
    }
}

public extension FTCheckboxToggleStyle {
    /// Returns a copy of this style with the label hidden.
    func labelsHidden() -> Self {
        var copy = self
        copy.showsLabel = false
        return copy
    }
}
