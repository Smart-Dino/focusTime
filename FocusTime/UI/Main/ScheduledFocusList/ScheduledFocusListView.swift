//
//  ScheduledFocusListView.swift
//  FocusTime
//
//  Created by Maksym Horobets on 19.06.2025.
//

import SwiftUI
import FocusTimeUI

struct ScheduledFocusListView: View {
    @State var viewModel: ScheduledFocusListViewModel
    
    var body: some View {
        ZStack {
            // MARK: - Gradient
            MainBackgroundGradientView()
            // MARK: - Wave image
            VStack {
                Image(Constants.Icons.waveImage)
                    .resizable()
                    .scaledToFit()
                Spacer()
            }
            .ignoresSafeArea()
            
            VStack(spacing: .zero) {
                // MARK: - List
                if viewModel.state.items.isEmpty {
                    noSchedulesView
                } else {
                    schedulesView
                }
            }
            .padding(.horizontal)
        }
        // MARK: - Bottom floating button
        .safeAreaInset(edge: .bottom) {
            Button(
                Constants.Strings.newSessionButtonTitle,
                systemImage: Constants.Icons.newSessionSymbol
            ) {
                #warning("Action is empty")
                Task {
                    try await viewModel.insertTestItemsIntoDatabase()
                }
            }
            .buttonStyle(.ftPrimary)
            .padding()
        }
        .navigationTitle(Constants.Strings.navTitle)
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .dynamicTypeSize(...DynamicTypeSize.accessibility2)
    }
    
    var schedulesView: some View {
        ScrollView(.vertical) {
            LazyVStack {
                ForEach(viewModel.state.items) { schedule in
                    FTScheduledFocusRowView(
                        emoji: schedule.emoji,
                        title: schedule.name,
                        description: schedule.days.description
                    )
                    .padding(1)
                    .onAppear { viewModel.hasReachEndOfList(schedule: schedule) }
                }
            }
        }
        .padding(.top)
    }
    
    var noSchedulesView: some View {
        VStack(spacing: 15) {
            Spacer()
            Text(Constants.Strings.noSchedulesTitle)
                .bold()
            Text(Constants.Strings.noSchedulesMessage)
                .multilineTextAlignment(.center)
                .foregroundStyle(.ftGray3)
            Spacer()
        }
    }
}

#warning("No preview.")
//#Preview {
//    NavigationStack {
//        if let scheduleStore = ScheduleStore(isStoredInMemoryOnly: true) {
//            ScheduledFocusListView(viewModel: .init(scheduleStore: scheduleStore))
//        } else {
//            Text("Could not initialize ScheduleStore.")
//        }
//    }
//}
