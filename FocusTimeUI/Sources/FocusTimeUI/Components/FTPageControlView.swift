//
//  FTPageControlView.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 19.05.2025.
//

import SwiftUI

/// Native-like PageControl improved with extended features.
///
/// Usage:
/// ```swift
/// FTPageControlView(Array(0..<10), selectedItem: .constant(5))
///     .foregroundTint(Color.blue)
///     .frame(width: 150)
/// ```
public struct FTPageControlView<Items: Collection>: View {
    // Static
    private let items: Items
    // Dynamic
    @Binding private var selectedItem: Int?
    @State private var maxWidth: CGFloat = .zero
    // Modifiable
    private var foregroundTint: AnyShapeStyle = .init(Color.white)
    
    public var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 4) {
                ForEach(0..<items.count, id: \.self) { index in
                    // Use an image instead of shapes to dynamically adjust
                    // based on the Dynamic Type
                    Image(systemName: "circlebadge.fill")
                        // Dynamic Type-supported font
                        .font(.caption2)
                        .foregroundStyle(
                            selectedItem == index
                            ? foregroundTint.opacity(1)
                            : foregroundTint.opacity(0.3)
                        )
                }
            }
            // On each addition of a dot - set the new width to fit it
            .onGeometryChange(for: CGRect.self) { proxy in
                proxy.frame(in: .global)
            } action: { newValue in
                maxWidth = newValue.width
            }
        }
        // Dynamically adjust frame based on its contents
        // Adjustment stops once the view reaches parent's width
        .frame(maxWidth: maxWidth)
        .scrollIndicators(.hidden)
        // Do not allow scrolling if all the dots fit in the container
        .scrollBounceBehavior(.basedOnSize, axes: [.horizontal])
        .padding(5)
        .background {
            // Capsule shape behind the dots
            Capsule()
                .fill(Color.gray)
                .opacity(0.6)
        }
    }
    
    /// Initialize this view.
    /// - Parameters:
    ///   - items: Use any collection to inject it into the view.
    ///   - selectedItem: A binding parameter reflecting which item is currently selected.
    public init(
        _ items: Items,
        selectedItem: Binding<Int?>
    ) {
        self.items = items
        self._selectedItem = selectedItem
    }
    
}

public extension FTPageControlView {
    func foregroundTint<S: ShapeStyle>(_ style: S) -> Self {
        var copy = self
        copy.foregroundTint = AnyShapeStyle(style)
        return copy
    }
}

#Preview {
    FTPageControlView(Array(0..<10), selectedItem: .constant(5))
        .foregroundTint(Color.blue)
        .frame(width: 150)
        .preferredColorScheme(.dark)
}
