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

            // Nav title and an image below it.
            VStack {
                VStack(alignment: .leading) {
                    Text(Constants.Strings.navigationTitle)
                        .font(Constants.Fonts.navigationTitle)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

                Image(
                    ImageResource
                        .MainImages
                        .homeViewWave
                )
                .resizable()
                .scaledToFit()

                Spacer()
            }

            // Main content on this view.
            VStack(spacing: Constants.Layout.mainSpacing) {
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
                        .foregroundStyle(.ftGray3)
                }

                // Scheduled focus button
                Button {
                    #warning("Empty button action")
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(Constants.Strings.scheduledFocusTitle)
                                .font(.title3)
                                .bold()
                            Text(Constants.Strings.scheduledFocusSubtitle)
                                .font(.subheadline)
                                .foregroundStyle(.ftGray3)
                        }
                        Spacer()
                        Image(systemName: Constants.Icons.chevronRight)
                    }
                    .foregroundStyle(.ftMainBlue)
                }
                .buttonStyle(.plain)
                .padding(.horizontal)
            }
        }
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
    }
}

#Preview {
    NavigationStack {
        HomeView(viewModel: .init())
    }
}
