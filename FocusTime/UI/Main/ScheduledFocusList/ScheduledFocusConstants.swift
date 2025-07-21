//
//  ScheduledFocusConstants.swift
//  FocusTime
//
//  Created by Maksym Horobets on 19.06.2025.
//

import SwiftUI

extension ScheduledFocusListView {
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
    }
}
