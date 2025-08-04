//
//  SwiftUIView.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 23.06.2025.
//

import SwiftUI

public struct FTFlipClockView: View {
    let configuration: FTFlipClockConfiguration
    
    private let viewModel: FocusSessionTimerModel // Indeed does work with no @State.
    
    public var body: some View {
        HStack {
            FTFlipClockComponentView(
                value: Binding {
                    viewModel.state.hours
                } set: { hours in
                    viewModel.setHours(hours)
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
    let viewModel = FocusSessionTimerModel(
        state: .init(isPaused: false),
        deadline: .now.addingTimeInterval(70)
    )
    
    FTFlipClockView(
        configuration: .init(),
        viewModel: viewModel
    )
    .preferredColorScheme(.dark)
}
