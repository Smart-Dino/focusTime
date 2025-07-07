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
            Color.ftDeepBackground
                .ignoresSafeArea()
            
            Circle()
                .fill(
                    EllipticalGradient(
                        gradient: .init(colors: [
                            Color.ftGradientTop.opacity(FocusSessionView.Constants.Gradient.Layout.gradientOpacity),
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
                            Color.ftGradientBottom.opacity(FocusSessionView.Constants.Gradient.Layout.gradientOpacity),
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
    func body(content: Content) -> some View {
        ZStack {
            GradientBackgroundView()
                .ignoresSafeArea()
            content
        }
    }
}

extension View {
    func gradientBackground() -> some View {
        self.modifier(GradientBackgroundModifier())
    }
}


#Preview {
    GradientBackgroundView()
}
