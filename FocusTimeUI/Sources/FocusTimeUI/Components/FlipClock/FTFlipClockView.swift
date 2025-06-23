//
//  SwiftUIView.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 23.06.2025.
//

import SwiftUI

struct FTFlipClockView: View {
    let configuration: FTFlipClockConfiguration
    
    @Binding private var seconds: Int
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    
    var body: some View {
        HStack {
            FTFlipClockComponentView(value: $hours, configuration: configuration)
            FTFlipClockComponentView(value: $minutes, configuration: configuration)
        }
        .onChange(of: seconds, formatTime)
        .onAppear(perform: formatTime)
    }
    
    init(
        configuration: FTFlipClockConfiguration,
        timeLeft: Binding<Int>
    ) {
        self.configuration = configuration
        self._seconds = timeLeft
    }
    
    func formatTime() {
        hours = seconds / 3600
        minutes = (seconds % 3600) / 60
    }
    
}

#Preview {
    // The timer is sped up for demonstration purposes.
    @Previewable let timer = Timer.publish(every: 0.01, on: .current, in: .default).autoconnect()
    @Previewable @State var timeLeft = 62_700 // 17:25
    FTFlipClockView(configuration: .init(), timeLeft: $timeLeft)
        .preferredColorScheme(.dark)
        .onReceive(timer) { _ in
            timeLeft -= 5
        }
}
