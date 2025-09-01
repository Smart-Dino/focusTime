//
//  MainFlowCoordinatorView.swift
//  FocusTime
//
//  Created by Maksym Horobets on 13.06.2025.
//

import SwiftUI
import FocusTimeUI

struct MainFlowCoordinatorView: View {
    @State var viewModel: MainFlowCoordinatorViewModel
    
    var body: some View {
        NavigationStack {
            TabView(selection: .binding(
                get: viewModel.state.currentTabScreen,
                set: viewModel.setTabScreen(_:))
            ) {
                Group {
                    ForEach(viewModel.state.tabViewModels) { screen in
                        makeViewForTab(screen)
                    }
                }
                // .toolbarBackground(Color.ftBackground, for: .tabBar) // Set a specific color
                // as a background, but we don't do it because the tabbar is transparent
                // in a non-scrolling content so we underlay our own behind it.
                .toolbarBackground(.hidden, for: .tabBar) // Removes background and sets
                // selected item to be white-tinted.
                .toolbarColorScheme(.dark, for: .tabBar)
            }
            .toolbar(.visible)
            .toolbar {
                if case .home = viewModel.state.currentTabScreen, !viewModel.state.proState.status.isPro {
                    ToolbarItem {
                        FTProUpgradeButtonView {
                            viewModel.requestPaywall()
                        }
                    }
                }
                // In future SDKs of iOS we would have to put a spacer here.
                ToolbarItemGroup {
                    switch viewModel.state.currentTabScreen {
                    case .home:
                        FTPlusToolbarButtonView {
                            viewModel.showNewBlockListView()
                        }
                    case .drafts: EmptyView()
                    case .none: EmptyView()
                    }
                }
            }
            .navigationDestination(isPresented: .init(
                get: { viewModel.state.nextNavigationScreen != nil },
                set: { viewModel.setNextNavigationScreen($0) }
            )) {
                switch viewModel.state.nextNavigationScreen {
                case .focusSession(let viewModel):
                    FocusSessionView(viewModel: viewModel)
                case .none:
                    Text("No view")
                }
            }
        }
        .dynamicTypeSize(...DynamicTypeSize.accessibility2)
    }
    
    @ViewBuilder
    func makeViewForTab(_ screen: MainFlowCoordinatorViewModel.State.MainTabScreens) -> some View {
        switch screen {
        case .home(let homeViewModel):
            HomeView(viewModel: homeViewModel)
                .tabItem {
                    LabeledContent(Constants.Strings.homeTabTitle) {
                        Image(.wavelogo)
                            .renderingMode(.template)
                    }
                }
                .tag(screen)
        case .drafts(let draftsViewModel):
            DraftsBlockItemListView(viewModel: draftsViewModel)
                .tabItem {
                    Label(Constants.Strings.blocksTabTitle, systemImage: "hand.raised")
                    // Prevent system from filling system icons.
                        .environment(\.symbolVariants, .none)
                }
                .tag(screen)
        case .none:
            Text(Constants.Strings.noView)
        }
    }
}

#Preview {
    MainFlowCoordinatorView(
        viewModel: .init(
            state: .init(currentTabScreen: .none, proState: PreviewData.mockProState),
            proState: PreviewData.mockProState,
            deviceActivityRegistrar: PreviewData.mockPopulatedActivityRegistrar,
            blockItemPersistenceManager: PreviewData.mockPopulatedPersistenceManager,
            paywallPresenter: PreviewData.mockPaywallPresenter
        )
    )
    .preferredColorScheme(.dark)
}
