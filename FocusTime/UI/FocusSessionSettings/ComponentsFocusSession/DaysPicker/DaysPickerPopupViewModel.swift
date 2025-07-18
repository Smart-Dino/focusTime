//
//  DaysPickerPopupViewModel.swift
//  FocusTime
//
//  Created by Keto Nioradze on 11.07.25.
//

import SwiftUI

@Observable
@MainActor
final class DaysPickerPopupViewModel {
    struct State: Equatable { 
        var scheduledDays: Set<Weekday>
    }

    private(set) var state: State
    
    init(scheduledDays: Set<Weekday>) {
        self.state = State(scheduledDays: scheduledDays)
    }
    
    func toggleDay(_ day: Weekday) {
        if state.scheduledDays.contains(day) {
            state.scheduledDays.remove(day)
        } else {
            state.scheduledDays.insert(day)
        }
    }
}
