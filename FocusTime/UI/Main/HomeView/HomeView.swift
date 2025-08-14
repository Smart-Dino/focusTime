//
//  HomeView.swift
//  FocusTime
//
//  Created by Maksym Horobets on 13.06.2025.
//

import SwiftUI
import FocusTimeUI
import DeviceActivity

struct HomeView: View {
    @State var viewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            // MARK: - Nav title and an image below it.
            VStack {
                VStack(alignment: .leading) {
                    Text(Constants.Strings.navigationTitle)
                        .font(Constants.Fonts.navigationTitle)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                Image(Constants.Icons.waveImage)
                    .resizable()
                    .scaledToFit()
                
                Spacer()
            }
            
            // MARK: - Main content on this view.
            VStack(spacing: 20) {
                Spacer()
                
                // Timer
                VStack {
#if targetEnvironment(simulator)
                    Text(SharedConstants.Strings.simulatorUnavailability)
#else
                    DeviceActivityReport(
                        Constants.ActivityConfiguration.context,
                        filter: Constants.ActivityConfiguration.filter
                    )
                    .frame(height: Constants.Layout.activityReportSceneHeight)
#endif
                    Text(Constants.Strings.timerSubtitle)
                        .font(.callout)
                        .foregroundStyle(.ftGray3Light)
                }
                VStack(spacing: .zero) {
                    // MARK: - Scheduled focus button
                    Button {
                        viewModel.showScheduledFocusView()
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(Constants.Strings.scheduledFocusTitle)
                                    .font(.title3)
                                    .bold()
                                Text(Constants.Strings.scheduledFocusSubtitle)
                                    .font(.subheadline)
                                    .foregroundStyle(.ftGray3Light)
                            }
                            Spacer()
                            Image(systemName: Constants.Icons.chevronRight)
                        }
                        .foregroundStyle(.ftMainBlue)
                        .contentShape(.rect)
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal)
                    // MARK: - Schedule
                    if let item = viewModel.state.upcomingOrRunningItem {
                        makeSessionViewForItem(item)
                    }
                    
                }
                .frame(minHeight: 130) // Used so that the screen time value stays in the same place
            }
        }
        .background { MainBackgroundGradientView() }
        .dynamicTypeSize(...DynamicTypeSize.accessibility2)
        // MARK: - Bottom floating button
        .safeAreaInset(edge: .bottom) {
            Button(Constants.Strings.bottomButtonTitle, systemImage: Constants.Icons.hourglass) {
#warning("Action is empty")
            }
            .buttonStyle(.ftPrimary)
            .padding()
            .background {
                Rectangle()
                    .fill(.ftBackground)
                    .ignoresSafeArea(edges: .bottom)
            }
        }
        .navigationDestination(isPresented: .init(
            get: { viewModel.state.nextNavigationScreen != nil },
            set: { viewModel.setNextNavigationScreen($0) }
        )) {
            switch viewModel.state.nextNavigationScreen {
            case .scheduledFocusList(let viewModel):
                ScheduledBlockItemsView(viewModel: viewModel)
            case .none: Text("No view")
            }
        }
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
        .onAppear {
            viewModel.setUpcomingItem()
            viewModel.subscribeToDB()
            viewModel.injectDelegateToTimer()
        }
    }
    
    func makeSessionViewForItem(_ item: ProtectedBlockItem) -> some View {
        let isActive = item.isActive
        
        let description = isActive
        ? viewModel.timer.payload.formatted
        : item.type.description
        
        let isPausedBinding: Binding<Bool> = isActive
        ? Binding(
            get: { viewModel.timer.isPaused },
            set: { viewModel.setTimerIsPaused($0) }
        )
        : .constant(true)
        
        return FTHomeSessionCardView(
            title: item.name,
            description: description,
            isActive: item.isActive,
            isPaused: isPausedBinding
        )
        .padding(.horizontal)
        .padding(.vertical, 5)
        .onAppear {
            viewModel.startTimer(for: item)
        }
    }
}

#Preview {
    NavigationStack {
        let manager = PreviewData.mockBlockItemPersistenceManager
        let registrar = PreviewData.mockActivityRegistrar
        HomeView(
            viewModel: .init(
                timer: ConcurrencyTimer(),
                deviceActivityRegistrar: registrar,
                blockItemPersistenceManager: manager,
                delegate: nil
            )
        )
    }
}
