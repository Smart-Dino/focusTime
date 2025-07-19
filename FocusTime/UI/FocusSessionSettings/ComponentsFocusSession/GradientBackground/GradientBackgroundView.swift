//
//  GradientBackgroundView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 23.06.25.
//

import SwiftUI
import FocusTimeUI

struct GradientBackgroundView: View {
    var body: some View {
        ZStack {
            Color.ftBackground
                .ignoresSafeArea()
            
            Circle()
                .fill(
                    EllipticalGradient(
                        gradient: .init(colors: [
                            Color.ftGradientTopColor.opacity(FocusSessionView.Constants.Gradient.Layout.gradientOpacity),
                            .clear
                        ]),
                        center: .center,
                        startRadiusFraction: 0,
                        endRadiusFraction: 1
                    )
                )
                .blur(radius: FocusSessionView.Constants.Gradient.Layout.blurRadius)
                .frame(width: FocusSessionView.Constants.Gradient.Layout.topCircleWidth, height: FocusSessionView.Constants.Gradient.Layout.topCircleHeight)
                .offset(y: FocusSessionView.Constants.Gradient.Layout.topCircleOffsetY)
            
            Circle()
                .fill(
                    EllipticalGradient(
                        gradient: .init(colors: [
                            Color.ftGradientBottomColor.opacity(FocusSessionView.Constants.Gradient.Layout.gradientOpacity),
                            .clear
                        ]),
                        center: .center,
                        startRadiusFraction: 0,
                        endRadiusFraction: 1
                    )
                )
                .blur(radius: FocusSessionView.Constants.Gradient.Layout.blurRadius)
                .frame(width: FocusSessionView.Constants.Gradient.Layout.bottomCircleWidth, height: FocusSessionView.Constants.Gradient.Layout.bottomCircleHeight)
                .offset(y: FocusSessionView.Constants.Gradient.Layout.bottomCircleOffsetY)
        }
    }
}

struct GradientBackgroundModifier: ViewModifier {
    /// Applies a gradient background behind the provided content, ensuring the background covers the entire safe area.
    /// - Parameter content: The view content to display above the gradient background.
    /// - Returns: A view with the gradient background layered beneath the content.
    func body(content: Content) -> some View {
        ZStack {
            GradientBackgroundView()
                .ignoresSafeArea()
            content
        }
    }
}

extension View {
    /// Applies a gradient background with blurred elliptical circles behind the view. 
    /// - Returns: A view with the gradient background applied.
    func gradientBackground() -> some View {
        self.modifier(GradientBackgroundModifier())
    }
}


#Preview {
    GradientBackgroundView()
}
