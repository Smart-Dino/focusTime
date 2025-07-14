//
//  DurationPickerSheetViewModel.swift
//  FocusTime
//
//  Created by Keto Nioradze on 11.07.25.
//

import SwiftUI

@Observable
@MainActor
final class DurationPickerSheetViewModel {
    struct State: Equatable {
        var hours: Int
        var minutes: Int
    }
    
    var state: State
    
    var hours: Int {
        get { state.hours }
        set { state.hours = newValue }
    }
    
    var minutes: Int {
        get { state.minutes }
        set { state.minutes = newValue }
    }
    
    init(hours: Int, minutes: Int) {
        self.state = State(hours: hours, minutes: minutes)
    }
}
