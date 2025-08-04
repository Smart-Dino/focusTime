//
//  FocusSessionBackgroundShape.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 17.06.2025.
//

import SwiftUI

internal struct FocusSessionBackgroundShape: Shape {
    internal func path(in rect: CGRect) -> Path {
        UnevenRoundedRectangle(
            cornerRadii: .init(
                topLeading: 25,
                bottomLeading: 0,
                bottomTrailing: 25,
                topTrailing: 0
            )
        ).path(in: rect)
    }
}
