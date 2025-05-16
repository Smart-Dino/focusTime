//
//  FTCheckmarkListItemView.swift
//  FocusTime
//
//  Created by Maksym Horobets on 15.05.2025.
//

import SwiftUI

/// A list item with a green checkmark icon and text.
///
/// Used for feature lists, like in an onboarding paywall.
/// The checkmark is top-aligned with the text.
public struct FTCheckmarkListItemView: View {
    private let text: String
    
    public var body: some View {
        HStack(alignment: .top) {
            // Icon
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(Color.green)
            // Text
            Text(text)
        }
        .font(.title3)
        .minimumScaleFactor(0.9) // Scale the font down to fit small screens
    }
    
    /// Creates the checkmark list item.
     /// - Parameter text: The text to show next to the icon.
    public init(_ text: String) {
        self.text = text
    }
}
