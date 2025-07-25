//
//  FTHomeSessionCardView.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 19.06.2025.
//

import SwiftUI

public struct FTHomeSessionCardView: View {
    public enum CardMode {
        case scheduled(timeRange: String)
        case countdown(timeLeft: Int, isPaused: Binding<Bool>)
    }
    
    private let title: String
    private let mode: CardMode
    
    public var body: some View {
        HStack(spacing: 15) {
            switch mode {
            case .scheduled(let timeRange):
                VStack(alignment: .leading) {
                    Text(title)
                    Text(timeRange)
                        .foregroundStyle(.ftGray3Light)
                }
                Spacer()
            case .countdown(let timeLeft, let isPaused):
                VStack(alignment: .leading) {
                    Text(title)
                    Text(formatTime(seconds: timeLeft))
                        .foregroundStyle(.ftGray3Light)
                }
                Spacer()
                Button {
                    isPaused.wrappedValue.toggle()
                } label: {
                    isPaused.wrappedValue
                    ? Image(systemName: "play.circle").foregroundStyle(.blue)
                    : Image(systemName: "pause.circle").foregroundStyle(.red)
                }
                .font(.title2)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background {
            let shape = FocusSessionBackgroundShape()
            ZStack {
                shape
                    .fill(.backgroundScheduledFocus)
                shape
                    .stroke(gradient, lineWidth: 1.2)
            }
        }
    }
    
    var gradient: LinearGradient {
        LinearGradient(
            colors: [.leadingScheduledFocus, .trailingScheduledFocus],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    public init(
        title: String,
        mode: CardMode
    ) {
        self.title = title
        self.mode = mode
    }
    
    func formatTime(seconds: Int) -> String {
        let hrs = seconds / 3600
        let mins = (seconds % 3600) / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d:%02d", hrs, mins, secs)
    }

    
}

#Preview(traits: .sizeThatFitsLayout) {
    @Previewable let timer = Timer.publish(every: 1, on: .current, in: .default).autoconnect()
    
    @Previewable @State var isPaused = false
    @Previewable @State var timeLeft = 100
    Text("Is paused: " + isPaused.description)
    FTHomeSessionCardView(
        title: "Work time",
        mode: .countdown(timeLeft: timeLeft, isPaused: $isPaused)
    )
    .padding()
    .preferredColorScheme(.dark)
    .onReceive(timer) { _ in
        timeLeft -= 1
    }
}
