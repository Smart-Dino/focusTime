//
//  FTProUpgradeButtonView.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 16.06.2025.
//

import SwiftUI

public struct FTProUpgradeButtonView: View {
    private static let gradient: AnyGradient = Color.blue.gradient
    private let buttonAction: () -> Void
    
    public var body: some View {
        Button {
            buttonAction()
        } label: {
            label
        }
        .buttonStyle(.plain)
    }
    
    private var label: some View {
        HStack(spacing: 2) {
            Image(systemName: "bolt.fill")
                .font(.callout)
            Text("pro")
        }
        .padding(1)
        .padding(.horizontal, 5)
        .foregroundStyle(Self.gradient)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Self.gradient, lineWidth: 1)
        }
    }
    
    public init(action: @escaping () -> Void) {
        self.buttonAction = action
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    FTProUpgradeButtonView(action: {})
        .preferredColorScheme(.dark)
}
