//
//  OnboardingFlowCoordinatorViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 31.07.2025.
//

import SwiftUI
import Foundation

enum OnboardingScreens: Equatable, Hashable {
    case quiz(viewModel: QuizOnboardingViewModel)
    case slide(viewModel: SlideOnboardingViewModel)
    
    var id: String {
        switch self {
        case .quiz: return "quiz"
        case .slide: return "slide"
        }
    }
    
    static func == (lhs: OnboardingScreens, rhs: OnboardingScreens) -> Bool {
        switch (lhs, rhs) {
        case (.quiz, .quiz): return true
        case (.slide, .slide): return true
        default: return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .quiz: hasher.combine(0)
        case .slide: hasher.combine(1)
        }
    }
}

@MainActor
@Observable
final class OnboardingFlowCoordinatorViewModel {
    struct State {
        var currentFlow: OnboardingScreens
    }
    
    private(set) var state: State!
    weak var appFlowDelegate: OnboardingFlowNavigationDelegate?
    
    init(appFlowDelegate: OnboardingFlowNavigationDelegate?) {
        self.appFlowDelegate = appFlowDelegate
        self.state = State(
            currentFlow: .quiz(
                viewModel: makeQuizOnboardingViewModel()
            )
        )
    }
    
    func setStateFlow(to screen: OnboardingScreens?) {
        if let screen {
            withAnimation {
                state.currentFlow = screen
            }
        }
    }
    
    func makeQuizOnboardingViewModel() -> QuizOnboardingViewModel {
        QuizOnboardingViewModel(delegate: self)
    }
    
    func makeSlideOnboardingViewModel() -> SlideOnboardingViewModel {
        SlideOnboardingViewModel(delegate: self)
    }
}

extension OnboardingFlowCoordinatorViewModel: QuizOnboardingDelegate {
    func didFinishQuiz(with results: Set<QuizOnboardingView.Constants.QuizOption>) {
        #warning("Log results?")
        setStateFlow(to: .slide(viewModel: makeSlideOnboardingViewModel()))
    }
}

extension OnboardingFlowCoordinatorViewModel: SlideOnboardingDelegate {
    func didFinishOnboardingSlides(skipped: Bool) {
        #warning("Log results?")
        appFlowDelegate?.didFinishOnboarding()
    }
}
