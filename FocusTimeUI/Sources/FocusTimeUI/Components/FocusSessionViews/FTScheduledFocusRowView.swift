//
//  FTScheduledFocusRowView.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 18.06.2025.
//

import SwiftUI

public struct FTScheduledFocusRowView: View {
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
                    .foregroundStyle(.ftGray3)
            }
            Spacer()
            Image(systemName: "hourglass.bottomhalf.filled")
                .font(.title3)
                .foregroundStyle(.blue)
        }
        .padding()
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
    FTScheduledFocusRowView(
        emoji: "😎",
        title: "Cool",
        description: "This is a cool view huh?"
    )
    .padding()
    .preferredColorScheme(.dark)
}
