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
        case countdown(viewModel: FocusSessionTimerModel)
    }
    
    private let title: String
    @State private var mode: CardMode
    
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
            case .countdown(let viewModel):
                VStack(alignment: .leading) {
                    Text(title)
                    Text(viewModel.state.formattedTime)
                        .foregroundStyle(.ftGray3Light)
                }
                Spacer()
                Button {
                    viewModel.setIsPaused(
                        !viewModel.state.isPaused.wrappedValue
                    )
                } label: {
                    viewModel.state.isPaused.wrappedValue
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
        mode: CardMode,
    ) {
        self.title = title
        self.mode = mode
    }
    
}

#Preview("Scheduled", traits: .sizeThatFitsLayout) {
    FTHomeSessionCardView(
        title: "Work time",
        mode: .scheduled(timeRange: "8:00 - 16:00"),
    )
    .preferredColorScheme(.dark)
}


#Preview("Countdown", traits: .sizeThatFitsLayout) {
    @Previewable @State var isPaused = false
    FTHomeSessionCardView(
        title: "Work time",
        mode: .countdown(
            viewModel: FocusSessionTimerModel(
                state: .init(isPaused: $isPaused),
                deadline: .now.addingTimeInterval(70)
            )
        ),
    )
    .preferredColorScheme(.dark)
}
