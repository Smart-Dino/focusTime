//
//  FTSessionCardView.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 07.08.2025.
//

import SwiftUI

public struct FTSessionCardView: View {
    public enum CardMode {
        case awaiting(timeRange: String)
        case active(viewModel: FocusSessionTimerModel)
    }
    private let emoji: String
    private let title: String
    private let mode: CardMode
    
    public var body: some View {
        switch mode {
        case .awaiting(let timeRange):
            FTSessionScheduledRowView(
                emoji: emoji,
                title: title,
                description: timeRange
            )
        case .active(let viewModel):
            FTSessionActiveRowView(
                emoji: emoji,
                title: title,
                viewModel: viewModel
            )
        }
    }
    
    public init(
        emoji: String,
        title: String,
        mode: CardMode
    ) {
        self.emoji = emoji
        self.title = title
        self.mode = mode
    }
}

#Preview("Scheduled", traits: .sizeThatFitsLayout) {
    FTSessionCardView(
        emoji: "🧪",
        title: "Test",
        mode: .awaiting(timeRange: "8:00 - 15:00")
    )
    .padding()
    .preferredColorScheme(.dark)
}

#Preview("Active", traits: .sizeThatFitsLayout) {
    @Previewable @State var viewModel = FocusSessionTimerModel(
        state: .init(isPaused: false),
        deadline: .now.addingTimeInterval(160),
        delegate: nil
    )
    FTSessionCardView(
        emoji: "🧪",
        title: "Test",
        mode: .active(viewModel: viewModel)
    )
    .padding()
    .preferredColorScheme(.dark)
}
