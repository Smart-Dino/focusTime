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
    private let isActive: Bool
    
    var isPaused: Bool
    
    let action: (() -> Void)?
    let pauseAction: (() -> Void)?
    
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
        .overlay {
            if isActive {
                HStack {
                    Spacer()
                    Button {
                        pauseAction?()
                    } label: {
                        isPaused
                        ? Image(systemName: "play.circle").foregroundStyle(.blue)
                        : Image(systemName: "pause.circle").foregroundStyle(.red)
                    }
                    .font(.title2)
                    .padding(.horizontal)
                }
            }
        }
        .contentShape(.rect)
        .onTapGesture(perform: action ?? {})
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
        isActive: Bool,
        isPaused: Bool,
        action: (() -> Void)?,
        pauseAction: (() -> Void)?
    ) {
        self.title = title
        self.description = description
        self.isActive = isActive
        self.isPaused = isPaused
        self.action = action
        self.pauseAction = pauseAction
    }
    
}

#Preview("Scheduled", traits: .sizeThatFitsLayout) {
    FTHomeSessionCardView(
        title: "Work time",
        description: "00:00:01",
        isActive: true,
        isPaused: true,
        action: nil,
        pauseAction: nil
    )
    .preferredColorScheme(.dark)
}
