//
//  QuizOnboardingView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 14.05.25.
//


import SwiftUI
import FocusTimeUI

struct QuizOnboardingView: View {

    @State private var viewModel: QuizOnboardingViewModel
    
    init(viewModel: QuizOnboardingViewModel) {
            _viewModel = State(initialValue: viewModel)
        }


    var body: some View {
        VStack {
            VStack(alignment: .leading) {
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
            .padding(.horizontal)
            
            Button(Constants.Strings.nextButton) {
                viewModel.nextButtonTapped()
            }
            .buttonStyle(FTPrimaryButtonStyle())
            .padding()
        }
        .dynamicTypeSize(...DynamicTypeSize.large)
        .preferredColorScheme(.dark)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        QuizOnboardingView(
            viewModel: QuizOnboardingViewModel(
                analyticsManager: AppAnalytics.shared,
                onNext: { print("Preview: Next button tapped") }
            )
        )
    }
}
