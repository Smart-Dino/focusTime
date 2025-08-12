//
//  SwiftUIView.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 12.08.2025.
//

import SwiftUI

public struct FTActiveSessionCardView: View {
    private let emoji: String
    private let title: String
    private let timerModel: FocusSessionTimerModel // Do not add state here.
    
    public var body: some View {
        FTSessionDraftRowView(
            emoji: emoji,
            title: title,
            description: timerModel.state.formattedTime
        )
    }
    
    public init(
        emoji: String,
        title: String,
        timerModel: FocusSessionTimerModel
    ) {
        self.emoji = emoji
        self.title = title
        self.timerModel = timerModel
    }
}
