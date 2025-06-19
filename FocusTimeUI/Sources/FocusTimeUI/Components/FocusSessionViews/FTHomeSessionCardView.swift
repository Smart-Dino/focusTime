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
    
    static let formatter = DateComponentsFormatter()
    
    private let title: String
    private let mode: CardMode
    
    public var body: some View {
        HStack(spacing: 15) {
            switch mode {
            case .scheduled(let timeRange):
                VStack(alignment: .leading) {
                    Text(title)
                    Text(timeRange)
                        .foregroundStyle(.ftGray3)
                }
                Spacer()
            case .countdown(let timeLeft, let isPaused):
                VStack(alignment: .leading) {
                    Text(title)
                    Text(formatTime(seconds: timeLeft))
                        .foregroundStyle(.ftGray3)
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
            ZStack {
                let shape = FocusSessionBackgroundShape()
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
        let formatter = Self.formatter
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: TimeInterval(seconds)) ?? "00:00:00"
    }
    
}

#Preview {
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
