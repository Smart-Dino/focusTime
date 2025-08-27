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
    @State var viewModel: BlockListPickerSheetViewModel
    
    var body: some View {
        VStack {
            Text("Block Distractions")
                .font(.title3.bold())
                .foregroundStyle(.ftMainBlue)
            
            Text("Choose which apps to block during your\nfocus sessions")
                .font(.subheadline)
                .foregroundStyle(.ftGray3Light)
                .padding(.bottom)
                .multilineTextAlignment(.center)
            
            Text(
                viewModel.state.blockItems.isEmpty
                ? "No Blocklists Yet"
                : "Your Blocklists"
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
            Button("New Blocklist", systemImage: "plus.circle") {
                viewModel.setIsFamilyActivitySheetPresented(true)
            }
            .buttonStyle(.ftPrimary)
            .opacity(viewModel.state.selectedBlockItems.isEmpty ? 1 : 0)
            .animation(.default, value: viewModel.state.selectedBlockItems.isEmpty)
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
                            // Move to the editing view.
                        }
                        .padding(.horizontal)
                        .onAppear { viewModel.hasReachEndOfList(blockItem: blockItem) }
                }
            }
        }
    }
    
    @ViewBuilder
    var blockItemEmptyListView: some View {
        Text("Create custom app blocklists to help you stay focused, reduce distractions, and build healthier screen habits.")
            .foregroundStyle(.ftGray3Light)
        Spacer()
    }
}

#Preview {
    let factory = MockPersistenceStoreFactory()
    let manager = PreviewData.mockBlockItemPersistenceManager
    let viewModel = BlockListPickerSheetViewModel(blockItemPersistenceManager: manager)
    
    NavigationStack {
        BlockListPickerSheetView(viewModel: viewModel)
            .preferredColorScheme(.dark)
            .onAppear {
                Task {
                    for _ in 0..<100 {
                        let blockItem = ProtectedBlockItem(
                            emoji: SharedConstants.Strings.defaultEmojis.randomElement()!,
                            name: "Test item",
                            days: Weekday.weekdays,
                            type: .duration(duration: .init(seconds: Int.random(in: 0..<3600))),
                            blockedContent: FamilyActivitySelection()
                        )
                        try? await manager.insert(blockItem)
                    }
                    viewModel.fetchNextPage()
                }
            }
    }
}
