//
//  FTSessionCardView.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 07.08.2025.
//

import SwiftUI

public struct FTSessionCardView: View {
    public enum CardMode {
        case draft(timeRange: String)
        case scheduled(timeRange: String)
        case active(viewModel: FocusSessionTimerModel)
    }
    private let emoji: String
    private let title: String
    @State private var mode: CardMode
    
    public var body: some View {
        switch mode {
        case .draft(timeRange: let timeRange):
            FTSessionActiveRowView(
                emoji: emoji,
                title: title,
                description: timeRange
            )
        case .scheduled(let timeRange):
            FTSessionScheduledRowView(
                emoji: emoji,
                title: title,
                description: timeRange
            )
        case .active(let viewModel):
            FTSessionActiveRowView(
                emoji: emoji,
                title: title,
                description: viewModel.state.formattedTime
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
        mode: .scheduled(timeRange: "8:00 - 15:00")
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
