//
//  BlockListPickerSheetView.swift
//  FocusTime
//
//  Created by Maksym Horobets on 26.08.2025.
//

import SwiftUI
import FocusTimeUI
import FamilyControls

struct BlockListPickerSheetView: View {
    @Environment(\.dismiss) var dismiss
    @State var viewModel: BlockListPickerSheetViewModel
    
    var body: some View {
        VStack {
            Text(Constants.Strings.title)
                .font(.title3.bold())
                .foregroundStyle(.ftMainBlue)
            
            Text(Constants.Strings.subtitle)
                .font(.subheadline)
                .foregroundStyle(.ftGray3Light)
                .padding(.bottom)
                .multilineTextAlignment(.center)
            
            Text(
                viewModel.state.blockItems.isEmpty
                ? Constants.Strings.emptyStateTitle
                : Constants.Strings.listTitle
            )
            .font(.title2.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
            
            Group {
                if viewModel.state.blockItems.isEmpty {
                    blockItemEmptyListView
                } else {
                    blockItemListView
                }
            }
            .onAppear(perform: viewModel.fetchNextPage)
        }
        .padding(.top, Constants.Layout.topViewPadding)
        .background(Color.ftBlockListPickerSheetBackground)
        .presentationDragIndicator(.visible)
        .alert(
            SharedConstants.Strings.errorHeader,
            isPresented: Binding(
                get: { viewModel.state.error != nil },
                set: { viewModel.setErrorVisibility($0) }
            ),
            actions: { /* OK dismissal button by default */ },
            message: { Text(viewModel.state.error?.localizedDescription ?? String()) }
        )
        .familyActivityPicker(
            isPresented: .binding(
                get: viewModel.state.isFamilyActivitySheetPresented,
                set: viewModel.setIsFamilyActivitySheetPresented(_:)
            ),
            // This does not work with a custom binding initializer.
            selection: .init(
                get: { viewModel.state.finalSelection },
                set: { viewModel.setFamilyActivitySelection($0) }
            )
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
        .onChange(of: viewModel.state.isFamilyActivitySheetPresented) {
            if !viewModel.state.isFamilyActivitySheetPresented && viewModel.state.blockItems.isEmpty {
                viewModel.saveSelection()
                dismiss.callAsFunction()
            }
        }
        .safeAreaInset(edge: .bottom) {
            Group {
                if viewModel.state.finalSelection.isEmpty {
                    Button(Constants.Strings.newBlocklistButton, systemImage: "plus.circle") {
                        viewModel.setIsFamilyActivitySheetPresented(true)
                    }
                    .transition(.scale)
                } else {
                    Button(Constants.Strings.saveSelectionButton, systemImage: "checkmark") {
                        viewModel.saveSelection()
                        dismiss()
                    }
                    .transition(.scale)
                }
            }
            .animation(.default, value: viewModel.state.finalSelection.isEmpty)
            .buttonStyle(.ftPrimary)
            .padding()
            .backgroundGradientFade()
        }
    }
    
    @ViewBuilder
    var blockItemListView: some View {
        ScrollView(.vertical) {
            LazyVStack {
                ForEach(viewModel.state.blockItems) { blockItem in
                    FTSessionSelectionRowView(
                        emoji: blockItem.emoji,
                        title: blockItem.name,
                        description: blockItem.type.description,
                        isToggled: .binding(
                            get: viewModel.isSelected(blockItem),
                            set: { isSelected in
                                viewModel.toggleBlockItem(blockItem, isSelected: isSelected)
                            }
                        )) {
                            viewModel.navigateToFocusSessionEditing(list: blockItem)
                        }
                        .padding(.horizontal)
                        .onAppear { viewModel.hasReachEndOfList(blockItem: blockItem) }
                }
            }
        }
    }
    
    @ViewBuilder
    var blockItemEmptyListView: some View {
        Text(Constants.Strings.emptyStateDescription)
            .foregroundStyle(.ftGray3Light)
        Spacer()
    }
}

#Preview("Populated list") {
    let factory = MockPersistenceStoreFactory()
    let manager = PreviewData.mockBlockItemPersistenceManager
    let registrar = LiveDeviceActivityRegistrar(
        blockItemPersistenceManager: manager,
        shieldManager: LiveShieldManager()
    )
    let viewModel = BlockListPickerSheetViewModel(
        deviceActivityRegistrar: registrar,
        blockItemPersistenceManager: manager
    )
    
    var randomBlockItem: ProtectedBlockItem {
        ProtectedBlockItem(
            emoji: SharedConstants.Strings.defaultEmojis.randomElement()!,
            name: "Test item",
            days: Weekday.weekdays,
            type: .duration(duration: .init(seconds: Int.random(in: 0..<3600))),
            blockedContent: FamilyActivitySelection()
        )
    }
    
    NavigationStack {
        VStack {
            Text("Some View")
        }
        .sheet(isPresented: .constant(true)) {
            BlockListPickerSheetView(viewModel: viewModel)
                .onAppear {
                    Task {
                        for _ in 0..<100 {
                            let blockItem = randomBlockItem
                            try? await manager.insert(blockItem)
                        }
                        viewModel.fetchNextPage()
                    }
                }
        }
        .preferredColorScheme(.dark)
    }
}
