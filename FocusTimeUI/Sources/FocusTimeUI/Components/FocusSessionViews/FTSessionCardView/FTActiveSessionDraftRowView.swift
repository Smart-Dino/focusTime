//
//  FTActiveSessionDraftRowView.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 25.08.2025.
//

import SwiftUI

public struct FTActiveSessionDraftRowView: View {
    private let emoji: String
    private let title: String
    @State private var timer: FTTimer
    
    public var body: some View {
        HStack(spacing: 15) {
            Text(emoji)
                .font(.title2)
            VStack(alignment: .leading) {
                Text(title)
                Text(timer.payload.formatted)
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
        .accessibilityLabel("\(emoji), \(title), \(timer.payload.formatted)")
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
        timer: FTTimer
    ) {
        self.emoji = emoji
        self.title = title
        self.timer = timer
    }
    
}
