//
//  SwiftUIView.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 23.06.2025.
//

import SwiftUI

public struct FTFlipClockView: View {
    let configuration: FTFlipClockConfiguration
    
    private let timer: FTTimer // Indeed does work with no @State.
    
    public var body: some View {
        HStack {
            FTFlipClockComponentView(
                value: Binding {
                    timer.payload.hours
                } set: { hours in
                    timer.setHours(hours)
                },
                configuration: configuration
            )
            FTFlipClockComponentView(
                value: Binding {
                    timer.payload.minutes
                } set: { minutes in
                    timer.setMinutes(minutes)
                },
                configuration: configuration
            )
            FTFlipClockComponentView(
                value: Binding {
                    timer.payload.seconds
                } set: { seconds in
                    timer.setSeconds(seconds)
                },
                configuration: configuration
            )
        }
    }
    
    public init(
        configuration: FTFlipClockConfiguration,
        timer: FTTimer
    ) {
        self.configuration = configuration
        self.timer = timer
    }
}

//#Preview {
//    FTFlipClockView(
//        configuration: .init(),
//        viewModel: ...
//    )
//    .preferredColorScheme(.dark)
//}
