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
    
    private let progressItems = SlideOnboardingStep.allCases
    
    // MARK: - Body
    var body: some View {
        VStack {
            // MARK: - Header Section
            VStack {
                Text("RIDE THE WAVES OF PRODUCTIVITY")
                    .font(.title3.bold())
                    .multilineTextAlignment(.center)
                 
                FTProgressBarView(
                    items: progressItems,
                    selectedItem: Binding(
                        get: { progressItems[viewModel.currentIndex] },
                        set: { _ in } ))
            }
            
            // MARK: - Image Section
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
                Text(viewModel.currentStep.subtitle1)
                    .font(.headline)
                Text(viewModel.currentStep.subtitle2)
                    .font(.subheadline)
            }
            .frame(height: 152)
            .multilineTextAlignment(.center)
            
            
            // MARK: - Buttons
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
        .alert("Before you go...", isPresented: $viewModel.showSkipConfirmation) {
            Button("Skip anyway", role: .destructive) {
                viewModel.skipOnboarding()
            }
            Button("Go back", role: .cancel) {}
        } message: {
            Text("Are you sure you want to skip the onboarding?")
        }
    }
}


#Preview {
    SlideOnboardingView()
}
