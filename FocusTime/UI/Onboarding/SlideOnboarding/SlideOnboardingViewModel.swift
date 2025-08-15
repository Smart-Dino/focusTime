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
        
        init(
            onboardingSlides: [OnboardingSlide] = SlideOnboardingStep.allCases.map { $0.slide },
            nextButtonTitle: String,
            startAppButtonTitle: String,
            buttonVerticalPadding: CGFloat,
            progressBarActiveColor: Color,
            progressBarInactiveColorOpacity: CGFloat,
            onboardingMaskOpacity: CGFloat,
            skipButtonTextColor: Color,
            onboardingBackgroundImageName: String
        ) {
            self.onboardingSlides = onboardingSlides
            self.nextButtonTitle = nextButtonTitle
            self.startAppButtonTitle = startAppButtonTitle
            self.buttonVerticalPadding = buttonVerticalPadding
            self.progressBarActiveColor = progressBarActiveColor
            self.progressBarInactiveColorOpacity = progressBarInactiveColorOpacity
            self.onboardingMaskOpacity = onboardingMaskOpacity
            self.skipButtonTextColor = skipButtonTextColor
            self.onboardingBackgroundImageName = onboardingBackgroundImageName
        }
    }
    
    // MARK: - ViewModel Properties
    private(set) var state: State
    private let startAction: () -> Void
    weak var delegate: SlideOnboardingDelegate?
    
    var nextButtonConfig: ButtonUIConfiguration {
        ButtonUIConfiguration(
            title: state.nextButtonTitle,
            buttonStyle: PrimaryButtonStyle(
                verticalPadding: state.buttonVerticalPadding
            )
        ) {
            // Log action.
        }
    }
    
    var startAppButtonConfig: ButtonUIConfiguration {
        ButtonUIConfiguration(
            title: state.startAppButtonTitle,
            buttonStyle: PrimaryButtonStyle(
                verticalPadding: 14
            )
        ) {
            self.delegate?.didFinishOnboardingSlides(skipped: nil)
        }
    }
    
    // MARK: - Lifecycle
    init(
        state: State = State(
            nextButtonTitle: SlideOnboardingView.SlideOnboardingConstants.Strings.nextButtonTitle,
            startAppButtonTitle: SlideOnboardingView.SlideOnboardingConstants.Strings.startAppButtonTitle,
            buttonVerticalPadding: SlideOnboardingView.SlideOnboardingConstants.Layout.buttonVerticalPadding,
            progressBarActiveColor: SlideOnboardingView.SlideOnboardingConstants.Colors.progressBarActiveColor,
            progressBarInactiveColorOpacity: SlideOnboardingView.SlideOnboardingConstants.Layout.progressBarInactiveColorOpacity,
            onboardingMaskOpacity: SlideOnboardingView.SlideOnboardingConstants.Layout.onboardingMaskOpacity,
            skipButtonTextColor: SlideOnboardingView.SlideOnboardingConstants.Colors.skipButtonTextColor,
            onboardingBackgroundImageName: SlideOnboardingView.SlideOnboardingConstants.Images.onboardingBackgroundImageName
        ),
        delegate: SlideOnboardingDelegate?,
        onStart: @escaping () -> Void = {}
    ) {
        self.state = state
        self.delegate = delegate
        self.startAction = onStart
    }
    
    
    // MARK: - Actions
    func didTapStartFocusing() {
        startAction()
    }
}
