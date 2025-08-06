//
//  OnboardingFlowCoordinatorView.swift
//  FocusTime
//
//  Created by Maksym Horobets on 31.07.2025.
//

import SwiftUI

struct OnboardingFlowCoordinatorView: View {
    @State var viewModel: OnboardingFlowCoordinatorViewModel
    
    var body: some View {
        Group {
            switch viewModel.state.currentFlow {
            case .quiz(let quizOnboardingViewModel):
                QuizOnboardingView(viewModel: quizOnboardingViewModel)
            case .slide(let slideOnboardingViewModel):
                SlideOnboardingView(viewModel: slideOnboardingViewModel)
                    .transition(.move(edge: .trailing))
            }
        }
    }
}

#Preview {
    OnboardingFlowCoordinatorView(viewModel: .init(appFlowDelegate: nil))
}
