//
//  AppBlockingListView.swift
//  FocusTime
//
//  Created by Maksym Horobets on 17.06.2025.
//

import SwiftUI
import FocusTimeUI

struct AppBlockingListView: View {
    @State var viewModel: AppBlockingListViewModel
    
    var body: some View {
        ZStack {
            // Gradient
            MainBackgroundGradientView()
            // Wave image
            VStack {
                Image(Constants.Icons.waveImage)
                    .resizable()
                    .scaledToFit()
                Spacer()
            }
            .ignoresSafeArea()
            
            VStack {
                // Nav title
                VStack(alignment: .leading) {
                    Text(Constants.Strings.navTitle)
                        .font(Constants.Fonts.navigationTitle)
                    Text(Constants.Strings.navSubtitle)
                        .font(.subheadline)
                        .foregroundStyle(.ftGray3)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // List
                if viewModel.state.items.isEmpty {
                    noBlockListView
                } else {
                    blockListView
                }
            }
            .padding(.horizontal)
        }
        .safeAreaInset(edge: .bottom) {
            Button(Constants.Strings.newBlocklistButtonTitle, systemImage: "plus.circle") {
#warning("Action is empty")
                Task {
                    await viewModel.insertTestItemsIntoDatabase()
                }
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
    
    var blockListView: some View {
        ScrollView(.vertical) {
            LazyVStack {
                ForEach(viewModel.state.items) { block in
                    FTSessionSummaryCardView(
                        emoji: block.emoji,
                        title: block.name,
                        description: block.schedulesDescription,
                    )
                    .padding(1)
                }
            }
        }
        .padding(.top)
    }
    
    var noBlockListView: some View {
        VStack(spacing: 15) {
            Spacer()
            Text(Constants.Strings.noBlocklistsTitle)
                .bold()
            Text(Constants.Strings.noBlocklistsMessage)
                .multilineTextAlignment(.center)
                .foregroundStyle(.ftGray3)
            Spacer()
        }
    }
}

#Preview {
    AppBlockingListView(viewModel: .init())
}
