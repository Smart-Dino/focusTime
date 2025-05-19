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
                VStack(alignment: .center, spacing: 11){
                    Text("What challenges your focus most often?")
                        .font(.title3.bold())
                        .multilineTextAlignment(.center)
                    
                    Text("Add one or more options that work for you.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                    
                }
                .foregroundColor(Color.white)
                .padding(.bottom, 40)
                
                // MARK: - Scrollable Quiz Section
                /// Scrollable in case more options are added later
                ScrollView {
                    VStack(alignment: .leading, spacing: 42) {
                        ForEach($viewModel.state.options) { $option in
                            Toggle(option.title, isOn: $option.isSelected)
                                .toggleStyle(FTCheckboxToggleStyle(color: .blue))
                                .font(.body)
                                .foregroundColor(.white)
                        }
                    }
                }
                .scrollBounceBehavior(.basedOnSize, axes: [.vertical])
            }
            
            // MARK: - "Next" Button
            /// Button to proceed after selecting options
            Button("Next") {
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
