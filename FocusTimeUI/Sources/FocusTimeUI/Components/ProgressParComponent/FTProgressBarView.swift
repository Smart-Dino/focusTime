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

    /// All items representing each step of the progress.
    public let items: [Item]

    /// The currently selected (active) item.
    public let selectedItem: Item

    /// Colour used for the active segment.
    private let activeColor: Color

    /// Colour used for inactive segments.
    private let inactiveColor: Color

    /// Initialises the progress bar.
    /// - Parameters:
    ///   - items: Array of hashable items representing the steps.
    ///   - selectedItem: The currently active item.
    ///   - activeColor: Color for the active segment. Default is `.blue`.
    ///   - inactiveColor: Color for inactive segments. Default is `.gray.opacity(0.3)`.
    public init(
        items: [Item],
        selectedItem: Item,
        activeColor: Color = .blue,
        inactiveColor: Color = Color.gray.opacity(0.3)
    ) {
        self.items = items
        self.selectedItem = selectedItem
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
