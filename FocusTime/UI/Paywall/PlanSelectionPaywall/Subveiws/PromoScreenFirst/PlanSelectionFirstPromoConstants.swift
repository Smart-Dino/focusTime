//
//  PlanSelectionFirstPromoConstants.swift
//  FocusTime
//
//  Created by Maksym Horobets on 06.08.2025.
//

import SwiftUI

extension PlanSelectionFirstPromoView {
    enum Constants {
        enum Strings {
            static let headline = String(localized: "plan_selection_first_promo_headline", table: "PaywallLocalizable")
            static let subtitle = String(localized: "plan_selection_first_promo_subtitle", table: "PaywallLocalizable")
        }
        enum Images {
            static let background = ImageResource.PaywallImages.promoScreenFirstBackground
        }
        enum Colors {
            static let headline = Color.ftGray3Light
        }
        enum Fonts {
            static let subtitle = Font.title.bold()
        }
    }
}
