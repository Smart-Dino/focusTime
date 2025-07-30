//
//  RotationModifier.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 23.06.2025.
//

import SwiftUI

internal extension View {
    func rotatingNumberOverlay(
        configuration: FTFlipClockConfiguration,
        rotation: CGFloat,
        currentValue: Int,
        nextValue: Int
    ) -> some View {
        self.modifier(
            RotatingNumberOverlayModifier(
                configuration: configuration,
                rotation: rotation,
                currentValue: currentValue,
                nextValue: nextValue
            )
        )
    }
}

nonisolated internal struct RotatingNumberOverlayModifier: ViewModifier, Animatable {
    private var configuration: FTFlipClockConfiguration
    
    private var rotation: CGFloat
    private var currentValue: Int
    private var nextValue: Int
    
    internal var animatableData: CGFloat {
        get { rotation }
        set { rotation = newValue }
    }
    
    internal func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                Group {
                    // Rotation is negative when animating,
                    // so we make it positive and if it is
                    // more than half way through the animation
                    // - we change the value to the next one
                    // and flip it.
                    if -rotation > 90 {
                        FlipClockBoldTextView(
                            nextValue,
                            fontSize: configuration.fontSize,
                            foreground: configuration.foreground
                        )
                        .scaleEffect(x: 1, y: -1) // Flip the view.
                        .transition(.identity)
                    } else {
                        FlipClockBoldTextView(
                            currentValue,
                            fontSize: configuration.fontSize,
                            foreground: configuration.foreground
                        )
                        .transition(.identity)
                    }
                }
                .frame(width: configuration.size.width, height: configuration.size.height)
            }
    }
    
    internal init(
        configuration: FTFlipClockConfiguration,
        rotation: CGFloat,
        currentValue: Int,
        nextValue: Int
    ) {
        self.configuration = configuration
        self.rotation = rotation
        self.currentValue = currentValue
        self.nextValue = nextValue
    }
    
}
