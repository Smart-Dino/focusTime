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
                                viewModel.toggleTimerIsPaused()
                            }
                        }, endSessionAction: {
                            // No action for now.
                        }
                    )
                case .breakTransition(let title, let subtitle):
                    CongratulatoryTransitionView(
                        title: title,
                        subtitle: subtitle,
                        onFinished: {
                            viewModel.moveTo(.breakTime)
                        }
                    )
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
                                viewModel.startTimerPauseTimer()
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
                    
                case .finished(let title, let subtitle):
                    CongratulatoryTransitionView(
                        title: title,
                        subtitle: subtitle,
                        onFinished: {
                            // Dismiss view.
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
            message: { Text(viewModel.state.error?.localizedDescription ?? "") }
        )
    }
}

#Preview {
    @Previewable @State var timer = ConcurrencyTimer()
    let viewModel = TaskConcentrationViewModel(
        state: .init(item: ProtectedBlockItem.mock),
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

