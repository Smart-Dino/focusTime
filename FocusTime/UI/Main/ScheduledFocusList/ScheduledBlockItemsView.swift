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
        .background { FTBackgroundGradientView() }
        // MARK: - Bottom floating button
        .safeAreaInset(edge: .bottom) {
            Button(
                Constants.Strings.newSessionButtonTitle,
                systemImage: Constants.Icons.newSessionSymbol
            ) {
                viewModel.navigateToFocusSessionNewItem()
            }
            .buttonStyle(.ftPrimary)
            .padding()
            .backgroundGradientFade()
        }
        .navigationTitle(Constants.Strings.navTitle)
        .navigationBarTitleDisplayMode(.inline)
        .dynamicTypeSize(...DynamicTypeSize.accessibility2)
        .alert(
            SharedConstants.Strings.errorHeader,
            isPresented: Binding(
                get: { viewModel.state.error != nil },
                set: { viewModel.setErrorVisibility($0) }
            ),
            actions: { /* OK dismissal button by default */ },
            message: { Text(viewModel.state.error?.localizedDescription ?? String()) }
        )
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
        .onAppear {
            viewModel.loadData()
        }
    }
    
    var schedulesView: some View {
        ScrollView(.vertical) {
            LazyVStack {
                ForEach(viewModel.state.items) { block in
                    FTSessionScheduledRowView(
                        emoji: block.emoji,
                        title: block.name,
                        description: block.type.description
                    )
                    .padding(1)
                    .onAppear { viewModel.hasReachEndOfList(blockItem: block) }
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
        let manager = PreviewData.mockBlockItemPersistenceManager
        let proState = MockPaymentManagerWithPurchaseError().state
        let registrar = LiveDeviceActivityRegistrar(
            blockItemPersistenceManager: manager,
            shieldManager: LiveShieldManager()
        )
        
        let viewModel = ScheduledBlockItemsViewModel(
            state: .init(proState: proState),
            paywallPresenter: LivePaywallPresenter(),
            deviceActivityRegistrar: registrar,
            blockItemPersistenceManager: manager
        )
        
        ScheduledBlockItemsView(
            viewModel: viewModel
        )
        .preferredColorScheme(.dark)
    }
}
