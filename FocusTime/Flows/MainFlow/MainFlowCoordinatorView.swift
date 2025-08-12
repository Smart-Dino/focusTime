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
            TabView(selection: Binding(get: {
                viewModel.state.currentTabScreen
            }, set: { screen in
                viewModel.setTabScreen(screen)
            })) {
                Group {
                    HomeView(viewModel: viewModel.homeViewModel)
                        .tabItem {
                            LabeledContent("Home") {
                                Image(.wavelogo)
                                    .renderingMode(.template)
                            }
                        }
                        .tag(MainTabScreens.home)
                    DraftsBlockItemListView(viewModel: viewModel.draftsBlockItemListViewModel)
                        .tabItem {
                            Label("Blocks", systemImage: "hand.raised")
                            // Prevent system from filling system icons.
                                .environment(\.symbolVariants, .none)
                        }
                        .tag(MainTabScreens.blocks)
                }
                //                .toolbarBackground(Color.ftBackground, for: .tabBar) // Set a specific color
                // as a background, but we don't do it because the tabbar is transparent
                // in a non-scrolling content so we underlay our own behind it.
                .toolbarBackground(.hidden, for: .tabBar) // Removes background and sets
                // selected item to be white-tinted.
                .toolbarColorScheme(.dark, for: .tabBar)
            }
            .onAppear {
                viewModel.setupFlow()
            }
            .toolbar(.visible)
            .toolbar {
                if viewModel.state.currentTabScreen == .home {
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
#warning("Action is empty")
                        }
                    case .blocks: EmptyView()
                    case .profile: EmptyView()
                    }
                }
            }
            .navigationDestination(isPresented: .init(
                get: { viewModel.state.nextNavigationScreen != nil },
                set: { viewModel.setNextNavigationScreen($0) }
            )) {
                switch viewModel.state.nextNavigationScreen {
                case .shieldDebug(let viewModel):
                    ShieldDebugView(viewModel: viewModel)
                case .none:
                    Text("No view")
                }
            }
        }
        .dynamicTypeSize(...DynamicTypeSize.accessibility2)
    }
}

#Preview {
    let factory = MockPersistenceStoreFactory()
    let manager = LiveBlockItemPersistenceManager(blockItemStore: PreviewData.memoryOnlyBlockItemStore)
    
    MainFlowCoordinatorView(
        viewModel: .init(blockItemPersistenceManager: manager, appFlowDelegate: nil)
    )
}
