//
//  FTFlipClockConfiguration.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 23.06.2025.
//

import SwiftUI

public struct FTFlipClockConfiguration {
    public let size: CGSize
    public let fontSize: CGFloat
    public let cornerRadius: CGFloat
    public let foreground: Color
    public let background: Color
    public let animationDuration: CGFloat
    
    public init(
        size: CGSize = .init(width: 90, height: 80),
        fontSize: CGFloat = 64,
        cornerRadius: CGFloat = 15,
        foreground: Color = .white,
        background: Color = .ftGray5Dark,
        animationDuration: CGFloat = 0.8
    ) {
        self.size = size
        self.fontSize = fontSize
        self.cornerRadius = cornerRadius
        self.foreground = foreground
        self.background = background
        self.animationDuration = animationDuration
    }
}
