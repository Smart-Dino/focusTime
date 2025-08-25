//
//  TaskConcentrationConstants.swift
//  FocusTime
//
//  Created by Maksym Horobets on 04.08.2025.
//

import Lottie
import SwiftUI

extension TaskConcentrationView {
    enum Constants {
        enum Strings {
            static let endSessionButtonTitle = String(localized: "task_concentration_end_session_button", table: "MainLocalizable")
        }
        
        enum Animations {
            // Animations.
            static let warningAnimation: LottieAnimation? = .filepath(
                Bundle.main.url(forResource: "Warning Yellow", withExtension: "json")?.relativePath ?? String()
            )
            static let confettiAnimation: LottieAnimation? = .filepath(
                Bundle.main.url(forResource: "Confetti", withExtension: "json")?.relativePath ?? String()
            )
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
        runningIcon: "pause"
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

extension TaskConcentrationViewModel.State.Phase: Equatable {
    static func == (lhs: TaskConcentrationViewModel.State.Phase, rhs: TaskConcentrationViewModel.State.Phase) -> Bool {
        switch (lhs, rhs) {
        case (.focus, .focus):
            true
        case (.breakTransition, .breakTransition):
            true
        case (.breakTime, .breakTime):
            true
        case (.almostDone, .almostDone):
            true
        case (.finished, .finished):
            true
        default:
            false
        }
    }
}

