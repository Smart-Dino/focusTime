//
//  FTSessionCardView.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 07.08.2025.
//

import SwiftUI
import FocusTimeUI

struct SessionCardView: View {
    @State var viewModel: SessionCardViewModel
    
    public var body: some View {
        Group {
            switch viewModel.state.mode {
            case .inactive(let emoji, let name, let timeRange):
                FTSessionScheduledRowView(
                    emoji: emoji,
                    title: name,
                    description: timeRange
                )
            case .active(let emoji, let name, let timerViewModel):
                FTSessionActiveRowView(
                    emoji: emoji,
                    title: name,
                    viewModel: timerViewModel
                )
            }
        }
        .onAppear {
            viewModel.setCardMode()
        }
    }
}
