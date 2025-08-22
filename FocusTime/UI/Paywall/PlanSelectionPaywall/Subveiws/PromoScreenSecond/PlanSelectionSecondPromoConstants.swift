//
//  PlanSelectionSecondPromoConstants.swift
//  FocusTime
//
//  Created by Maksym Horobets on 06.08.2025.
//

import SwiftUI

extension PlanSelectionSecondPromoView {
    enum Constants {
        enum Strings {
            static let headline = String(localized: "plan_selection_second_promo_headline", table: "PaywallLocalizable")
            static let subtitle: String = {
                let appName = SharedAppValues.appName ?? String()
                let format = String(localized: "plan_selection_second_promo_subtitle", table: "PaywallLocalizable")
                return String(format: format, appName)
            }()
        }
        enum Images {
            static let background = ImageResource.SharedImages.wave
            static let icons = ImageResource.PaywallImages.promoScreenSecondIcons
        }
        enum Colors {
            static let background = Color.ftBackground
            static let accent = Color.ftPaywallPromoGreen
        }
        enum Fonts {
            static let headline = Font.title.bold()
        }
    }
}
