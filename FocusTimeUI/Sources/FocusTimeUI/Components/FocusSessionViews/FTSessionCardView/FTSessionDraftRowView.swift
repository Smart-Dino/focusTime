//
//  FTSessionSummaryCardView.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 18.06.2025.
//

import SwiftUI

public struct FTSessionDraftRowView: View {
    private let emoji: String
    private let title: String
    private let description: String
    
    public var body: some View {
        HStack(spacing: 15) {
            Text(emoji)
                .font(.title2)
            VStack(alignment: .leading) {
                Text(title)
                Text(description)
                    .foregroundStyle(.ftGray3Light)
            }
            Spacer()
        }
        .padding()
        .background {
            let shape = FocusSessionBackgroundShape()
            ZStack {
                shape
                    .fill(.sessionRowBlue)
                shape
                    .stroke(gradient, lineWidth: 1.2)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(emoji), \(title), \(description)")
    }
    
    var gradient: LinearGradient {
        LinearGradient(
            colors: [.leadingSummaryCard, .trailingSummaryCard],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    public init(
        emoji: String,
        title: String,
        description: String
    ) {
        self.emoji = emoji
        self.title = title
        self.description = description
    }
    
}

#Preview(traits: .sizeThatFitsLayout) {
    FTSessionDraftRowView(
        emoji: "😎",
        title: "Cool",
        description: "Draft"
    )
    .padding()
    .preferredColorScheme(.dark)
}
