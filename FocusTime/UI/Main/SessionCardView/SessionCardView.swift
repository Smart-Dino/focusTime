//
//  FTSessionCardView.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 07.08.2025.
//

import SwiftUI
import FocusTimeUI

public struct SessionCardView: View {
    @State var viewModel: SessionCardViewModel
    
    public var body: some View {
        switch viewModel.isActive() {
        case false:
            FTSessionScheduledRowView(
                emoji: viewModel.blockItem.emoji,
                title: viewModel.blockItem.name,
                description: viewModel.timeRange
            )
        case true:
            FTSessionActiveRowView(
                emoji: viewModel.blockItem.emoji,
                title: viewModel.blockItem.name,
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
