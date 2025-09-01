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
        .background { FTBackgroundGradientView() }
        // MARK: - Bottom floating button
        .safeAreaInset(edge: .bottom) {
            Button(
                Constants.Strings.newBlocklistButtonTitle,
                systemImage: "plus.circle"
            ) {
                viewModel.navigateToFocusSessionNewItem()
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
        .navigationDestination(isPresented: .init(
            get: { viewModel.state.nextNavigationScreen != nil },
            set: { viewModel.setNextNavigationScreen($0) }
        )) {
            switch viewModel.state.nextNavigationScreen {
            case .focusSession(let viewModel):
                FocusSessionView(viewModel: viewModel)
            case .none: Text("No view")
            }
        }
        .alert(
            SharedConstants.Strings.errorHeader,
            isPresented: Binding(
                get: { viewModel.state.error != nil },
                set: { viewModel.setErrorVisibility($0) }
            ),
            actions: { /* OK dismissal button by default */ },
            message: { Text(viewModel.state.error?.localizedDescription ?? String()) }
        )
        .onAppear {
            viewModel.loadData()
            viewModel.subscribeToDB()
        }
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
    
    var blockListView: some View {
        ScrollView(.vertical) {
            LazyVStack {
                ForEach(viewModel.state.items) { block in
                    sessionCard(for: block)
                        .padding(1)
                        .onAppear { viewModel.hasReachEndOfList(blockItem: block) }
                }
            }
        }
        .padding(.top)
    }
    
    @ViewBuilder
    private func sessionCard(for block: ProtectedBlockItem) -> some View {
        if block.state.isActive {
            
            FTActiveSessionDraftRowView(
                emoji: block.emoji,
                title: block.name,
                timerPayload: viewModel.state.timerPayload
            )
        } else {
            Button {
                viewModel.navigateToFocusSessionEditing(list: block)
            } label: {
                if block.isScheduled {
                    FTSessionScheduledRowView(
                        emoji: block.emoji,
                        title: block.name,
                        description: block.type.description
                    )
                } else {
                    FTSessionDraftRowView(
                        emoji: block.emoji,
                        title: block.name,
                        description: block.type.description
                    )
                }
            }
            .buttonStyle(.plain)
        }
    }
    
}

#Preview {
    let factory = MockPersistenceStoreFactory()
    let manager = PreviewData.mockBlockItemPersistenceManager
    let registrar = PreviewData.mockActivityRegistrar
    let proState = MockPaymentManagerWithPurchaseError().state
    
    DraftsBlockItemListView(
        viewModel: .init(
            state: .init(timer: ConcurrencyTimer()),
            proState: proState,
            paywallPresenter: LivePaywallPresenter(),
            deviceActivityRegistrar: registrar,
            blockItemPersistenceManager: manager
        )
    )
    .preferredColorScheme(.dark)
}
