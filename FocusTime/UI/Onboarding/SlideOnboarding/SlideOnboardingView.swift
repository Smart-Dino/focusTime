//
//  SlideOnboardingView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 19.05.25.
//

import SwiftUI
import FocusTimeUI

struct SlideOnboardingView: View {

    @State private var viewModel: SlideOnboardingViewModel

    init(viewModel: SlideOnboardingViewModel) {
        _viewModel = State(initialValue: viewModel)
        print("SlideOnboardingView initialized.")
    }


    var body: some View {
        VStack {
            VStack {
                Text(Constants.Strings.title)
                    .font(.title3.bold())
                    .multilineTextAlignment(.center)
                 
                FTProgressBarView(
                    items: SlideOnboardingStep.allCases,
                    selectedItem: .constant(viewModel.currentStep)
                )
                .padding(.top, Constants.Layout.progressBarTopPadding)
            }
            
            Image(viewModel.currentStep.imageName)
                .resizable()
                .scaledToFill()
                .containerRelativeFrame(.vertical, { amount, axis in amount / 1.8 })
                .clipped()
                .padding(.top, Constants.Layout.topPadding)
                .transition(.opacity)
                .animation(.easeInOut, value: viewModel.currentStep.imageName)

            VStack {
                Text(viewModel.currentStep.subtitle1)
                    .font(.headline)
                    
                Text(viewModel.currentStep.subtitle2)
                    .font(.subheadline)
                    
            }
            .frame(height: Constants.Layout.subtitleSectionHeight)
            .multilineTextAlignment(.center)
            

            
                VStack{
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
        .animation(.easeInOut, value: viewModel.currentStep)
        .preferredColorScheme(.dark)
        .navigationBarBackButtonHidden(true)
        
        .alert(Constants.Strings.alertTitle, isPresented: $viewModel.state.showSkipConfirmation) {
            Button(Constants.Strings.skipAnyway, role: .destructive) {
                viewModel.skipOnboardingConfirmed()
                viewModel.completeOnboarding()
            }
            Button(Constants.Strings.goBack, role: .cancel) {}
        } message: {
            Text(Constants.Strings.alertMessage)
        }
    }
}
