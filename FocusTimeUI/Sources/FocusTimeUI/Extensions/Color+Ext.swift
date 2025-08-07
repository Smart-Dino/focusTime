//
//  Color+Ext.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 26.05.2025.
//

import SwiftUI

// MARK: - Public colors
// https://www.hackingwithswift.com/forums/100-days-of-swiftui/extending-shapestyle-for-adding-colors-instead-of-extending-color/12324
// Important: Static stored properties not supported in protocol extensions
public extension ShapeStyle where Self == Color {
    // MARK: - Backgrounds
    static var ftBackground: Color { Color("BackgroundColor", bundle: .module) }
    static var ftBackgroundBlue: Color { Color("BackgroundBlueColor", bundle: .module) }
    // MARK: - Blue
    static var ftDarkBlue: Color { Color("DarkBlueColor", bundle: .module) }
    static var ftMainBlue: Color { Color("MainBlueColor", bundle: .module) }
    static var onboardingPaywallContentPad: Color { Color("OnboardingPaywallContentPadColor", bundle: .module) }
    // MARK: - Green
    static var ftPaywallPromoGreen: Color { Color("PaywallPromoGreenColor", bundle: .module) }
    // MARK: - UIKit Adapted
    // https://stackoverflow.com/questions/65493461/get-dark-style-of-uicolor
    static var ftGray3Light: Color {
        Color(
            uiColor: UIColor.systemGray3.resolvedColor(with: .init(userInterfaceStyle: .light))
        )
    }
    static var ftGray5Dark: Color {
        Color(
            uiColor: UIColor.systemGray5.resolvedColor(with: .init(userInterfaceStyle: .dark))
        )
    }
}

// MARK: Private colors
internal extension ShapeStyle where Self == Color {
    // MARK: AppBlocking Colors
    static var leadingSummaryCard: Color {
        Color("LeadingSummaryCardColor", bundle: .module)
    }
    static var trailingSummaryCard: Color {
        Color("TrailingSummaryCardColor", bundle: .module)
    }
    // MARK: ScheduledFocus Colors
    static var leadingScheduledFocus: Color {
        Color("LeadingScheduledFocusColor", bundle: .module)
    }
    static var trailingScheduledFocus: Color {
        Color("TrailingScheduledFocusColor", bundle: .module)
    }
    static var sessionRowBlue: Color {
        Color("SessionRowBlueColor", bundle: .module)
    }
}

