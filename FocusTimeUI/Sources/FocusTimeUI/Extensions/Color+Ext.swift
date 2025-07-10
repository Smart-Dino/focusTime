//
//  Color+Ext.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 26.05.2025.
//

import SwiftUI

// https://www.hackingwithswift.com/forums/100-days-of-swiftui/extending-shapestyle-for-adding-colors-instead-of-extending-color/12324
// Important: Static stored properties not supported in protocol extensions
public extension ShapeStyle where Self == Color {
    // MARK: - Backgrounds
    static var ftBackground: Color { Color("BackgroundColor", bundle: .module) }
    static var ftBackgroundBlueColor: Color { Color("BackgroundBlueColor", bundle: .module) }
    // MARK: - Blue
    static var ftDarkBlue: Color { Color("DarkBlueColor", bundle: .module) }
    static var ftMainBlue: Color { Color("MainBlueColor", bundle: .module) }
    static var onboardingPaywallContentPad: Color { Color("OnboardingPaywallContentPadColor", bundle: .module) }
    // MARK: - UIKit Adapted
    // https://stackoverflow.com/questions/65493461/get-dark-style-of-uicolor
    static var ftGray3: Color {
        Color(
            uiColor: UIColor.systemGray3.resolvedColor(with: .init(userInterfaceStyle: .light))
        )
    }
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
