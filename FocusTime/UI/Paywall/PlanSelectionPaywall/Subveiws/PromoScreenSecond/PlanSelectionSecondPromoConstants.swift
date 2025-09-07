//
//  PlanSelectionSecondPromoConstants.swift
//  FocusTime
//
//  Created by Maksym Horobets on 06.08.2025.
//

import SwiftUI
import Lottie

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
            static let icons = ImageResource.PaywallImages.promoScreenSecondIcons
        }
        enum Colors {
            static let background = Color.ftBackground
            static let accent = Color.ftPaywallPromoGreen
        }
        enum Fonts {
            static let headline = Font.title.bold()
        }
        
        enum Layout {
            static let animationScale: CGPoint = .init(x: 1.6, y: 0.9)
            static let animationOpacity: CGFloat = 0.3
        }
        
        enum Animations {
            static let waveAnimation: LottieAnimation? = .filepath(
                Bundle.main.url(forResource: "Wave Animation", withExtension: "json")?.relativePath ?? String()
            )
        }
    }
}
