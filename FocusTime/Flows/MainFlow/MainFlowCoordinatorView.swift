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
            TabView {
                Group {
                    Group {
                        Text("Home view")
                    }
                    .tabItem {
                        LabeledContent("Home") {
                            Image(.wavelogo)
                                .renderingMode(.template)
                        }
                    }
                    Group {
                        Text("Empty for now")
                    }
                    .tabItem {
                        Label("Blocks", systemImage: "hand.raised")
                    }
                    
                    Group {
                        Text("Empty for now")
                    }
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
                }
                .toolbarBackground(Color.ftBackground, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarColorScheme(.dark, for: .tabBar)
            }
            .toolbar {
                toolBarItems
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: .constant(false)) {
            // On dismiss sheet
        } content: {
            switch viewModel.flowState.currentFlow {
            default: Text("Empty for now")
            }
        }
    }
    
    @ToolbarContentBuilder
    var toolBarItems: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Settings", systemImage: "gear") {
                // Open settings
            }
        }
    }
}

#Preview {
    let viewModel = MainFlowCoordinatorViewModel()
    MainFlowCoordinatorView(viewModel: viewModel)
}
