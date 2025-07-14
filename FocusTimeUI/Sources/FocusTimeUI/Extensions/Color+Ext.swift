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
    static var ftGradientTopColor: Color { Color( "GradientTopColor", bundle: .module) }
    static var ftGradientBottomColor: Color { Color( "GradientBottomColor", bundle: .module) }
    static var ftPresetBackgroundColor: Color { Color( "PresetBackgroundColor", bundle: .module) }
    static var ftPresetSelectedBackgroundColor: Color { Color( "PresetSelectedBackgroundColor", bundle: .module) }
    static var ftTimePickerBackgroundColor: Color { Color( "TimePickerBackgroundColor", bundle: .module) }
    
}

