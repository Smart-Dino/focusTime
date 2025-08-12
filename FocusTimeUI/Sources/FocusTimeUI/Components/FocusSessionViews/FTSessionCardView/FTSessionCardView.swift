//
//  FTSessionCardView.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 07.08.2025.
//

import SwiftUI

public struct FTSessionCardView: View {
    public enum CardMode {
        case draft(description: String)
        case scheduled(description: String)
    }
    private let emoji: String
    private let title: String
    private var mode: CardMode
    
    public var body: some View {
        switch mode {
        case .draft(let description):
            FTSessionDraftRowView(
                emoji: emoji,
                title: title,
                description: description
            )
        case .scheduled(let description):
            FTSessionScheduledRowView(
                emoji: emoji,
                title: title,
                description: description
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
        mode: .scheduled(description: "8:00 - 15:00")
    )
    .padding()
    .preferredColorScheme(.dark)
}
