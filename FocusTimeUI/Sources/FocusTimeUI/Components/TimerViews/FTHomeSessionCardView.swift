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
        case countdown(timer: FTTimer)
    }
    
    private let title: String
    @State private var mode: CardMode // Does not work without @State.
    
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
            case .countdown(let timer):
                VStack(alignment: .leading) {
                    Text(title)
                    Text(timer.payload.formatted)
                        .foregroundStyle(.ftGray3Light)
                }
                Spacer()
                Button {
                    timer.isPaused ? timer.resume() : timer.pause()
                } label: {
                    timer.isPaused
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
                    .fill(.sessionRowBlue)
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


//#Preview("Countdown", traits: .sizeThatFitsLayout) {
//    VStack {
//        FTHomeSessionCardView(
//            title: "Work time",
//            mode: .countdown(
//                viewModel: ...
//            ),
//        )
//        .preferredColorScheme(.dark)
//        Button("Toggle pause") {
//            viewModel.togglePause()
//        }
//    }
//}
