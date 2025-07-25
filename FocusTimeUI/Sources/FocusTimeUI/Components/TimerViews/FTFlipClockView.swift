//
//  SwiftUIView.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 23.06.2025.
//

import SwiftUI

public struct FTFlipClockView: View {
    let configuration: FTFlipClockConfiguration
    
    @State private var viewModel: FocusSessionTimerModel
    
    public var body: some View {
        HStack {
            FTFlipClockComponentView(
                value: Binding {
                    viewModel.state.hours
                } set: { hour in
                    viewModel.setHours(hour)
                },
                configuration: configuration
            )
            FTFlipClockComponentView(
                value: Binding {
                    viewModel.state.minutes
                } set: { minutes in
                    viewModel.setMinutes(minutes)
                },
                configuration: configuration
            )
        }
    }
    
    public init(
        configuration: FTFlipClockConfiguration,
        viewModel: FocusSessionTimerModel
    ) {
        self.configuration = configuration
        self.viewModel = viewModel
    }
}

#Preview {
    FTFlipClockView(
        configuration: .init(),
        viewModel: FocusSessionTimerModel(
            state: .init(isPaused: .constant(false)),
            deadline: Date.now.addingTimeInterval(70)
        )
    )
}
