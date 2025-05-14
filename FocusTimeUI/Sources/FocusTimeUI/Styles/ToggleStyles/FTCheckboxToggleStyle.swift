//
//  FTCheckboxToggleStyle.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 14.05.2025.
//

import SwiftUI

/// A custom toggle style rendering a checkbox with optional label.
/// ```swift
/// Toggle("Enable notifications?", isOn: $isOn)
///     .toggleStyle(
///         FTCheckboxToggleStyle(color: .green)
///             .labelsHidden()
///     )
///
/// Toggle("Enable notifications?", isOn: $isOn)
///     .toggleStyle(
///         FTCheckboxToggleStyle(color: .green, spacing: 30)
///     )
///     .bold()
/// ```
public struct FTCheckboxToggleStyle: ToggleStyle {
    /// Controls visibility of the toggle’s label.
    private var showsLabel: Bool
    /// Tint color for the checkbox stroke and fill.
    private let color: Color
    /// Spacing between checkbox and label.
    private let spacing: CGFloat
    
    /// Base shape for the checkbox.
    private let rectangle = RoundedRectangle(cornerRadius: 2)
    
    /// Unchecked checkbox view.
    private var offState: some View {
        rectangle
            .stroke(lineWidth: 1.4)
            .foregroundStyle(color)
    }
    
    /// Checked checkbox view with checkmark.
    private var onState: some View {
        rectangle
            .foregroundStyle(color)
            .overlay {
                Image(systemName: "checkmark")
                    .font(.system(size: 12))
            }
    }
    
    /// Create a new checkbox style with given color and spacing.
    /// - Parameters:
    ///   - color: Tint color for the checkbox (default: blue).
    ///   - spacing: Gap between checkbox and label (default: 8).
    public init(
        color: Color = .blue,
        spacing: CGFloat = 8
    ) {
        self.showsLabel = true
        self.color = color
        self.spacing = spacing
    }
    
    /// Build the toggle body combining checkbox and label.
    public func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: spacing) {
            Button {
                configuration.isOn.toggle()
            } label: {
                switch configuration.isOn {
                case true: onState
                case false: offState
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
    /// Hide the label when rendering the checkbox.
    func labelsHidden() -> Self {
        var copy = self
        copy.showsLabel = false
        return copy
    }
}
