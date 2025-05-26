//
//  FTProgressBarView.swift
//  FocusTimeUI
//
//  Created by Keto Nioradze on 16.05.25.
//

import SwiftUI

// MARK: - FTProgressBarView

/// A customisable progress bar view that displays a sequence of segments.
/// Highlights the current active segment and shows others as inactive.
public struct FTProgressBarView<Item: Hashable>: View {

    public let items: [Item]

    @Binding public var selectedItem: Item

    private let activeColor: Color

    private let inactiveColor: Color


    public init(
        items: [Item],
        selectedItem: Binding<Item>,
        activeColor: Color = .blue,
        inactiveColor: Color = Color.gray.opacity(0.3)
    ) {
        self.items = items
        self._selectedItem = selectedItem
        self.activeColor = activeColor
        self.inactiveColor = inactiveColor
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: 8) {
            ForEach(items, id: \.self) { item in
                Rectangle()
                    .fill(item == selectedItem ? activeColor : inactiveColor)
                    .frame(height: 4)
                    .cornerRadius(3)
            }
        }
    }
}
