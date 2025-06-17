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
                Image(
                    ImageResource
                        .MainImages
                        .appBlockingListWave
                )
                .resizable()
                .scaledToFit()
                Spacer()
            }
            .ignoresSafeArea()
            
            VStack {
                // Nav title
                VStack(alignment: .leading) {
                    Text("App Blocking")
                        .font(Constants.Fonts.navigationTitle)
                    Text("Block distracting apps and create custom schedules to stay in flow")
                        .font(.subheadline)
                        .foregroundStyle(.ftGray3)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // List
                if [1].isEmpty {
                    noBlockListView
                } else {
                    blockListView
                }
            }
            .padding(.horizontal)
        }
        .safeAreaInset(edge: .bottom) {
            Button("New Blocklist", systemImage: "plus.circle") {
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
    
    var blockListView: some View {
        VStack {
            ScrollView(.vertical) {
                ForEach([BlockItem.mocks.first!]) { block in
                    FTScheduleItemView(
                        emoji: block.icon,
                        title: block.name,
                        description: block.schedule?.endTime.description ?? "None",
                        style: .appBlocking
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
            Text("🛑 No Blocklists Yet!")
                .bold()
            Text("Looks like you haven’t made any blocklists yet. Create one to keep distracting apps out of sight during focus time. Staying on track has never been easier!")
                .multilineTextAlignment(.center)
                .foregroundStyle(.ftGray3)
            Spacer()
        }
    }
}

#Preview {
    AppBlockingListView(viewModel: .init())
}
