//
//  ShieldDebugView.swift
//  FocusTime
//
//  Created by Maksym Horobets on 24.06.2025.
//

import SwiftUI
import FamilyControls

struct ShieldDebugView: View {
    @State private var viewModel: ShieldDebugViewModel
    
    var body: some View {
        VStack {
            // MARK: - Schedule list
            VStack {
                ScrollView(.vertical) {
                    ForEach(viewModel.state.schedules) { schedule in
                        HStack {
                            Text(schedule.emoji)
                            VStack {
                                Text(schedule.name)
                                Text("Id: " + schedule.id.uuidString)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            
            // MARK: - BlockItem list
            VStack {
                ScrollView(.vertical) {
                    ForEach(viewModel.state.blockItems) { blockItem in
                        HStack {
                            Text(blockItem.emoji)
                            VStack {
                                Text(blockItem.name)
                                Text("Id: " + blockItem.id.uuidString)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            
            Button("Erase all data", role: .destructive) {
                viewModel.eraseAllData()
            }
            .buttonBorderShape(.capsule)
            .buttonStyle(.borderedProminent)
            
            // MARK: - Status
            sectionSeparator(sectionName: "Status")
            VStack(alignment: .leading) {
                Text("Is blocked: \(viewModel.shieldManager.isShieldActive.description)")
                Text("Apps chosen: \(viewModel.state.selection.applicationTokens.count)")
                Text("Categories chosen: \(viewModel.state.selection.categoryTokens.count)")
            }
            
            // MARK: - Selection
            sectionSeparator(sectionName: "Selection")
            Menu("Select days") {
                ForEach(Weekday.allCases) { weekday in
                    Button {
                        viewModel.toggleSelectionFor(weekday: weekday)
                    } label: {
                        if viewModel.state.daySelection.contains(weekday) {
                            Label(weekday.description, systemImage: "checkmark")
                        } else {
                            Text(weekday.description)
                        }
                    }
                }
            }
            .menuActionDismissBehavior(.disabled)
            
            HStack {
                DatePicker(
                    "Select start time",
                    selection:
                        Binding(get: {
                            viewModel.state.startTime
                        }, set: { date in
                            viewModel.setStartTime(date)
                        }),
                    displayedComponents: [.hourAndMinute]
                )
                .datePickerStyle(.compact)
                DatePicker(
                    "Select end time",
                    selection:
                        Binding(get: {
                            viewModel.state.endTime
                        }, set: { date in
                            viewModel.setEndTime(date)
                        }),
                    displayedComponents: [.hourAndMinute]
                )
            }
            
            Button("Toggle selection sheet") {
                Task {
                    await viewModel.toggleSelectionSheet()
                }
            }
            
            Button("Create schedule") {
                Task {
                    do {
                        try await viewModel.addScheduleToDB()
                    } catch {
                        print(error)
                    }
                }
            }
            
            Button("Start schedule") {
                Task {
                    try viewModel.appendBlockItemToSchedule()
                    await viewModel.blockSelectionDuringSchedule()
                }
            }
            
            // MARK: - Controls
            sectionSeparator(sectionName: "Controls")
            VStack {
                Button("Start block") {
                    Task {
                        await viewModel.blockSelection()
                    }
                }
                .buttonStyle(.borderedProminent)
                Button("End block", role: .destructive) {
                    Task {
                        await viewModel.unblockSelection()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity)
            .buttonBorderShape(.capsule)
        }
        .padding()
        .familyActivityPicker(
            isPresented: Binding(get: {
                viewModel.state.isAppSelectionPresented
            }, set: { isPresented in
                viewModel.setAppSelectionPresented(isPresented)
            }),
            selection: Binding(get: {
                viewModel.state.selection
            }, set: { selection in
                viewModel.setSelection(selection)
            })
        )
        .alert(
            "There was an error",
            isPresented: Binding(get: {
                viewModel.state.error != nil
            }, set: { bool in
                viewModel.removeError(bool)
            }),
            actions: { }
        )
        .onAppear(perform: viewModel.fetchAllItems)
    }
    
    init(viewModel: ShieldDebugViewModel = ShieldDebugViewModel()) {
        self.viewModel = viewModel
    }
    
    
    func sectionSeparator(sectionName: String) -> some View {
        Group {
            Divider()
            Text(sectionName).bold()
            Divider()
        }
    }
}

#Preview {
    ShieldDebugView()
}
