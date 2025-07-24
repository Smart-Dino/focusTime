//
//  SlideOnboardingView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 19.05.25.
//

import SwiftUI
import OnboardingKit

// MARK: - SlideOnboardingView
struct SlideOnboardingView: View {
  
    @State var builder = LiveOnboardingBuilder()
    
    var body: some View {
        VStack{
            builder
                .setViewModel(SlideOnboardingStep.allCases.map { $0.slide })
                .setNextButtonConfiguration(ButtonUIConfiguration(
                    title: String(localized: "Next", table: "OnboardingLocalizable"),
                    buttonStyle: PrimaryButtonStyle(
                        verticalPadding: SlideOnboardingConstants.Layout.buttonVerticalPadding)
                ))
                .setStartAppButtonConfiguration(ButtonUIConfiguration(
                    title: String(localized: "Start Focusing", table: "OnboardingLocalizable"),
                    buttonStyle: PrimaryButtonStyle(
                        backgroundColor: .ftMainBlue,
                        verticalPadding: 14
                    ),
                    {
                        // TODO: - Replace with actual navigation logic
                    }
                ))
                .setProgressBarConfiguration(ProgressBarUIConfiguration(
                    activeColor: .blue,
                    inactiveColor: Color.gray.opacity(SlideOnboardingConstants.Layout.progressBarInactiveColorOpacity)
                ))
                .setSizeUIConfiguration(SizeUIConfiguration())
                .setThemeStyle(OnboardingThemeStyle(
                    skipButtonTextColor: .blue,
                    backgroundView: AnyView(
                        ZStack {
                            Image("OnboardingSlideQuizBackground")
                                .resizable()
                            
                            Color(.ftQuizSlideOnboardingMaskColor)
                                .opacity(SlideOnboardingConstants.Layout.OnboardingMaskOpacity)
                        }
                    )
                ))
                .buildView()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SlideOnboardingView()
}
