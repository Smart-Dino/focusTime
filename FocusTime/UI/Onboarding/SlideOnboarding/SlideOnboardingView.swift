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

    var body: some View {
        VStack {
            VStack {
                Text(Constants.Strings.title)
                    .font(.title3.bold())
                    .multilineTextAlignment(.center)
                 
                FTProgressBarView(
                    items: SlideOnboardingStep.allCases,
                    selectedItem: .constant(viewModel.state.currentStep)
                )
                .padding(.top, Constants.Layout.progressBarTopPadding)
            }
            
            Image(viewModel.state.currentStep.imageName)
                .resizable()
                .scaledToFill()
                .containerRelativeFrame(.vertical, { amount, axis in amount / 1.8 })
                .clipped()
                .padding(.top, Constants.Layout.topPadding)
                .transition(.opacity)
                .animation(.easeInOut, value: viewModel.state.currentStep.imageName)

            VStack {
                Text(viewModel.state.currentStep.subtitle1)
                    .font(.headline)
                    
                Text(viewModel.state.currentStep.subtitle2)
                    .font(.subheadline)
                    
            }
            .frame(height: Constants.Layout.subtitleSectionHeight)
            .multilineTextAlignment(.center)
            
            
                VStack{
                    if !viewModel.state.currentStep.isLast {
                        VStack(spacing: Constants.Layout.buttonSpacing) {
                            Button(Constants.Strings.nextButton) {
                                viewModel.goToNextStep()
                            }
                            .buttonStyle(FTPrimaryButtonStyle())
                            
                            Button(Constants.Strings.skipButton) {
                                viewModel.skipOnboardingInitiated()
                            }
                        }
                        
                    } else {
                        Button(Constants.Strings.startButton) {
                            viewModel.completeOnboarding()
                        }
                        .buttonStyle(FTPrimaryButtonStyle())
                    }
                }
                .containerRelativeFrame(.vertical) { fullHeight, _ in
                    fullHeight * 0.1 
                }
        }
        .animation(.easeInOut, value: viewModel.state.currentStep)
        .preferredColorScheme(.dark)
        .navigationBarBackButtonHidden(true)
        
        .alert(
            Constants.Strings.alertTitle,
            isPresented: .constant(viewModel.state.alertType != nil),
            presenting: viewModel.state.alertType
        ) { alertType in
            switch alertType {
            case .skipConfirmation:
                Button(Constants.Strings.skipAnyway, role: .destructive) {
                    viewModel.skipOnboardingConfirmed()
                    viewModel.completeOnboarding() 
                }
                Button(Constants.Strings.goBack, role: .cancel) {
                    viewModel.dismissAlert()
                }
            }
        } message: { _ in
            Text(Constants.Strings.alertMessage)
        }
    }
}
