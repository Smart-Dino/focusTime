//
//  Color+Ext.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 26.05.2025.
//

import SwiftUI

public extension Color {
    static let ftBackground = Color("CustomBackground", bundle: .module)
    static let ftPageControlBlue = Color("PageControlBlue", bundle: .module)
}


public extension Color {
    init(hex: String, alpha: Double = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexSanitized.hasPrefix("#") {
            hexSanitized.removeFirst()
        }

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r, g, b: Double
        if hexSanitized.count == 6 {
            r = Double((rgb & 0xFF0000) >> 16) / 255.0
            g = Double((rgb & 0x00FF00) >> 8) / 255.0
            b = Double(rgb & 0x0000FF) / 255.0
        } else {
            r = 0.5
            g = 0.5
            b = 0.5
        }

        self.init(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }

    static let ftDeepBackground = Color(hex: "#000C10")
    static let ftGradientTop = Color(hex: "#0E4D76")
    static let ftGradientBottom = Color(hex: "#9D71FE")
    static let ftPresetBackground = Color(hex: "#2C2C2E")
    static let ftPresetSelectedBackground = Color(hex: "#273D6F")
    static let ftRowBackground = Color(hex: "#2C2C2E")
    static let ftDaysPickerBackground = Color(red: 0.2, green: 0.2, blue: 0.22)
}
