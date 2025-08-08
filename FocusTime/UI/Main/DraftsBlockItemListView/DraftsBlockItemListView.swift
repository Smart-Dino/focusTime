//
//  DraftsBlockItemListView.swift
//  FocusTime
//
//  Created by Maksym Horobets on 17.06.2025.
//

import SwiftUI
import FocusTimeUI

struct DraftsBlockItemListView: View {
    @State var viewModel: DraftsBlockItemListViewModel
    
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
            
            VStack {
                // MARK: - Nav title
                VStack(alignment: .leading) {
                    Text(Constants.Strings.navTitle)
                        .font(Constants.Fonts.navigationTitle)
                    Text(Constants.Strings.navSubtitle)
                        .font(.subheadline)
                        .foregroundStyle(.ftGray3Light)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // MARK: - List
                if viewModel.state.items.isEmpty {
                    noBlockListView
                } else {
                    blockListView
                }
            }
            .padding(.horizontal)
        }
        .background { MainBackgroundGradientView() }
        // MARK: - Bottom floating button
        .safeAreaInset(edge: .bottom) {
            Button(Constants.Strings.newBlocklistButtonTitle, systemImage: "plus.circle") {
                #warning("Placeholder code")
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
        .alert(
            SharedConstants.Strings.errorHeader,
            isPresented: Binding(get: {
                viewModel.state.error != nil
            }, set: { showError in
                viewModel.keepShowingError(showError: showError)
            }), actions: {
                // OK dismissal button by default
            }, message: {
                Text(viewModel.state.error?.localizedDescription ?? "")
            }
        )
    }
    
    var blockListView: some View {
        ScrollView(.vertical) {
            LazyVStack {
                ForEach(viewModel.state.items) { block in
                    FTSessionSummaryCardView(
                        emoji: block.emoji,
                        title: block.name,
                        description: block.type.description,
                    )
                    .padding(1)
                    .onAppear { viewModel.hasReachEndOfList(blockItem: block) }
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
                .foregroundStyle(.ftGray3Light)
            Spacer()
        }
    }
}

#warning("No preview.")
//#Preview {
//    if let blockItemStore = BlockItemStore(isStoredInMemoryOnly: true) {
//        AppBlockingListView(viewModel: .init(blockItemStore: blockItemStore))
//    }
//}
