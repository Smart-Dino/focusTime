//
//  HomeViewConstants.swift
//  FocusTime
//
//  Created by Maksym Horobets on 16.06.2025.
//

import SwiftUI
import DeviceActivity

extension HomeView {
    enum Constants {
        // MARK: - ActivityConfiguration
        @MainActor
        enum ActivityConfiguration {
            static let context = DeviceActivityReport.Context.totalActivity
            static let filter = DeviceActivityFilter(
                segment: .daily(during: DateInterval(
                    start: Calendar.current.startOfDay(for: .now),
                    duration: 86400)),
                users: .all,
                devices: .init([.iPhone])
            )
        }
        // MARK: - Strings
        enum Strings {
            static let navigationTitle = String(localized: "home_view_navigation_title", table: "MainLocalizable")
            static let timerSubtitle = String(localized: "home_view_timer_subtitle", table: "MainLocalizable")
            static let scheduledFocusTitle = String(localized: "home_view_scheduled_focus_title", table: "MainLocalizable")
            static let scheduledFocusSubtitle = String(localized: "home_view_scheduled_focus_subtitle", table: "MainLocalizable")
            static let bottomButtonTitle = String(localized: "home_view_bottom_button_title", table: "MainLocalizable")
        }

        // MARK: - Icons
        enum Icons {
            static let waveImage = ImageResource.SharedImages.wave
            static let chevronRight = "chevron.right"
            static let hourglass = "hourglass"
        }

        // MARK: - Typography
        enum Fonts {
            static let navigationTitle = SharedConstants.Fonts.navigationTitle
        }

        // MARK: - Layout
        enum Layout {
            static let activityReportSceneHeight: CGFloat = 50
        }
    }
}
