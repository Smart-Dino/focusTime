//
//  FirstImageView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 04.08.25.
//

import SwiftUI
import FocusTimeUI

struct FirstImageView: View {
    var body: some View {
        ZStack(alignment: .center) {
            Image("WaveCycles")
                .resizable()
            
            Ellipse()
                .fill(SlideOnboardingView.SlideOnboardingConstants.Colors.timerBackgroundColor.opacity(SlideOnboardingView.SlideOnboardingConstants.Layout.blurColorOpacity))
                .rotationEffect(SlideOnboardingView.SlideOnboardingConstants.Layout.blurRotationDegrees)
                .blur(radius: SlideOnboardingView.SlideOnboardingConstants.Layout.blurRadius, opaque: false)
                .padding(.vertical, SlideOnboardingView.SlideOnboardingConstants.Layout.blurHorisontalPadding)
                .frame(width: SlideOnboardingView.SlideOnboardingConstants.Layout.blurWidth)
            
            VStack(spacing: SlideOnboardingView.SlideOnboardingConstants.Layout.timerStackSpacing) {
                
                HStack {
                    ZStack(alignment: .center) {
                        Rectangle()
                            .fill(SlideOnboardingView.SlideOnboardingConstants.Colors.timerBackgroundColor)
                            .frame(width: SlideOnboardingView.SlideOnboardingConstants.Layout.timerBlockWidth, height: SlideOnboardingView.SlideOnboardingConstants.Layout.timerBlockHeight)
                            .cornerRadius(SlideOnboardingView.SlideOnboardingConstants.Layout.timerBlockCornerRadius)
                            .overlay(
                                RoundedRectangle(cornerRadius: SlideOnboardingView.SlideOnboardingConstants.Layout.timerBlockCornerRadius).stroke( SlideOnboardingView.SlideOnboardingConstants.Colors.timerStrokeColor, lineWidth: SlideOnboardingView.SlideOnboardingConstants.Layout.timerStrokeWidth)
                            )
                            .shadow(color: SlideOnboardingView.SlideOnboardingConstants.Colors.timerStrokeColor.opacity(SlideOnboardingView.SlideOnboardingConstants.Layout.shadowColorOpacity), radius: SlideOnboardingView.SlideOnboardingConstants.Layout.shadowRadius)
                        
                        Text("24")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Rectangle()
                            .fill(SlideOnboardingView.SlideOnboardingConstants.Colors.timerBackgroundColor)
                            .frame(width: SlideOnboardingView.SlideOnboardingConstants.Layout.dividerWidth, height: SlideOnboardingView.SlideOnboardingConstants.Layout.dividerHeight)
                    }
                    
                    ZStack{
                        Rectangle()
                            .fill(SlideOnboardingView.SlideOnboardingConstants.Colors.timerBackgroundColor)
                            .frame(width: SlideOnboardingView.SlideOnboardingConstants.Layout.timerBlockWidth, height: SlideOnboardingView.SlideOnboardingConstants.Layout.timerBlockHeight)
                            .cornerRadius(SlideOnboardingView.SlideOnboardingConstants.Layout.timerBlockCornerRadius)
                            .overlay(
                                RoundedRectangle(cornerRadius: SlideOnboardingView.SlideOnboardingConstants.Layout.timerBlockCornerRadius).stroke( SlideOnboardingView.SlideOnboardingConstants.Colors.timerStrokeColor, lineWidth: SlideOnboardingView.SlideOnboardingConstants.Layout.timerStrokeWidth)
                            )
                            .shadow(color: SlideOnboardingView.SlideOnboardingConstants.Colors.timerStrokeColor.opacity(SlideOnboardingView.SlideOnboardingConstants.Layout.shadowColorOpacity), radius: SlideOnboardingView.SlideOnboardingConstants.Layout.shadowRadius)
                        
                        Text("59")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Rectangle()
                            .fill(SlideOnboardingView.SlideOnboardingConstants.Colors.timerBackgroundColor)
                            .frame(width: SlideOnboardingView.SlideOnboardingConstants.Layout.dividerWidth, height: SlideOnboardingView.SlideOnboardingConstants.Layout.dividerHeight)
                    }
                }
                
                Text(SlideOnboardingView.SlideOnboardingConstants.Strings.firstSlideTextTitle)
                    .foregroundColor(.gray)
            }
        }
        .background(.ftBackground)
    }
}

#Preview {
    FirstImageView()
}
