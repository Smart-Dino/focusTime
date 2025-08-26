//
//  FTEmojiPicker.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 26.08.2025.
//

import SwiftUI

public struct FTEmojiPicker: View {
    @Binding var selectedEmoji: String
    private let emojis: [String]
    
    private let backgroundShape = RoundedRectangle(cornerRadius: 25)
    
    public var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .font(.title)
                        .padding(.leading, 10)
                        .onTapGesture {
                            selectedEmoji = emoji
                        }
                }
            }
        }
        .padding(.vertical, 6)
        .clipShape(backgroundShape)
        .scrollIndicators(.hidden)
        .background {
            backgroundShape
                .foregroundStyle(.ftGray5Dark)
        }
    }
    
    public init(
        selectedEmoji: Binding<String>,
        emojis: [String]
    ) {
        self._selectedEmoji = selectedEmoji
        self.emojis = emojis
    }
}

#Preview("Full emojis", traits: .sizeThatFitsLayout) {
    @Previewable @State var selectedEmoji: String = "None"
    let emojis = ["☕️", "⏳", "📖", "🌿", "💪", "💻", "🚀", "⚡️"]
    
    VStack {
        Text(selectedEmoji)
        FTEmojiPicker(selectedEmoji: $selectedEmoji, emojis: emojis)
            .preferredColorScheme(.dark)
    }
}

#Preview("Partial emojis", traits: .sizeThatFitsLayout) {
    @Previewable @State var selectedEmoji: String = "None"
    let emojis = ["☕️", "⏳", "📖"]
    
    VStack {
        Text(selectedEmoji)
        FTEmojiPicker(selectedEmoji: $selectedEmoji, emojis: emojis)
            .preferredColorScheme(.dark)
    }
}
