//
//  FTListItemView.swift
//  FocusTime
//
//  Created by Maksym Horobets on 15.05.2025.
//

import SwiftUI

/// A list item with an icon and a text.
///
/// Used for feature lists, like in an onboarding paywall.
/// The icon is top-aligned with the text.
public struct FTListItemView: View {
    private let text: String
    private let systemImage: String
    
    public var body: some View {
        HStack(alignment: .top) {
            // Icon
            Image(systemName: systemImage)
                .foregroundStyle(.ftMainBlue)
                .padding(.trailing)
            // Text
            Text(text)
        }
    }
    
    /// Creates the checkmark list item.
     /// - Parameter text: The text to show next to the icon.
     /// - Parameter systemImage: The **SFSymbol** to display alongside  the text.
    public init(
        _ text: String,
        systemImage: String
    ) {
        self.text = text
        self.systemImage = systemImage
    }
}
