//
//  FTFlipClockComponentView.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 23.06.2025.
//

import SwiftUI

public struct FTFlipClockComponentView: View {
    // MARK: - Config
    @Binding private var value: Int
    private let configuration: FTFlipClockConfiguration
    // MARK: - View properties
    @State private var nextValue: Int = .zero
    @State private var currentValue: Int = .zero
    @State private var rotation: CGFloat = .zero
    public var body: some View {
        let halfHeightWithSpacing = configuration.size.height * 0.5 - 1
        
        ZStack {
            VStack(spacing: .zero) {
                UnevenRoundedRectangle(
                    topLeadingRadius: configuration.cornerRadius,
                    topTrailingRadius: configuration.cornerRadius
                )
                .fill(configuration.background)
                .frame(height: halfHeightWithSpacing)
                .overlay(alignment: .top) {
                    FlipClockBoldTextView(
                        nextValue,
                        fontSize: configuration.fontSize,
                        foreground: configuration.foreground
                    )
                    .frame(
                        width: configuration.size.width,
                        height: configuration.size.height
                    )
                }
                .clipped()
                .frame(maxHeight: .infinity, alignment: .top)
                
                UnevenRoundedRectangle(
                    bottomLeadingRadius: configuration.cornerRadius,
                    bottomTrailingRadius: configuration.cornerRadius,
                )
                .fill(configuration.background)
                .frame(height: halfHeightWithSpacing)
                .overlay(alignment: .bottom) {
                    FlipClockBoldTextView(
                        currentValue,
                        fontSize: configuration.fontSize,
                        foreground: configuration.foreground
                    )
                    .frame(
                        width: configuration.size.width,
                        height: configuration.size.height
                    )
                }
                .clipped()
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .frame(maxHeight: configuration.size.height)
            
            UnevenRoundedRectangle(
                topLeadingRadius: configuration.cornerRadius,
                topTrailingRadius: configuration.cornerRadius
            )
            .fill(configuration.background)
            .frame(height: halfHeightWithSpacing)
            .rotatingNumberOverlay(configuration: configuration,
                                   rotation: rotation,
                                   currentValue: currentValue,
                                   nextValue: nextValue)
            .clipped()
            .frame(maxHeight: .infinity, alignment: .top)
            .rotation3DEffect(
                .init(degrees: rotation),
                axis: (x: 1.0, y: 0.0, z: 0.0),
                anchor: .center,
                perspective: 0.4
            )
            
        }
        .frame(width: configuration.size.width, height: configuration.size.height)
        .onChange(of: value, initial: true) { oldValue, newValue in
            currentValue = oldValue
            nextValue = newValue
            
            // Make sure previous animations have ended.
            guard rotation == 0 else {
                // Otherwise just set the value mid-animation.
                currentValue = value
                return
            }
            
            // Make sure the new value is different from the previous.
            guard oldValue != newValue else { return }
            
            withAnimation(
                .easeInOut(duration: configuration.animationDuration),
                completionCriteria: .logicallyComplete
            ) {
                // Flip.
                rotation = -180
            } completion: {
                // Reset.
                rotation = 0
                currentValue = value
            }
        }
        .drawingGroup() // Fixes number tearing.
    }
    
    public init(
        value: Binding<Int>,
        configuration: FTFlipClockConfiguration,
    ) {
        self._value = value
        self.configuration = configuration
    }
    
}

#Preview(traits: .sizeThatFitsLayout) {
    @Previewable @State var value: Int = 1
    
    VStack {
        FTFlipClockComponentView(
            value: $value,
            configuration: .init(),
        )
        .preferredColorScheme(.dark )
        
        Button("Increase value") { value += 1 }
    }
    .scaleEffect(2) // Zoom for an easier visual debugging.
}
