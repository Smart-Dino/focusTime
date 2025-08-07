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
    
    @State private var viewModel: FocusSessionTimerModel // // Does not work without @State.
    
    public var body: some View {
        HStack(spacing: 15) {
            Text(emoji)
                .font(.title2)
            VStack(alignment: .leading) {
                Text(title)
                Text(viewModel.state.formattedTime)
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
        .accessibilityLabel("\(emoji), \(title), \(viewModel.state.formattedTime)")
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
        viewModel: FocusSessionTimerModel
    ) {
        self.emoji = emoji
        self.title = title
        self.viewModel = viewModel
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
        viewModel: viewModel
    )
    .padding()
    .preferredColorScheme(.dark)
}
