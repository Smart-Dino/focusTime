//
//  FTProductOptionView.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 19.05.2025.
//

import SwiftUI

/// View, used for displaying subscription options.
///
/// The view maintains a consistent height regardless of whether the `leadingSubtitle` is present.
/// If `leadingSubtitle` is nil, the `leadingTitle` is vertically centered within the space
/// that would have been occupied by both a title and a subtitle.
///
/// ```swift
/// FTProductOptionView(
///     leadingTitle: "Monthly",
///     leadingSubtitle: "2.99 USD/month",
///     trailingDescription: "Try Free For 3 days",
/// )
/// .environment(\.layoutDirection, .rightToLeft) // Compliments layoutDirection
///
/// FTProductOptionView(
///     leadingTitle: "Annual",
///     // leadingSubtitle is nil here
///     trailingDescription: "Save 20%",
/// )
/// .descriptionStyle(Color.green)
/// ```
public struct FTProductOptionView: View {
    // Leading
    private let leadingTitle: String
    private let leadingSubtitle: String?
    
    // Trailing
    private let trailingDescription: String
    
    // Modifiable
    private var descriptionColor: AnyShapeStyle = .init(Color.primary)
    private var isSelected: Bool = false
    
    public var body: some View {
        HStack {
            // Leading VStack
            VStack(alignment: .leading) {
                Text(leadingTitle)
                    .font(.title3)
                // Still needs some text to have an impact on the height
                // 0.description in this example
                Text(leadingSubtitle ?? 0.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .foregroundStyle(Color.clear)
            .overlay {
                VStack(alignment: .leading) {
                    Text(leadingTitle)
                        .font(.title3)
                    if let leadingSubtitle {
                        Text(leadingSubtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            Spacer()
            // Trailing
            Text(trailingDescription)
                .font(.title3)
                .foregroundStyle(descriptionColor)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background {
            ZStack {
                if isSelected {
                RoundedRectangle(cornerRadius: 16)
                        .opacity(0.1)
                }
                RoundedRectangle(cornerRadius: 16)
                    .stroke(lineWidth: 2)
            }
        }
        .contentShape(.rect)
    }
    
    /// Initializes a view for displaying a product or subscription option.
    ///
    /// This view is designed to maintain a consistent overall height. If a `leadingSubtitle`
    /// is not provided, the `leadingTitle` will be vertically centered within the space
    /// that would have been occupied by both a title and a subtitle, ensuring visual
    /// consistency when displayed in a list or grid.
    ///
    /// - Parameters:
    ///   - leadingTitle: The main title for the option (e.g., "Monthly Subscription").
    ///   - leadingSubtitle: An optional subtitle providing additional details.
    ///                      If `nil`, space is still reserved, and the `leadingTitle` is centered.
    ///   - trailingDescription: A description, price, or call to action displayed on the trailing side (e.g., "$9.99" or "Save 10%").
    public init(
        leadingTitle: String,
        leadingSubtitle: String? = nil,
        trailingDescription: String,
    ) {
        self.leadingTitle = leadingTitle
        self.leadingSubtitle = leadingSubtitle
        self.trailingDescription = trailingDescription
    }
}

public extension FTProductOptionView {
    /// Changes the color of the description of the view.
    /// - Parameter style: The color of the `trailingDescription` text. Defaults to `.primary`.
    /// - Returns: Modifed view.
    func descriptionStyle<S: ShapeStyle>(_ style: S) -> Self {
        var copy = self
        copy.descriptionColor = AnyShapeStyle(style)
        return copy
    }
    
    func selected(_ isSelected: Bool) -> Self {
        var copy = self
        copy.isSelected = isSelected
        return copy
    }
}
