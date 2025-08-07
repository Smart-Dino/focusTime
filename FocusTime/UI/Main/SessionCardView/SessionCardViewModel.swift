//
//  SessionCardViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 07.08.2025.
//

import Foundation
import FocusTimeUI

@MainActor
@Observable
final class SessionCardViewModel {
    enum CardMode {
        case inactive(emoji: String, name: String, timeRange: String)
        case active(emoji: String, name: String, timerViewModel: FocusSessionTimerModel)
    }
    
    struct State {
        var mode: CardMode
    }
    
    private(set) var state: State
    let blockItem: ProtectedBlockItem
    let timeRange: String
    
    init(blockItem: ProtectedBlockItem) {
        self.state = state
        self.blockItem = blockItem
        self.timeRange = blockItem.type.description
    }
    
    func setCardMode() {
        let type = blockItem.type

        if let timeLeft = type.secondsToIntervalEndIfShouldBeRunning {
            let isPaused: Bool = {
                if case .duration(_, _, let suspendedAt, _) = type {
                    return suspendedAt != nil
                }
                return false
            }()

            let deadline = Date.now.addingTimeInterval(TimeInterval(timeLeft))
            let viewModel = FocusSessionTimerModel(
                state: .init(isPaused: isPaused),
                deadline: deadline,
                delegate: nil
            )

            state.mode = .active(
                emoji: blockItem.emoji,
                name: blockItem.name,
                timerViewModel: .init(state: .init(isPaused: isPaused),
                                      deadline: deadline,
                                      delegate: self)
            )
        } else {
            switch type {
            case .duration(let duration, _, _, _):
                return .awaiting(timeRange: "Duration: \(duration.description)")
            case .scheduled(let startTime, let endTime):
                return .awaiting(timeRange: "\(startTime.description)-\(endTime.description)")
            }
        }
    }
}

extension SessionCardViewModel: FocusSessionTimerModelDelegate {
    func didUpdateIsPaused(_: Bool) {
        <#code#>
    }
    
    
}
