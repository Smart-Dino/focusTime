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
    private var dataUpdatingTask: Task<Void, Never>?
    
    init(blockItem: ProtectedBlockItem) {
        self.state = State(mode: .inactive(emoji: blockItem.emoji,
                                           name: blockItem.name,
                                           timeRange: blockItem.type.description))
        self.blockItem = blockItem
        setupDataUpdatingTask()
        print(ObjectIdentifier(self))
    }
    
    isolated deinit {
        self.dataUpdatingTask?.cancel()
        self.dataUpdatingTask = nil
    }
    
    #warning("Task runs in two different ViewModels but neither update the view")
    func setupDataUpdatingTask() {
        print("\(#function) called")
        dataUpdatingTask = Task.detached(priority: .background) { [weak self] in
            while true {
                try? await Task.sleep(for: .seconds(20))
                guard case .inactive = await self?.state.mode else { break }
                print("Task ran")
                print(ObjectIdentifier(self!))
                await self?.setCardMode()
            }
        }
    }
    
    func setCardMode() {
        let type = blockItem.type

        if let timeLeft = type.secondsToIntervalEndIfShouldBeRunning, timeLeft > 0 {
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
                delegate: self
            )

            state.mode = .active(
                emoji: blockItem.emoji,
                name: blockItem.name,
                timerViewModel: viewModel
            )
        } else {
            state.mode = .inactive(
                emoji: blockItem.emoji,
                name: blockItem.name,
                timeRange: blockItem.type.description
            )
        }
    }
}

extension SessionCardViewModel: FocusSessionTimerModelDelegate {
    func didUpdateIsPaused(_: Bool) {
        setCardMode()
    }
    func didFinishCountdown() {
            setCardMode()

    }
}
