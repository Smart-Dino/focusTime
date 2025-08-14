//
//  ScheduledFocusListView.swift
//  FocusTime
//
//  Created by Maksym Horobets on 19.06.2025.
//

import SwiftUI
import FocusTimeUI

struct ScheduledBlockItemsView: View {
    @State var viewModel: ScheduledBlockItemsViewModel
    
    var body: some View {
        ZStack {
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
        .background { MainBackgroundGradientView() }
        // MARK: - Bottom floating button
        .safeAreaInset(edge: .bottom) {
            Button(
                Constants.Strings.newSessionButtonTitle,
                systemImage: Constants.Icons.newSessionSymbol
            ) {
                #warning("No implementation")
            }
            .buttonStyle(.ftPrimary)
            .padding()
        }
        .navigationTitle(Constants.Strings.navTitle)
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .dynamicTypeSize(...DynamicTypeSize.accessibility2)
        .alert(
            SharedConstants.Strings.errorHeader,
            isPresented: Binding(get: {
                viewModel.state.error != nil
            }, set: { isVisible in
                viewModel.setErrorVisibility(isVisible)
            }), actions: {
                // OK dismissal button by default
            }, message: {
                Text(viewModel.state.error?.localizedDescription ?? "")
            }
        )
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
                    .onAppear { viewModel.hasReachEndOfList(blockItem: schedule) }
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
                .foregroundStyle(.ftGray3Light)
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        ScheduledBlockItemsView(
            viewModel: .init(modelContainer: PreviewData.memoryOnlyModelContainer)
        )
    }
}
