//
//  FTSessionSummaryCardView.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 18.06.2025.
//

import SwiftUI

public struct FTSessionActiveRowView: View {
    private let emoji: String
    private let title: String
    @State private var description: String
    
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
    
    public var gradient: LinearGradient {
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
    @Previewable @State var viewModel: FocusSessionTimerModel = .init(
        state: .init(isPaused: false),
        deadline: .now.addingTimeInterval(160),
        delegate: nil
    )
    FTSessionActiveRowView(
        emoji: "😎",
        title: "Cool",
        description: viewModel.state.formattedTime
    )
    .padding()
    .preferredColorScheme(.dark)
}
