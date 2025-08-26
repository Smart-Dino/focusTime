//
//  SwiftUIView.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 23.06.2025.
//

import SwiftUI

public struct FTFlipClockView: View {
    let configuration: FTFlipClockConfiguration
    
    private let timerPayload: FTTimerPayload // Indeed does work with no @State.
    
    public var body: some View {
        HStack {
            FTFlipClockComponentView(
                value: Binding {
                    timerPayload.hours
                } set: { hours in
                    timerPayload.setHours(hours)
                },
                configuration: configuration
            )
            FTFlipClockComponentView(
                value: Binding {
                    timerPayload.minutes
                } set: { minutes in
                    timerPayload.setMinutes(minutes)
                },
                configuration: configuration
            )
            FTFlipClockComponentView(
                value: Binding {
                    timerPayload.seconds
                } set: { seconds in
                    timerPayload.setSeconds(seconds)
                },
                configuration: configuration
            )
        }
    }
    
    public init(
        configuration: FTFlipClockConfiguration,
        timerPayload: FTTimerPayload
    ) {
        self.configuration = configuration
        self.timerPayload = timerPayload
    }
}

#Preview {
    FTFlipClockView(
        configuration: .init(),
        timerPayload: .init(hours: 1, minutes: 30, seconds: 0)
    )
    .preferredColorScheme(.dark)
}
