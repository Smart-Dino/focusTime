//
//  TaskConcentrationConstants.swift
//  FocusTime
//
//  Created by Maksym Horobets on 04.08.2025.
//

import SwiftUI

extension TaskConcentrationView {
    enum Constants {
        enum Strings {
            static let subtitle = String(localized: "task_concentration_subtitle", table: "MainLocalizable")
            static let timerTitle = String(localized: "task_concentration_timer_title", table: "MainLocalizable")
            static let resumeButtonTitle = String(localized: "task_concentration_resume_button", table: "MainLocalizable")
            static let pauseButtonTitle = String(localized: "task_concentration_pause_button", table: "MainLocalizable")
            static let endSessionButtonTitle = String(localized: "task_concentration_end_session_button", table: "MainLocalizable")
            static let navigationTitle = String(localized: "task_concentration_navigation_title", table: "MainLocalizable")
        }
        enum Icons {
            static let background = ImageResource.MainImages.taskConcentrationBackground
            static let play = "play.fill"
            static let pause = "pause"
        }
    }
}
