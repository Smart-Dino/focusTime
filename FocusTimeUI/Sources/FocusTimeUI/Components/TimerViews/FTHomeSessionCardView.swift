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
    
    @Binding var isPaused: Bool
    
    let action: (() -> Void)?
    
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
        .contentShape(.rect)
        .onTapGesture(perform: action ?? {})
        .overlay {
            if isActive {
                HStack {
                    Spacer()
                    Button {
                        isPaused.toggle()
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
        isPaused: Binding<Bool>,
        action: (() -> Void)?
    ) {
        self.title = title
        self.description = description
        self.isActive = isActive
        self._isPaused = isPaused
        self.action = action
    }
    
}

#Preview("Scheduled", traits: .sizeThatFitsLayout) {
    FTHomeSessionCardView(
        title: "Work time",
        description: "00:00:01",
        isActive: true,
        isPaused: .constant(true),
        action: nil
    )
    .preferredColorScheme(.dark)
}
