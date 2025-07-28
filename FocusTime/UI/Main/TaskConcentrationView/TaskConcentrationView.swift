//
//  TaskConcentrationView.swift
//  FocusTime
//
//  Created by Maksym Horobets on 28.07.2025.
//

import SwiftUI
import FocusTimeUI

struct TaskConcentrationView: View {
    @State var viewModel: TaskConcentrationViewModel
    
    var body: some View {
        ZStack {
            // Background gradient.
            MainBackgroundGradientView()
            
            // Background image.
            VStack {
                Spacer()
                Image(ImageResource.MainImages.taskConcentrationBackground)
                    .resizable()
                    .scaledToFit()
            }
            .ignoresSafeArea()
            
            // Content.
            VStack {
                // Subtitle.
                Text("Concentrate on your task")
                    .foregroundStyle(.ftGray3Light)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Timer.
                FTFlipClockView(
                    configuration: .init(),
                    viewModel: viewModel.timerModel
                )
                .padding([.top, .horizontal])
                Text("Focus time")
                    .foregroundStyle(.ftGray3Light)
                Spacer()
                
                // Buttons.
                Button(
                    viewModel.state.timerIsPaused ? "Resume" : "Pause",
                    systemImage: viewModel.state.timerIsPaused ? "play.fill" : "pause"
                ){
                    viewModel.toggleSession()
                }
                .buttonStyle(.ftPrimary)
                Button("End session"){
                    viewModel.endSession()
                    #warning("Dismiss view")
                }
                .padding(.vertical)
                
            }
            .padding(.horizontal)
        }
        .navigationTitle("Focus Session")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    let timerModel = FocusSessionTimerModel(
        state: .init(isPaused: true),
        deadline: .now.addingTimeInterval(70)
    )
    let viewModel = TaskConcentrationViewModel(timerModel: timerModel)
    NavigationStack {
        TaskConcentrationView(viewModel: viewModel)
            .preferredColorScheme(.dark)
    }
}
