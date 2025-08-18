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
            static let background = ImageResource.MainImages.TaskConcentrationImages.taskConcentrationFocus
            static let play = "play.fill"
            static let pause = "pause"
        }
    }
}

// MARK: - Predefined phases
extension TaskConcentrationViewModel.State.Phase {
    typealias Phase = TaskConcentrationViewModel.State.Phase
    
    static let focus = Phase.focus(
        title: "Focus Session",
        subtitle: "Concentrate on your task",
        timerTitle: "Focus time",
        runningTitle: "Pause",
        pausedTitle: "Start",
        runningIcon: "pause",
        pausedIcon: "play.fill"
    )
    
    static let breakTransition = Phase.breakTransition(
        title: "Keep it up!",
        subtitle: "Now allow yourself a little rest and don’t forget to start the timer"
    )
    
    static let breakTime = Phase.breakTime(
        title: "Break Time",
        subtitle: "Your well-deserved pause",
        timerTitle: "Rest time",
        buttonTitle: "Start A Break"
    )
    
    static let almostDone = Phase.almostDone(
        title: "You're almost there!",
        subtitle: "Don’t lose achievement 🥺",
        message: "You’ll lose your streak and session reward if you end now. Need a small break?",
        buttonTitle: "Take a break"
    )
    
    static let finished = Phase.finished(
        title: "Well done!",
        subtitle: "You’ve successfully completed your focus session. Stay consistent, and every small win will bring you closer to big results."
    )
}
