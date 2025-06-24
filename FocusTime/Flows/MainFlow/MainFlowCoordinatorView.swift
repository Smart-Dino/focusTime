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
        NavigationStack(path: Binding(get: {
            viewModel.flowState.currentPath
        }, set: { screens in
            viewModel.setScreens(screens)
        })) {
            TabView(selection: Binding(get: {
                viewModel.flowState.currentTabScreen
            }, set: { screen in
                viewModel.setTabScreen(screen)
            })) {
                Group {
                    HomeView(viewModel: viewModel.makeHomeViewModel())
                        .tabItem {
                            LabeledContent("Home") {
                                Image(.wavelogo)
                                    .renderingMode(.template)
                            }
                        }
                        .tag(MainTabScreens.home)
                    AppBlockingListView(viewModel: viewModel.makeAppBlockListViewModel())
                        .tabItem {
                            Label("Blocks", systemImage: "hand.raised")
                            // Prevent system from filling system icons.
                                .environment(\.symbolVariants, .none)

                        }
                        .tag(MainTabScreens.blocks)
                    Text("Empty for now")
                        .tabItem {
                            Label("Profile", systemImage: "person")
                            // Prevent system from filling system icons.
                                .environment(\.symbolVariants, .none)
                        }
                        .tag(MainTabScreens.profile)
                }
//                .toolbarBackground(Color.ftBackground, for: .tabBar) // Set a specific color
                // as a background, but we don't do it because the tabbar is transparent
                // in a non-scrolling content so we underlay our own behind it.
                .toolbarBackground(.hidden, for: .tabBar) // Removes background and sets
                // selected item to be white-tinted.
                .toolbarColorScheme(.dark, for: .tabBar)
            }
            .toolbar(.visible)
            .toolbar {
                if viewModel.flowState.currentTabScreen == .home {
                    ToolbarItem {
                        FTProUpgradeButtonView {
                            #warning("Action is empty")
                        }
                    }
                }
                // In future SDKs of iOS we would have to put a spacer here.
                ToolbarItemGroup {
                    switch viewModel.flowState.currentTabScreen {
                    case .home:
                        FTPlusToolbarButtonView {
                            #warning("Action is empty")
                        }
                    case .blocks: EmptyView()
                    case .profile: EmptyView()
                    }
                }
            }
            // Navigation has to be managed here
            // since declaring navDest in the views nested in the tabbar
            // makes them load lazily which will cause navigation bugs.
            .navigationDestination(for: MainScreens.self) { screen in
                switch screen {
                case .scheduledFocusList(let scheduledFocusViewModel):
                    ScheduledFocusListView(viewModel: scheduledFocusViewModel)
                }
            }
        }
        .preferredColorScheme(.dark)
        .dynamicTypeSize(...DynamicTypeSize.accessibility2)
    }
}

#Preview {
    let viewModel = MainFlowCoordinatorViewModel()
    MainFlowCoordinatorView(viewModel: viewModel)
}
