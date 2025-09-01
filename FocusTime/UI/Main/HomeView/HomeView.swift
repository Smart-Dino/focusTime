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
        .background { FTBackgroundGradientView() }
        .dynamicTypeSize(...DynamicTypeSize.accessibility2)
        // MARK: - Bottom floating button
        .safeAreaInset(edge: .bottom) {
            let item = viewModel.state.upcomingOrRunningItem
            
            if item == nil || !(item?.state.isActive ?? true) {
                Button(Constants.Strings.bottomButtonTitle, systemImage: Constants.Icons.hourglass) {
                    viewModel.showFocusSessionSetupView()
                }
                .buttonStyle(.ftPrimary)
                .padding()
                .background {
                    Rectangle()
                        .fill(.ftBackground)
                        .ignoresSafeArea(edges: .bottom)
                }
            }
        }
        .navigationDestination(isPresented: .init(
            get: { viewModel.state.nextNavigationScreen != nil },
            set: { viewModel.setNextNavigationScreen($0) }
        )) {
            switch viewModel.state.nextNavigationScreen {
            case .scheduledFocusList(let viewModel):
                ScheduledBlockItemsView(viewModel: viewModel)
            case .taskConcentration(let viewModel):
                TaskConcentrationView(viewModel: viewModel)
            case .focusSession(let viewModel):
                FocusSessionView(viewModel: viewModel)
            case .none: Text("No view")
            }
        }
        .alert(
            SharedConstants.Strings.errorHeader,
            isPresented: Binding(
                get: { viewModel.state.error != nil },
                set: { viewModel.setErrorVisibility($0) }
            ),
            actions: { /* OK dismissal button by default */ },
            message: { Text(viewModel.state.error?.localizedDescription ?? String()) }
        )
        .onAppear {
            viewModel.checkAuthorization()
            viewModel.setUpcomingItem()
            viewModel.subscribeToDB()
        }
    }
    
    func makeSessionViewForItem(_ item: ProtectedBlockItem) -> some View {
        let isActive = item.state.isActive
        
        return Group {
            if isActive {
                FTActiveHomeSessionCardView(
                    title: item.name,
                    timerPayload: viewModel.state.timerPayload,
                    isPaused: viewModel.state.isPaused,
                    action: { viewModel.showTaskConcentrationView(isPauseAction: false) },
                    pauseAction: { viewModel.showTaskConcentrationView(isPauseAction: true) }
                )
            } else {
                FTHomeSessionCardView(
                    title: item.name,
                    description: item.type.description
                )
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
        .id(viewModel.state.upcomingOrRunningItem?.id) // Force refresh on blockItem.id change.
    }
}

#Preview {
    let manager = PreviewData.mockBlockItemPersistenceManager
    let registrar = PreviewData.mockActivityRegistrar
    let proState = MockPaymentManagerWithPurchaseError().state
    
    NavigationStack {
        HomeView(
            viewModel: .init(
                state: .init(timer: ConcurrencyTimer()),
                proState: proState,
                paywallPresenter: LivePaywallPresenter(),
                deviceActivityRegistrar: registrar,
                blockItemPersistenceManager: manager
            )
        )
    }
    .preferredColorScheme(.dark)
}
