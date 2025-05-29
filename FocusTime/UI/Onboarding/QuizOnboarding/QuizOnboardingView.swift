//
//  QuizOnboardingView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 14.05.25.
//


import SwiftUI
import FocusTimeUI

// MARK: - QuizOnboardingView

struct QuizOnboardingView: View {
    // MARK: - Properties
    @State private var viewModel = QuizOnboardingViewModel()
    
    // MARK: - Body
    var body: some View {
        
        // MARK: - Header Section
        VStack{
            VStack(alignment: .leading){
                
                /// Title and subtitle
                VStack(alignment: .center, spacing: Constants.Layout.titleSpacing) {
                    Text(Constants.Strings.title)
                        .font(.title3.bold())
                        .multilineTextAlignment(.center)
                    
                    Text(Constants.Strings.subtitle)
                        .font(.body)
                        .multilineTextAlignment(.center)
                }
                .foregroundColor(.white)
                .padding(.bottom, Constants.Layout.bottomPadding)
                
                // MARK: - Scrollable Quiz Section
                ScrollView {
                    VStack(alignment: .leading, spacing: Constants.Layout.quizSpacing) {
                        ForEach(Constants.QuizOption.allCases) { option in
                            Toggle(option.rawValue, isOn: Binding(
                                get: { viewModel.isOptionSelected(option) },
                                set: { _ in viewModel.toggleSelection(for: option) }
                            ))
                            .toggleStyle(FTCheckboxToggleStyle(color: .blue))
                            .font(.body)
                        }
                    }
                }
                .scrollBounceBehavior(.basedOnSize, axes: [.vertical])
            }
            
            // MARK: - "Next" Button
            /// Button to proceed after selecting options
            Button(Constants.Strings.nextButton) {
                // TODO: - Add navigation action
            }
            .buttonStyle(FTPrimaryButtonStyle())
            .padding()
        }
        .dynamicTypeSize(...DynamicTypeSize.large)
        .preferredColorScheme(.dark)
    }
}


#Preview {
    QuizOnboardingView()
}
