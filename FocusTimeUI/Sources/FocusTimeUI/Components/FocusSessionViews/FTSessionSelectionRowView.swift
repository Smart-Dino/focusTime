//
//  FTSessionSelectionRowView.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 18.06.2025.
//

import SwiftUI

public struct FTSessionSelectionRowView: View {
    private let emoji: String
    private let title: String
    private let description: String
    @Binding private var isToggled: Bool
    
    public var body: some View {
        HStack(spacing: 20) {
            Toggle(isOn: $isToggled) {
                Text("Toggle schedule")
            }
            .toggleStyle(.ftCheckbox.labelsHidden())
            HStack(spacing: 15) {
                Text(emoji)
                    .font(.title2)
                VStack(alignment: .leading) {
                    Text(title)
                    Text(description)
                        .foregroundStyle(.ftGray3)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.blue)
            }
            .padding()
            .background {
                FocusSessionBackgroundShape()
                    .stroke(.primary.opacity(0.15), lineWidth: 1.2)
            }
        }
    }
    
    public init(
        emoji: String,
        title: String,
        description: String,
        isToggled: Binding<Bool>
    ) {
        self.emoji = emoji
        self.title = title
        self.description = description
        self._isToggled = isToggled
    }
    
}

#Preview(traits: .sizeThatFitsLayout) {
    @Previewable @State var isToggled = false
    FTSessionSelectionRowView(
        emoji: "😎",
        title: "Cool",
        description: "This is a cool view huh.",
        isToggled: $isToggled
    )
    .padding()
    .preferredColorScheme(.dark)
}
