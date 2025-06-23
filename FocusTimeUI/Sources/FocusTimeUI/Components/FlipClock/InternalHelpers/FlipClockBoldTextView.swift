//
//  FTFlipClockBoldTextView.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 23.06.2025.
//

import SwiftUI

internal struct FlipClockBoldTextView: View {
    private let displayValue: Int
    private let fontSize: CGFloat
    private let foreground: Color
    
    internal var body: some View {
        Text(String(displayValue))
            .font(.system(size: fontSize)).bold()
            .foregroundStyle(foreground)
            .lineLimit(1)
    }
    
    internal init(
        _ displayValue: Int,
        fontSize: CGFloat,
        foreground: Color
    ) {
        self.displayValue = displayValue
        self.fontSize = fontSize
        self.foreground = foreground
    }
}
