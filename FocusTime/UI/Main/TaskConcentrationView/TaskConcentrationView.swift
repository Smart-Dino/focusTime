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
    @State var viewModel: TaskConcentrationViewModel
    
    var body: some View {
        VStack {
            Group {
                switch viewModel.state.phase {
                case .focus(let title, let subtitle, let timerTitle, let runningTitle, let pausedTitle, let runningIcon, let pausedIcon):
                    let isPaused = viewModel.state.timerIsPaused
                    
                    StandardPhaseView(
                        title: title,
                        subtitle: subtitle,
                        backgroundImage: ImageResource.MainImages.TaskConcentrationImages.taskConcentrationFocus,
                        centerView: {
                            VStack {
                                FTFlipClockView(configuration: .init(), timer: viewModel.timer)
                                    .padding([.top, .horizontal])
                                Text(timerTitle)
                                    .foregroundStyle(.ftGray3Light)
                            }
                        },
                        primaryButton: {
                            Button(
                                isPaused ? pausedTitle : runningTitle,
                                systemImage: isPaused ? pausedIcon : runningIcon
                            ) {
                                viewModel.setTimerIsPaused(!isPaused)
                            }
                        }, endSessionAction: {
                            // No action for now.
                        }
                    )
                case .breakTransition(let title, let subtitle):
                    makeBreakTransitionView(title: title, subtitle: subtitle)
                case .breakTime(let title, let subtitle, let timerTitle, let buttonTitle):
                    StandardPhaseView(
                        title: title,
                        subtitle: subtitle,
                        backgroundImage: ImageResource.MainImages.TaskConcentrationImages.taskConcentrationPause,
                        centerView: {
                            VStack {
                                FTFlipClockView(configuration: .init(), timer: viewModel.timer)
                                    .padding([.top, .horizontal])
                                Text(timerTitle)
                                    .foregroundStyle(.ftGray3Light)
                            }
                        },
                        primaryButton: {
                            Button(buttonTitle) {
#warning("No implementation")
                            }
                        }, endSessionAction: {
                            // No action for now.
                        }
                    )
                case .almostDone(let title, let subtitle, let message, let buttonTitle):
                    StandardPhaseView(
                        title: title,
                        backgroundImage: ImageResource.MainImages.TaskConcentrationImages.taskConcentrationFocus,
                        centerView: {
                            // Animation.
                            EmptyView()
                            
                            Text(subtitle)
                            Text(message)
                                .foregroundStyle(.ftGray3Light)
                        },
                        primaryButton: {
                            
                            Button(buttonTitle) {
#warning("No implementation")
                            }
                        }, endSessionAction: {
                            // No action for now.
                        }
                    )
                    
                case .finished(let title, let buttonTitle):
                    EmptyView()
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
            message: { Text(viewModel.state.error?.localizedDescription ?? "") }
        )
    }
    
    var lottieConfetti: some View {
        LottieView(
            animation: .filepath(
                Bundle.main.url(forResource: "Confetti", withExtension: "json")!.relativePath
            )
        )
        .playbackMode(
            .playing(
                .fromProgress(0,
                              toProgress: 1,
                              loopMode: .playOnce)
            )
        )
        .animationDidFinish { _ in
            viewModel.moveTo(.breakTime)
        }
        .containerRelativeFrame([.vertical]) { size, axes in
            size / 3
        }
    }
    
    // MARK: - Reusable View Builders
    private func makeBreakTransitionView(title: String, subtitle: String) -> some View {
        VStack {
            lottieConfetti
            Text(title)
                .font(.title3.bold())
            Text(subtitle)
                .foregroundStyle(.ftGray3Light)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
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
                    deadline: .now.addingTimeInterval(5),
                    isInitiallyPaused: false
                )
            }
    }
}

