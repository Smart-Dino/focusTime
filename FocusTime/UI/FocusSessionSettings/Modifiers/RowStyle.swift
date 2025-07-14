//
//  RowStyle.swift
//  FocusTime
//
//  Created by Keto Nioradze on 18.06.25.
//

import SwiftUI

struct RowStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(height: FocusSessionView.Constants.Row.height)
            .background(Color.ftPresetBackgroundColor)
            .cornerRadius(FocusSessionView.Constants.Row.cornerRadius)
            .tint(.white)
    }
}

extension View {
    func rowStyle() -> some View {
        self.modifier(RowStyle())
    }
}
