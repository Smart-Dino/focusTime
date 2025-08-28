//
//  RowStyle.swift
//  FocusTime
//
//  Created by Keto Nioradze on 18.06.25.
//

import SwiftUI

public struct RowStyle: ViewModifier {
    let rowHeight: CGFloat
    let cornerRadius: CGFloat

    /// Applies a standardized row style to the given content.
    /// The style includes padding, a fixed height, background color,
    /// rounded corners, and a white tint.
    /// - Parameter content: The view to style.
    /// - Returns: The styled view with row appearance applied.
    public func body(content: Content) -> some View {
        content
            .padding()
            .frame(height: rowHeight)
            .background(Color.ftPresetBackgroundColor)
            .cornerRadius(cornerRadius)
            .tint(.white)
    }
    
    public init(rowHeight: CGFloat, cornerRadius: CGFloat) {
        self.rowHeight = rowHeight
        self.cornerRadius = cornerRadius
    }
}

public extension View {
    /// Applies a consistent row style to the view, including padding,
    /// fixed height, background color, rounded corners, and white tint.
    /// - Parameters:
    ///   - height: The fixed row height. Defaults to `64`.
    ///   - cornerRadius: The corner radius for rounded corners. Defaults to `12`.
    /// - Returns: The styled view with row appearance applied.
    func rowStyle(height: CGFloat = 64, cornerRadius: CGFloat = 20) -> some View {
        self.modifier(RowStyle(rowHeight: height, cornerRadius: cornerRadius))
    }
}

