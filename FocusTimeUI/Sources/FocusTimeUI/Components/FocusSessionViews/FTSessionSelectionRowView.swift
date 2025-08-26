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
    private let onTapAction: () -> Void
    
    public var body: some View {
        HStack(spacing: 20) {
            Toggle(isOn: $isToggled) {
                Text("Toggle schedule")
            }
            .toggleStyle(.ftCheckbox.labelsHidden())
            Button {
                onTapAction()
            } label: {
                HStack(spacing: 15) {
                    Text(emoji)
                        .font(.title2)
                    VStack(alignment: .leading) {
                        Text(title)
                        Text(description)
                            .foregroundStyle(.ftGray3Light)
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
            .buttonStyle(.plain)
        }
    }
    
    public init(
        emoji: String,
        title: String,
        description: String,
        isToggled: Binding<Bool>,
        onTapAction: @escaping () -> Void
    ) {
        self.emoji = emoji
        self.title = title
        self.description = description
        self._isToggled = isToggled
        self.onTapAction = onTapAction
    }

}

#Preview(traits: .sizeThatFitsLayout) {
    @Previewable @State var isToggled = false
    FTSessionSelectionRowView(
        emoji: "😎",
        title: "Cool",
        description: "This is a cool view huh?",
        isToggled: $isToggled,
        onTapAction: {}
    )
    .padding()
    .preferredColorScheme(.dark)
}
