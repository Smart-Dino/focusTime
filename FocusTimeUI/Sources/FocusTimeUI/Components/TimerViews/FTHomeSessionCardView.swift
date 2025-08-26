//
//  FTHomeSessionCardView.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 19.06.2025.
//

import SwiftUI

public struct FTHomeSessionCardView: View {
    private let title: String
    private let description: String
    
    public var body: some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading) {
                Text(title)
                Text(description)
                    .foregroundStyle(.ftGray3Light)
            }
            Spacer()
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
        description: String,
    ) {
        self.title = title
        self.description = description
    }
    
}

#Preview("Scheduled", traits: .sizeThatFitsLayout) {
    FTHomeSessionCardView(
        title: "Work time",
        description: "00:00:01"
    )
    .preferredColorScheme(.dark)
}
