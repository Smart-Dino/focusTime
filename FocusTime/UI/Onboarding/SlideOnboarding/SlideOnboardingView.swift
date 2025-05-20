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
                /// Main title for the onboarding flow
                Text("RIDE THE WAVES OF PRODUCTIVITY")
                    .font(.title3.bold())
                    .multilineTextAlignment(.center)
                
                /// Placeholder for progress bar UI from package
                Text("PLACEHOLDER FOR PROGRESS BAR")
                    .foregroundColor(.cyan)
                    .background(Color.red)
            }
            
            // MARK: - Image Section
            /// Displays current step's image, fills the frame and clips overflow
            // TODO: - Update image with actual image
            Image(viewModel.currentStep.imageName)
                .resizable()
                .scaledToFill()
                .containerRelativeFrame(.vertical, { amount, axis in
                    amount / 1.8
                })
                .clipped()
                .padding(.top, 20)
            
            // MARK: - Subtitle Section
            VStack {
                /// First subtitle line, emphasised with headline font
                Text(viewModel.currentStep.subtitle1)
                    .font(.headline)
                /// Second subtitle line, lighter with subHeadline font
                Text(viewModel.currentStep.subtitle2)
                    .font(.subheadline)
            }
            .frame(height: 152)
            .multilineTextAlignment(.center)
            
            
            // MARK: - Buttons
            /// Shows 'Next' and 'Skip' buttons for first 3 steps
            if !viewModel.currentStep.isLast {
                VStack(spacing: 16) {
                    Button("Next") { 
                        viewModel.goToNextStep()
                    }
                    .buttonStyle(FTPrimaryButtonStyle())
                    
                    Button("Skip") {
                        viewModel.showSkipConfirmation = true
                    }
                }
                .frame(height: 78)
                
            } else {
                /// Shows 'Start Focusing' button on the last step
                Button("Start Focusing") {
                    // TODO: - Navigate to main app flow
                }
                .frame(height: 78)
                .buttonStyle(FTPrimaryButtonStyle())
            }
        }
        .animation(.easeInOut, value: viewModel.currentStep)
        .preferredColorScheme(.dark)
        
        // MARK: - Skip Confirmation Alert
        .alert("Do you really want to skip onboarding?", isPresented: $viewModel.showSkipConfirmation) {
            Button("Skip", role: .destructive) {
                viewModel.skipOnboarding()
            }
            Button("No", role: .cancel) {}
        }
    } 
}


#Preview {
    SlideOnboardingView()
}
