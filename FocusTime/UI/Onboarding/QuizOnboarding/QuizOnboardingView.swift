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
    @State var viewModel: QuizOnboardingViewModel
    
    // MARK: - Body
    var body: some View {
        // MARK: - Header Section
        VStack {
            VStack {
                
                /// Title and subtitle
                VStack(alignment: .center, spacing: Constants.Layout.titleSpacing) {
                    Text(Constants.Strings.title)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    
                    Text(Constants.Strings.subtitle)
                        .font(.caption)
                        .foregroundStyle(.ftGray3Light )
                        .multilineTextAlignment(.center)
                }
                .foregroundColor(.white)
                .padding(.bottom)
                
                // MARK: - Scrollable Quiz Section
                ScrollView {
                    VStack(
                        alignment: .leading,
                        spacing: Constants.Layout.quizSpacing
                    ) {
                        ForEach(Constants.QuizOption.allCases) { option in
                            Toggle(option.localizedString, isOn: Binding(
                                get: { viewModel.state.isOptionSelected(option) },
                                set: { _ in viewModel.toggleSelection(for: option) }
                            ))
                            .toggleStyle(FTCheckboxToggleStyle(color: .blue))
                            .font(.body)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .scrollBounceBehavior(.basedOnSize, axes: [.vertical])
            }
            
            // MARK: - "Next" Button
            /// Button to proceed after selecting options
            Button(Constants.Strings.nextButton) {
                viewModel.finishQuiz()
            }
            .buttonStyle(FTPrimaryButtonStyle())
            .padding()
        }
        .dynamicTypeSize(...DynamicTypeSize.large)
        .background {
            Image(Constants.Images.backgroundImage)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .opacity(Constants.Images.backgroundImageOpacity)
        }
    }
}


#Preview {
    QuizOnboardingView(viewModel: .init(delegate: nil))
        .preferredColorScheme(.dark)
}
