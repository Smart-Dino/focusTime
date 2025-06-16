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
                        }
                        .tag(MainTabScreens.blocks)
                    Text("Empty for now")
                        .tabItem {
                            Label("Profile", systemImage: "person")
                        }
                        .tag(MainTabScreens.profile)
                }
//                .toolbarBackground(Color.ftBackground, for: .tabBar)
//                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(.hidden, for: .tabBar)
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
                        homeScreenToolbarItems
                    case .blocks: EmptyView()
                    case .profile: EmptyView()
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    @ViewBuilder
    var homeScreenToolbarItems: some View {
        FTPlusToolbarButtonView {
#warning("Action is empty")
        }
    }
}

#Preview {
    let viewModel = MainFlowCoordinatorViewModel()
    MainFlowCoordinatorView(viewModel: viewModel)
}
