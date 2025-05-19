//
//  SlideOnboardingViewModel.swift
//  FocusTime
//
//  Created by Keto Nioradze on 19.05.25.
//

// OnboardingViewModel.swift

import SwiftUI
import Observation

// MARK: - OnboardingStep Enum

/// Represents each step in the onboarding flow.
/// Each case provides associated subtitles and image name.
enum SlideOnboardingStep: Int, CaseIterable {
    case step1, step2, step3, step4

    /// The first subtitle text for the step.
    var subtitle1: String {
        switch self {
        case .step1: return "Wave Cycles"
        case .step2: return "Tide Blocker"
        case .step3: return "Current Tracker"
        case .step4: return "Ocean of Achievement"
        }
    }

    /// The second subtitle text, a descriptive detail for the step.
    var subtitle2: String {
        switch self {
        case .step1: return "25-minute focus sessions followed by 5-minute recovery breaks, modeled after the natural rhythm of ocean waves"
        case .step2: return "Automatically silences notifications and blocks distracting apps during your focus sessions, keeping your mental waters clear"
        case .step3: return "Visualize your productivity patterns with intuitive analytics that show your focus trends and improvements over time"
        case .step4: return "Collect unique marine-themed awards as you develop stronger focus habits and reach new productivity depths"
        }
    }
    
    /// The image name associated with each onboarding step.
    /// Currently all steps use the same placeholder image.
    var imageName: String {
            switch self {
            case .step1: return "SlideOnboardingImage" 
            case .step2: return "SlideOnboardingImage"
            case .step3: return "SlideOnboardingImage"
            case .step4: return "SlideOnboardingImage"
            }
        }

    /// Indicates whether this step is the last step in the onboarding flow.
    var isLast: Bool {
        self == Self.allCases.last
    }
}

// MARK: - SlideOnboardingViewModel

/// ViewModel managing the state and navigation of onboarding steps.
@Observable
class SlideOnboardingViewModel {
    
    /// The current onboarding step shown in the view.
    var currentStep: SlideOnboardingStep = .step1

    /// Advances to the next onboarding step if not at the last step.
    func goToNextStep() {
        if currentStep.rawValue < SlideOnboardingStep.allCases.count - 1 {
            currentStep = SlideOnboardingStep(rawValue: currentStep.rawValue + 1) ?? currentStep
        }
    }

    /// Skips directly to the last onboarding step.
    func skipOnboarding() {
        currentStep = .step4
    }
}
