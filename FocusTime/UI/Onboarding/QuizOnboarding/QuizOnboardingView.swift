//
//  QuizOnboardingView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 14.05.25.
//


import SwiftUI

// MARK: - QuizOnboardingView

struct QuizOnboardingView: View {
    // MARK: - Properties
    @StateObject private var viewModel = QuizOnboardingViewModel()
    
    // MARK: - Body
    var body: some View {
        ZStack{
            
            /// Temporary background colour for layout testing
            Color.gray
                .ignoresSafeArea()
            
            // MARK: - Header Section
            VStack{
                VStack(alignment: .leading){
                    
                    /// Title and subtitle
                    VStack(alignment: .center, spacing: 11){
                        Text("What challenges your focus most often?")
                            .font(.system(size: 17, weight: .bold, design: .default))
                        
                        Text("Add one or more options that work for you.")
                            .font(.system(size: 13, weight: .regular, design: .default))
                    }
                    .foregroundColor(Color.white)
                    .padding(.bottom, 40)
                    
                    // MARK: - Scrollable Quiz Section
                    /// Scrollable in case more options are added later
                    ScrollView{
                        VStack(alignment: .leading, spacing: 42){
                            ForEach(viewModel.options) { option in
                                HStack{
                                    
                                    /// Placeholder for checkbox before packages are available
                                    Text("[--]")
                                    
                                    /// Option title
                                    Text(option.title)
                                }
                                .font(.body)
                                .foregroundColor(Color.white)
                            }
                        }
                    }
                }
                
                // MARK: - Placeholder for "Next" Button
                /// Placeholder used before packages are available
                Button("PLACEHOLDER"){}
                    .foregroundColor(Color.pink)
                    .frame(width: 361, height: 34)
                    .background(Color.yellow)
                    .cornerRadius(40)
                    .padding()
            }
        }
    }
}


#Preview {
    QuizOnboardingView()
}
