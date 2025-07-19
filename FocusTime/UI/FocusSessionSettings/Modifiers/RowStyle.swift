//
//  RowStyle.swift
//  FocusTime
//
//  Created by Keto Nioradze on 18.06.25.
//

import SwiftUI

struct RowStyle: ViewModifier {
    /// Applies a standardized row style to the given content, including padding, fixed height, background color, corner radius, and white tint.
    /// - Parameter content: The view to style.
    /// - Returns: The styled view with row appearance applied.
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(height: FocusSessionView.Constants.Row.height)
            .background(Color.ftPresetBackgroundColor)
            .cornerRadius(FocusSessionView.Constants.Row.cornerRadius)
            .tint(.white)
    }
}

extension View {
    /// Applies a consistent row style to the view, including padding, fixed height, background color, rounded corners, and white tint.
    func rowStyle() -> some View {
        self.modifier(RowStyle())
    }
}
