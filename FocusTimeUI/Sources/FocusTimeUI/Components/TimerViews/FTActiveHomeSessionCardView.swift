//
//  FTActiveHomeSessionCardView.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 19.06.2025.
//

import SwiftUI

public struct FTActiveHomeSessionCardView: View {
    private let title: String
    private let isPaused: Bool
    
    private let timerPayload: FTTimerPayload
    
    let action: (() -> Void)?
    let pauseAction: (() -> Void)?
    
    public var body: some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading) {
                Text(title)
                Text(timerPayload.formatted)
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
        timerPayload: FTTimerPayload,
        isPaused: Bool,
        action: (() -> Void)?,
        pauseAction: (() -> Void)?
    ) {
        self.title = title
        self.timerPayload = timerPayload
        self.isPaused = isPaused
        self.action = action
        self.pauseAction = pauseAction
    }
    
}
