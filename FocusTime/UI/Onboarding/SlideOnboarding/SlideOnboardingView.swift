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
    
    @State var viewModel: SlideOnboardingViewModel
    @State private var builder = LiveOnboardingBuilder()
    
    var body: some View {
        VStack {
            builder
                .setViewModel(viewModel.state.onboardingSlides)
                .setNextButtonConfiguration(viewModel.nextButtonConfig)
                .setStartAppButtonConfiguration(viewModel.startAppButtonConfig)
                .setProgressBarConfiguration(viewModel.state.progressBarConfig)
                .setSizeUIConfiguration(viewModel.state.sizeConfiguration)
                .setThemeStyle(viewModel.state.onboardingThemeStyle)
                .buildView()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SlideOnboardingView(viewModel: .init(delegate: nil))
}
