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
        .background(Color.ftblockListPickerSheetBackground)
        .presentationDragIndicator(.visible)
        .familyActivityPicker(
            isPresented: .binding(
                get: viewModel.state.isFamilyActivitySheetPresented,
                set: viewModel.setIsFamilyActivitySheetPresented(_:)
            ),
            selection: .binding(
                get: viewModel.state.finalSelection,
                set: viewModel.setFamilyActivitySelection(_:)
            )
        )
        .safeAreaInset(edge: .bottom) {
            let showCreateButton = viewModel.state.finalSelection.isEmpty && viewModel.state.selectedBlockItems.isEmpty
            
            Group {
                if showCreateButton {
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
            .animation(.default, value: showCreateButton)
            .buttonStyle(.ftPrimary)
            .padding()
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
#warning("Move to the editing view")
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

#Preview {
    let factory = MockPersistenceStoreFactory()
    let manager = PreviewData.mockBlockItemPersistenceManager
    let viewModel = BlockListPickerSheetViewModel(blockItemPersistenceManager: manager)
    
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
        BlockListPickerSheetView(viewModel: viewModel)
            .preferredColorScheme(.dark)
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
}
