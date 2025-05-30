//
//  SlideOnboardingView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 19.05.25.
//

import SwiftUI
import FocusTimeUI

struct SlideOnboardingView: View {

    @State var viewModel: SlideOnboardingViewModel
    @Binding var hasCompletedOnboarding: Bool
    private let progressItems = SlideOnboardingStep.allCases

    init(viewModel: SlideOnboardingViewModel, hasCompletedOnboarding: Binding<Bool>) {

        self.viewModel = viewModel
        _viewModel = State(initialValue: viewModel)
        self._hasCompletedOnboarding = hasCompletedOnboarding
    }


    var body: some View {
        VStack {
            VStack {
                Text(Constants.Strings.title)
                    .font(.title3.bold())
                    .multilineTextAlignment(.center)
                 
                FTProgressBarView(
                    items: progressItems,
                    selectedItem: Binding(
                        get: { progressItems[viewModel.currentStepIndex] },
                        set: { _ in }
                    )
                )
                .padding(.top, Constants.Layout.progressBarTopPadding)
            }
            
            Image(viewModel.currentStep.imageName)
                .resizable()
                .scaledToFill()
                .containerRelativeFrame(.vertical, { amount, axis in amount / 1.8 })
                .clipped()
                .padding(.top, Constants.Layout.topPadding)
                .id(viewModel.currentStep.imageName)
                .transition(.opacity)
                .animation(.easeInOut, value: viewModel.currentStep.imageName)

            VStack {
                Text(viewModel.currentStep.subtitle1)
                    .font(.headline)
                    .id("subtitle1_\(viewModel.currentStep.hashValue)")
                    
                Text(viewModel.currentStep.subtitle2)
                    .font(.subheadline)
                    .id("subtitle2_\(viewModel.currentStep.hashValue)")
                    
            }
            .frame(height: Constants.Layout.subtitleSectionHeight)
            .multilineTextAlignment(.center)
            

            if !viewModel.currentStep.isLast {
                VStack(spacing: Constants.Layout.buttonSpacing) {
                    Button(Constants.Strings.nextButton) {
                        viewModel.goToNextStep()
                    }
                    .buttonStyle(FTPrimaryButtonStyle())
                    
                    Button(Constants.Strings.skipButton) {
                        viewModel.skipOnboardingInitiated()
                    }
                }
                .frame(height: Constants.Layout.buttonSectionHeight)
                
                
            } else {
                Button(Constants.Strings.startButton) {
                    viewModel.completeOnboarding()
                    // TODO: - Navigate to main app flow
                    hasCompletedOnboarding = true
                }
                .frame(height: Constants.Layout.buttonSectionHeight)
                .buttonStyle(FTPrimaryButtonStyle())
                
            }
        }
        .animation(.easeInOut, value: viewModel.currentStep)
        .preferredColorScheme(.dark)
        .navigationBarBackButtonHidden(true)
        
        .alert(Constants.Strings.alertTitle, isPresented: $viewModel.state.showSkipConfirmation) {
            Button(Constants.Strings.skipAnyway, role: .destructive) {
                viewModel.skipOnboardingConfirmed()
                hasCompletedOnboarding = true
            }
            Button(Constants.Strings.goBack, role: .cancel) {}
        } message: {
            Text(Constants.Strings.alertMessage)
        }
    }
}

#Preview {
    struct SlideOnboardingPreviewWrapper: View {
        @State var mockViewModel = SlideOnboardingViewModel(analyticsManager: AppAnalytics.shared)
        @State var mockHasCompletedOnboarding = false

        var body: some View {

            NavigationStack {
                SlideOnboardingView(
                    viewModel: mockViewModel,
                    hasCompletedOnboarding: $mockHasCompletedOnboarding
                )
            }
        }
    }
    return SlideOnboardingPreviewWrapper()
}
