//
//  SlideOnboardingViewModel.swift
//  FocusTime
//
//  Created by Keto Nioradze on 29.07.25.
//

import SwiftUI
import OnboardingKit

@Observable
@MainActor
final class SlideOnboardingViewModel {
    
    // MARK: - State Struct
    @MainActor
    struct State {
        let onboardingSlides: [OnboardingSlide]

        let nextButtonTitle: String
        let startAppButtonTitle: String
        let buttonVerticalPadding: CGFloat
        let progressBarActiveColor: Color
        let progressBarInactiveColorOpacity: CGFloat
        let onboardingMaskOpacity: CGFloat
        let skipButtonTextColor: Color
        let onboardingBackgroundImageName: String
        
        // MARK: - Computed Properties for Builder Configurations (referencing `state`)
        var nextButtonConfig: ButtonUIConfiguration {
            ButtonUIConfiguration(
                title: nextButtonTitle,
                buttonStyle: PrimaryButtonStyle(
                    verticalPadding: buttonVerticalPadding
                )
            )
        }

        var progressBarConfig: ProgressBarUIConfiguration {
            ProgressBarUIConfiguration(
                activeColor: progressBarActiveColor,
                inactiveColor: Color.gray.opacity(progressBarInactiveColorOpacity)
            )
        }
        
        var onboardingThemeStyle: OnboardingThemeStyle {
            OnboardingThemeStyle(
                skipButtonTextColor: skipButtonTextColor,
                backgroundView: AnyView(
                    ZStack {
                        Image(onboardingBackgroundImageName)
                            .resizable()
                    }
                )
            )
        }

        init() {
            self.onboardingSlides = SlideOnboardingStep.allCases.map { $0.slide }

            self.nextButtonTitle = SlideOnboardingView.SlideOnboardingConstants.Strings.nextButtonTitle
            self.startAppButtonTitle = SlideOnboardingView.SlideOnboardingConstants.Strings.startAppButtonTitle
            self.buttonVerticalPadding = SlideOnboardingView.SlideOnboardingConstants.Layout.buttonVerticalPadding
            self.progressBarActiveColor = SlideOnboardingView.SlideOnboardingConstants.Colors.progressBarActiveColor
            self.progressBarInactiveColorOpacity = SlideOnboardingView.SlideOnboardingConstants.Layout.progressBarInactiveColorOpacity
            self.onboardingMaskOpacity = SlideOnboardingView.SlideOnboardingConstants.Layout.onboardingMaskOpacity
            self.skipButtonTextColor = SlideOnboardingView.SlideOnboardingConstants.Colors.skipButtonTextColor
            self.onboardingBackgroundImageName = SlideOnboardingView.SlideOnboardingConstants.Images.onboardingBackgroundImageName
        }
    }

    // MARK: - ViewModel Properties
    private(set) var state = State()

    // MARK: - Lifecycle
    init(state: State = State()) {
        self.state = state
    }

    // MARK: - Actions (Placeholder for navigation logic)
    func didTapStartFocusing() {
        // TODO: Implement actual navigation logic after onboarding
        print("Start Focusing button tapped from ViewModel!")
    }
    
    var startAppButtonConfig: ButtonUIConfiguration {
        ButtonUIConfiguration(
            title: state.startAppButtonTitle,
            buttonStyle: PrimaryButtonStyle(
                verticalPadding: 14
            ),
            { [weak self] in
                self?.didTapStartFocusing()
            }
        )
    }
}
