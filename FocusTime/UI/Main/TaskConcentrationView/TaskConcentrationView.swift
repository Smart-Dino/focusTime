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
            // Background image.
            VStack {
                Spacer()
                Image(Constants.Icons.background)
                    .resizable()
                    .scaledToFit()
            }
            .ignoresSafeArea()
            
            // Content.
            VStack {
                // Subtitle.
                Text(Constants.Strings.subtitle)
                    .foregroundStyle(.ftGray3Light)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Timer.
                FTFlipClockView(
                    configuration: .init(),
                    timer: viewModel.timer
                )
                .padding([.top, .horizontal])
                Text(Constants.Strings.timerTitle)
                    .foregroundStyle(.ftGray3Light)
                Spacer()
                
                // Buttons.
                Button(
                    viewModel.state.timerControlButtonTitle,
                    systemImage: viewModel.state.timerControlButtonIcon
                ){
                    viewModel.setTimerIsPaused(!viewModel.state.timerIsPaused)
                }
                .buttonStyle(.ftPrimary)
                Button(Constants.Strings.endSessionButtonTitle){
                    viewModel.endSession()
                    #warning("Dismiss view")
                }
                .padding(.vertical)
                
            }
            .padding(.horizontal)
        }
        .background { MainBackgroundGradientView() }
        .onAppear(perform: viewModel.updateUIBasedOnTimerState)
        .navigationTitle(Constants.Strings.navigationTitle)
        .navigationBarTitleDisplayMode(.large)
        .alert(
            SharedConstants.Strings.errorHeader,
            isPresented: Binding(get: {
                viewModel.state.error != nil
            }, set: { isVisible in
                viewModel.setErrorVisibility(isVisible)
            }), actions: {
                // OK dismissal button by default
            }, message: {
                Text(viewModel.state.error?.localizedDescription ?? "")
            }
        )
    }
}

#Preview {
    @Previewable @State var timer = ConcurrencyTimer()
    let viewModel = TaskConcentrationViewModel(
        state: .init(item: ProtectedBlockItem.mock),
        timer: timer,
        deviceActivityRegistrar: PreviewData.mockActivityRegistrar
    )
    NavigationStack {
        TaskConcentrationView(viewModel: viewModel)
            .preferredColorScheme(.dark)
            .onAppear {
                timer.start(
                    deadline: .now.addingTimeInterval(70),
                    isInitiallyPaused: false
                )
            }
    }
}

