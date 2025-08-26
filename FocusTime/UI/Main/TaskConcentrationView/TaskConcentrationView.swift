//
//  TaskConcentrationView.swift
//  FocusTime
//
//  Created by Maksym Horobets on 28.07.2025.
//

import Lottie
import SwiftUI
import FocusTimeUI

struct TaskConcentrationView: View {
    @Environment(\.dismiss) var dismiss
    @State var viewModel: TaskConcentrationViewModel
    
    var body: some View {
        VStack {
            Group {
                switch viewModel.state.phase {
                case .focus(let title, let subtitle, let timerTitle, let runningTitle, let runningIcon):
                    StandardPhaseView(
                        title: title,
                        subtitle: subtitle,
                        backgroundImage: ImageResource.MainImages.TaskConcentrationImages.taskConcentrationFocus,
                        centerView: {
                            VStack {
                                FTFlipClockView(
                                    configuration: .init(),
                                    timer: viewModel.getTimer()
                                )
                                    .padding([.top, .horizontal])
                                Text(timerTitle)
                                    .foregroundStyle(.ftGray3Light)
                            }
                        },
                        primaryButton: {
                            Button(runningTitle, systemImage: runningIcon) {
                                viewModel.moveToPauseSessionScene()
                            }
                        }, endSessionAction: {
                            viewModel.moveToEndSessionAlertScene()
                        }
                    )
                case .breakTransition(let title, let subtitle):
                    CongratulatoryTransitionView(
                        title: title,
                        subtitle: subtitle,
                        onFinished: {
                            viewModel.moveToBreakTime()
                        }
                    )
                    .onAppear {
                        viewModel.replaceTimerWithSuspensionTimer()
                    }
                case .breakTime(let title, let subtitle, let timerTitle, let buttonTitle):
                    StandardPhaseView(
                        title: title,
                        subtitle: subtitle,
                        backgroundImage: ImageResource.MainImages.TaskConcentrationImages.taskConcentrationPause,
                        centerView: {
                            VStack {
                                FTFlipClockView(
                                    configuration: .init(),
                                    timer: viewModel.getTimer()
                                )
                                    .padding([.top, .horizontal])
                                Text(timerTitle)
                                    .foregroundStyle(.ftGray3Light)
                            }
                        },
                        primaryButton: {
                            Button(buttonTitle) {
                                viewModel.startBreakTimer()
                            }
                            .opacity(viewModel.state.item.state == .running ? 1 : 0)
                            .animation(.easeInOut, value: viewModel.state.item.state)
                        }, endSessionAction: {
                            viewModel.moveToEndSessionAlertScene()
                        }
                    )
                case .almostDone(let title, let subtitle, let message, let buttonTitle):
                    StandardPhaseView(
                        title: title,
                        backgroundImage: ImageResource.MainImages.TaskConcentrationImages.taskConcentrationAlert,
                        centerView: {
                            // Animation.
                            LottieView(animation: Constants.Animations.warningAnimation)
                            .playbackMode(
                                .playing(
                                    .fromProgress(0,
                                                  toProgress: 1,
                                                  loopMode: .loop)
                                )
                            )
                            .resizable()
                            .containerRelativeFrame(.horizontal) { size, _ in
                                size / 2
                            }
                            
                            VStack {
                                Text(subtitle)
                                    .font(.title3)
                                Text(message)
                                    .foregroundStyle(.ftGray3Light)
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                        },
                        primaryButton: {
                            Button(buttonTitle) {
                                viewModel.moveToPauseSessionScene()
                            }
                        }, endSessionAction: {
                            Task {
                                try await viewModel.endBlock()
                                dismiss.callAsFunction()
                            }
                        }
                    )
                    
                case .finished(let title, let subtitle):
                    CongratulatoryTransitionView(
                        title: title,
                        subtitle: subtitle,
                        onFinished: {
                            dismiss.callAsFunction()
                        }
                    )
                }
            }
        }
        .containerRelativeFrame([.horizontal, .vertical])
        .background(MainBackgroundGradientView())
        .alert(
            SharedConstants.Strings.errorHeader,
            isPresented: Binding(
                get: { viewModel.state.error != nil },
                set: { viewModel.setErrorVisibility($0) }
            ),
            actions: { /* OK dismissal button by default */ },
            message: { Text(viewModel.state.error?.localizedDescription ?? String()) }
        )
    }
}

#Preview {
    @Previewable @State var timer = ConcurrencyTimer()
    let viewModel = TaskConcentrationViewModel(
        state: .init(item: ProtectedBlockItem.mock, phase: .focus),
        timer: timer,
        deviceActivityRegistrar: PreviewData.mockActivityRegistrar,
        blockItemPersistenceManager: PreviewData.mockBlockItemPersistenceManager
    )
    NavigationStack {
        TaskConcentrationView(viewModel: viewModel)
            .preferredColorScheme(.dark)
            .onAppear {
                timer.start(
                    deadline: .now.addingTimeInterval(5),
                    isInitiallyPaused: false
                )
            }
    }
}

