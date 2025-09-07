//
//  ScheduledFocusConstants.swift
//  FocusTime
//
//  Created by Maksym Horobets on 19.06.2025.
//

import SwiftUI
import Lottie

extension ScheduledBlockItemsView {
    enum Constants {
        // MARK: - Strings
        enum Strings {
            static let navTitle = String(localized: "scheduled_focus_list_nav_title", table: "MainLocalizable")
            static let noSchedulesTitle = String(localized: "scheduled_focus_list_no_schedules_title", table: "MainLocalizable")
            static let noSchedulesMessage = String(localized: "scheduled_focus_list_no_schedules_message", table: "MainLocalizable")
            static let newSessionButtonTitle = String(localized: "scheduled_focus_list_new_session_button_title", table: "MainLocalizable")
        }
        // MARK: - Icons
        enum Icons {
            static let waveImage = ImageResource.MainImages.scheduledFocusWave
            static let newSessionSymbol = "plus.circle"
        }
        
        enum Layout {
            static let animationScale: CGPoint = .init(x: 1.3, y: 0.9)
            static let animationOpacity: CGFloat = 0.3
        }
        
        enum Animations {
            static let waveAnimation: LottieAnimation? = .filepath(
                Bundle.main.url(forResource: "Wave Animation", withExtension: "json")?.relativePath ?? String()
            )
        }
    }
}
