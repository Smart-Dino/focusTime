//
//  Color+Ext.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 16.05.2025.
//

import SwiftUI

// MARK: - Colors from Hex
public extension Color {
    // In order to add colors here you would need to:
    // 1. Take the value from figma -> #1D1B20
    // 2. Make all the letters lowercase and remove # -> 1d1b20
    // 3. Add 0x at the start to turn it into a number -> 0x1db20
    static let ftBackground: Color = .init(hex: 0x1d1b20)
}

// MARK: - Hex extension
internal extension Color {
    /// Creates a color from a 6-digit hexadecimal integer (e.g., `0xFF6A00` for orange).
    ///
    /// - Parameters:
    ///   - hex: The `0xRRGGBB` hexadecimal color value.
    ///   - opacity: The color's opacity (0.0 to 1.0). Defaults to `1.0`.
    init(hex: Int, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }
}
