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
                viewModel.flowState.currentScreen
            }, set: { screen in
                viewModel.setScreen(screen)
            })) {
                Group {
                    HomeView()
                        .tabItem {
                            LabeledContent("Home") {
                                Image(.wavelogo)
                                    .renderingMode(.template)
                            }
                        }
                        .tag(MainTabScreens.home)
                    Text("Empty for now")
                        .tabItem {
                            Label("Blocks", systemImage: "hand.raised")
                            // Prevent system from filling our icons.
                                .environment(\.symbolVariants, .none)

                        }
                        .tag(MainTabScreens.blocks)
                    Text("Empty for now")
                        .tabItem {
                            Label("Profile", systemImage: "person")
                            // Prevent system from filling our icons.
                                .environment(\.symbolVariants, .none)
                        }
                        .tag(MainTabScreens.profile)
                }
//                .toolbarBackground(Color.ftBackground, for: .tabBar) // Set a specific color
                // as a background, but we don't do it because the tabbar is transparent
                // in a non-scrolling content so we underlay our own behind it.
//                .toolbarBackground(.hidden, for: .tabBar) // Removes background and sets
                // selected item to be white-tinted.
                .toolbarColorScheme(.dark, for: .tabBar)
            }
            .toolbar(.visible)
            .toolbar {
                if viewModel.flowState.currentScreen == .home {
                    ToolbarItem {
                        FTProUpgradeButtonView {
#warning("Action is empty")
                        }
                    }
                }
                // In future SDKs of iOS we would have to put a spacer here.
                ToolbarItemGroup {
                    switch viewModel.flowState.currentScreen {
                    case .home:
                        FTPlusToolbarButtonView {
                #warning("Action is empty")
                        }
                    case .blocks: EmptyView()
                    case .profile: EmptyView()
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    let viewModel = MainFlowCoordinatorViewModel()
    MainFlowCoordinatorView(viewModel: viewModel)
}
