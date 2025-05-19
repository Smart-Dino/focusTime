//
//  FTPageControlView.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 19.05.2025.
//

import SwiftUI

public struct FTPageControlView<Items: Collection>: View {
    private let items: Items
    @State private var maxWidth: CGFloat = .zero
    public var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 4) {
                ForEach(0..<items.count, id: \.self) { num in
                    Image(systemName: "circlebadge.fill")
                        .font(.caption2)
                        .foregroundStyle(Color.white)
                }
            }
            .onGeometryChange(for: CGRect.self) { proxy in
                proxy.frame(in: .global)
            } action: { newValue in
                print("Frame is now \(newValue)")
                maxWidth = newValue.width
            }
        }
        .frame(maxWidth: maxWidth)
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize, axes: [.horizontal])
        .padding(5)
        .background {
            Capsule()
                .fill(Color.gray)
                .opacity(0.6)
        }
    }
    
    public init(_ items: Items) {
        self.items = items
    }
}

#Preview {
    FTPageControlView(Array(0..<10))
        .preferredColorScheme(.dark)
//        .frame(width: 150)
}
