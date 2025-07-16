//
//  SlideOnboardingView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 19.05.25.
//

import SwiftUI
import FocusTimeUI

// MARK: - SlideOnboardingView

struct SlideOnboardingView: View {
    // MARK: - Properties
    @State private var viewModel = SlideOnboardingViewModel()
        
    // MARK: - Body
    var body: some View {
        VStack {
            // MARK: - Header Section
            VStack {
                Text(Constants.Strings.title)
                    .font(.title3.bold())
                    .multilineTextAlignment(.center)
                 
                FTProgressBarView(
                    items: viewModel.state.progressItems,
                    selectedItem: Binding(
                        get: { viewModel.state.currentStep },
                        set: { _ in } ))
                .padding(.top, Constants.Layout.progressBarTopPadding)
            }
            
            // MARK: - Image Section
            // TODO: - Update image with actual image
            Image(viewModel.state.currentStep.imageName)
                .resizable()
                .scaledToFill()
                .containerRelativeFrame(.vertical, { amount, axis in
                    amount / 1.8
                })
                .clipped()
                .padding(.top, Constants.Layout.topPadding)
                .id(viewModel.state.currentStep.imageName)
                .transition(.opacity)
                .animation(.easeInOut, value: viewModel.state.currentStep.imageName)
            
            // MARK: - Subtitle Section
            VStack {
                Text(viewModel.state.currentStep.subtitle1)
                    .font(.headline)
                Text(viewModel.state.currentStep.subtitle2)
                    .font(.subheadline)
            }
            .frame(height: Constants.Layout.subtitleSectionHeight)
            .multilineTextAlignment(.center)
            
            
            // MARK: - Buttons
            if !viewModel.state.currentStep.isLast {
                VStack(spacing: Constants.Layout.buttonSpacing) {
                    Button(Constants.Strings.nextButton) {
                        viewModel.goToNextStep()
                    }
                    .buttonStyle(FTPrimaryButtonStyle())
                    
                    Button(Constants.Strings.skipButton) {
                        viewModel.requestSkipConfirmation()
                    }
                }
                .frame(height: Constants.Layout.buttonSectionHeight)
                
            } else {
                Button(Constants.Strings.startButton) {
                    // TODO: - Navigate to main app flow
                }
                .frame(height: Constants.Layout.buttonSectionHeight)
                .buttonStyle(FTPrimaryButtonStyle())
            }
        }
        .animation(.easeInOut, value: viewModel.state.currentStep)
        .preferredColorScheme(.dark)
        
        // MARK: - Skip Confirmation Alert
        .alert(Constants.Strings.alertTitle, isPresented: viewModel.isSkipConfirmationPresented) {
            Button(Constants.Strings.skipAnyway, role: .destructive) {
                viewModel.skipOnboarding()
            }
            Button(Constants.Strings.goBack, role: .cancel) {
                            viewModel.cancelSkipConfirmation()
                        }
                    } message: {
                        Text(Constants.Strings.alertMessage)
                    }
    }
}


#Preview {
    SlideOnboardingView()
}
