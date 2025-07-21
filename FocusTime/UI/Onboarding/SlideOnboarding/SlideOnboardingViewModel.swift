//
//  SlideOnboardingViewModel.swift
//  FocusTime
//
//  Created by Keto Nioradze on 19.05.25.
//

// OnboardingViewModel.swift

import SwiftUI
import Observation

// MARK: - SlideOnboardingViewModel

@MainActor
@Observable
final class SlideOnboardingViewModel {
    
    struct State {
        var currentIndex: Int = 0
        var showSkipConfirmation: Bool = false
        let progressItems: [SlideOnboardingStep] = SlideOnboardingStep.allCases
        
        var currentStep: SlideOnboardingStep {
            SlideOnboardingStep.allCases[currentIndex]
        }
    }
    
    private(set) var state = State()

    
    var isSkipConfirmationPresented: Binding<Bool> {
        Binding {
            self.state.showSkipConfirmation
        } set: { newValue in
            self.state.showSkipConfirmation = newValue
        }
    }
    
    func goToNextStep() {
        if state.currentIndex < state.progressItems.count - 1 {
            state.currentIndex += 1
        }
    }
    
    func requestSkipConfirmation() {
        state.showSkipConfirmation = true
    }

    func skipOnboarding() {
        // TODO: - Navigate to main app flow
        state.currentIndex = state.progressItems.count - 1
    }
    
    func cancelSkipConfirmation() {
         state.showSkipConfirmation = false
     }
}
