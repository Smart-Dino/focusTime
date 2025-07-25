//
//  HomeView.swift
//  FocusTime
//
//  Created by Maksym Horobets on 13.06.2025.
//

import SwiftUI
import FocusTimeUI

struct HomeView: View {
    @State var viewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            MainBackgroundGradientView()
            
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
                    Text(Constants.Strings.timerValue)
                        .font(.largeTitle).bold()
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.ftMainBlue, .ftBackgroundBlue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    Text(Constants.Strings.timerSubtitle)
                        .font(.callout)
                        .foregroundStyle(.ftGray3Light)
                }
                VStack(spacing: .zero) {
                    // MARK: - Scheduled focus button
                    NavigationLink(
                        value: MainScreens.scheduledFocusList(viewModel.makeScheduledFocusViewModel())
                    ) {
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
                    #warning("Placeholder")
                    if true {
                        FTHomeSessionCardView(
                            title: "Work time",
                            mode: .scheduled(timeRange: "6 AM - 7:30 PM")
                        )
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                    }
                }
                .frame(minHeight: 130) // Used so that the screen time value stays in the same place
            }
        }
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
        .preferredColorScheme(.dark)
        .dynamicTypeSize(...DynamicTypeSize.accessibility2)
    }
}

#warning("No preview.")
//#Preview {
//    NavigationStack {
//        if let scheduleStore = ScheduleStore(isStoredInMemoryOnly: true) {
//            HomeView(viewModel: .init(scheduleStore: scheduleStore))
//        } else {
//            Text("Could not initialize ScheduleStore.")
//        }
//    }
//}
