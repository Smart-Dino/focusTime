//
//  MainFlowCoordinatorView.swift
//  FocusTime
//
//  Created by Maksym Horobets on 13.06.2025.
//

import SwiftUI

struct MainFlowCoordinatorView: View {
    @State var viewModel: MainFlowCoordinatorViewModel
    
    var body: some View {
        NavigationStack {
            TabView {
                Group {
                    if let ipGeoLocationViewModel = viewModel.setupIPGeolocationViewModel() {
                        Text("Home view")
                    } else {
                        Text("No geo view model")
                    }
                }
                .tabItem {
                    Label("Home", image: .wavelogo)
                }
                Group {
                    Text("Empty for now")
                }
                .tabItem {
                    Label("Greeting", systemImage: "person.circle")
                }
                
                Group {
                    Text("Empty for now")
                }
                    .tabItem {
                        Label("Useless", systemImage: "xmark.circle")
                    }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Settings", systemImage: "gear") {
                        viewModel.showSettings()
                    }
                }
            }
        }
        .sheet(isPresented: Binding(get: {
            viewModel.state.selectedSheet != nil
        }, set: { isPresented in
            viewModel.onUpdateSelectedSheet(isPresented: isPresented)
        })) {
            viewModel.onDismissSheet()
        } content: {
            switch viewModel.state.selectedSheet {
            case .settings:
                if let settingViewModel = viewModel.setupSettingsViewModel() {
                    SettingsView(viewModel: settingViewModel)
                } else {
                    Text("No settings view model")
                }
            case .paywall:
                Text("Paywall")
            case .none:
                Text("How you did open it?")
            }
        }
    }
}

#Preview {
    let viewModel = MainFlowCoordinatorViewModel()
    MainFlowCoordinatorView(viewModel: viewModel)
}
