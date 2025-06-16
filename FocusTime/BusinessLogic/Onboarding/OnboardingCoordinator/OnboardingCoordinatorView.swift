//
//  OnboardingCoordinatorView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 30.05.25.
//

import SwiftUI

enum OnboardingNavigationPath: Hashable {
    case onboardingSlidesPath
}

struct OnboardingCoordinatorView: View {
    let viewModel: OnboardingCoordinatorViewModel

    var body: some View {
        
        let pathBinding = Binding(
            get: { viewModel.path },
            set: { viewModel.path = $0 }
        )
        
        NavigationStack(path: pathBinding) {
                    QuizOnboardingView(
                        viewModel: QuizOnboardingViewModel(
                            analyticsManager: viewModel.analyticsManager,
                            delegate: viewModel
                        )
                    )
            .navigationDestination(for: OnboardingNavigationPath.self) { pathValue in
                switch pathValue {
                case .onboardingSlidesPath:
                    SlideOnboardingView(
                        viewModel: SlideOnboardingViewModel(
                            analyticsManager: viewModel.analyticsManager,
                            delegate: viewModel
                        )
                    )
                }
            }
        }
    }
}
