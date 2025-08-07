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
            Button(
                Constants.Strings.newBlocklistButtonTitle,
                systemImage: "plus.circle"
            ) {
                #warning("No implementation")
            }
            .buttonStyle(.ftPrimary)
            .padding()
            .background {
                Rectangle()
                    .fill(.ftBackground)
                    .ignoresSafeArea(edges: .bottom)
            }
        }
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
        .onAppear {
            viewModel.reloadData()
        }
    }
    
    var blockListView: some View {
        ScrollView(.vertical) {
            LazyVStack {
                ForEach(viewModel.state.items) { block in
                    FTSessionCardView(
                        emoji: block.emoji,
                        title: block.name,
                        mode: viewModel.makeCardMode(for: block)
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

#Preview {
    DraftsBlockItemListView(viewModel: .init(modelContainer: PreviewData.memoryOnlyModelContainer))
}
