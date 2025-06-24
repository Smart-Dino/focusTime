//
//  GradientBackgroundView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 23.06.25.
//

import SwiftUI

struct GradientBackgroundView: View {
    private typealias Constants = FocusSessionView.Constants.Gradient
    
    var body: some View {
        ZStack {
            Constants.Colors.backgroundDeep
                .ignoresSafeArea()
            
            Circle()
                .fill(
                    EllipticalGradient(
                        gradient: .init(colors: [Constants.Colors.gradientTop.opacity(Constants.Layout.gradientOpacity), .clear]),
                        center: .center,
                        startRadiusFraction: 0,
                        endRadiusFraction: 1
                    )
                )
                .blur(radius: Constants.Layout.blurRadius)
                .frame(width: Constants.Layout.topCircleWidth, height: Constants.Layout.topCircleHeight)
                .offset(y: Constants.Layout.topCircleOffsetY)
            
            Circle()
                .fill(
                    EllipticalGradient(
                        gradient: .init(colors: [Constants.Colors.gradientBottom.opacity(Constants.Layout.gradientOpacity), .clear]),
                        center: .center,
                        startRadiusFraction: 0,
                        endRadiusFraction: 1
                    )
                )
                .blur(radius: Constants.Layout.blurRadius)
                .frame(width: Constants.Layout.bottomCircleWidth, height: Constants.Layout.bottomCircleHeight)
                .offset(y: Constants.Layout.bottomCircleOffsetY)
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
