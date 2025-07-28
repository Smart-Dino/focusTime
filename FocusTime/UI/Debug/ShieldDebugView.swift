//
//  ShieldDebugView.swift
//  FocusTime
//
//  Created by Maksym Horobets on 24.06.2025.
//

import SwiftUI
import SwiftData
import FamilyControls
import DeviceActivity

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
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(schedule.name)
                                    Text(schedule.type.description)
                                        .font(.footnote)
                                }
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
                            VStack(alignment: .leading) {
                                Text(blockItem.name)
                                Text("Id: " + blockItem.id.uuidString)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            
            Button("Erase all data", role: .destructive) {
                Task {
                    await viewModel.eraseAllData()
                }
            }
            .buttonBorderShape(.capsule)
            .buttonStyle(.borderedProminent)
            
            // MARK: - Status
            sectionSeparator(sectionName: "Status")
            VStack(alignment: .leading) {
                Text("Apps chosen: \(viewModel.state.selection.applicationTokens.count)")
                Text("Categories chosen: \(viewModel.state.selection.categoryTokens.count)")
            }
            
            // MARK: - Selection
            sectionSeparator(sectionName: "Selection")
            
            Picker("Block Type", selection: Binding(
                get: { viewModel.state.scheduleType },
                set: { newValue in
                    viewModel.setScheduleType(newValue)
                })
            ) {
                Text("Scheduled").tag(ShieldDebugViewModel.State.ScheduleType.scheduled)
                Text("One-time").tag(ShieldDebugViewModel.State.ScheduleType.oneTime)
            }
            .pickerStyle(.segmented)
            
            if viewModel.state.scheduleType == .scheduled {
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
            } else if viewModel.state.scheduleType == .oneTime {
                VStack(alignment: .leading) {
                    Text("Block duration (minutes)")
                    Stepper(value: Binding(
                        get: { viewModel.state.duration },
                        set: { newValue in
                            viewModel.setDuration(newValue)
                        }
                    ), in: 1...240) {
                        Text("\(viewModel.state.duration) minutes")
                    }
                }
            }
            
            Button("Toggle selection sheet") {
                Task {
                    await viewModel.toggleSelectionSheet()
                }
            }
            
            Button("Create schedule") {
                Task {
                    await viewModel.addScheduleToDB()
                }
            }
            
            Button(viewModel.state.scheduleType == .scheduled ? "Start schedule" : "Start one-time block") {
                Task {
                    await viewModel.appendBlockItemToSchedule()
                    await viewModel.blockSelectionDuringSchedule()
                }
            }
            
            HStack {
                Button("Suspend") {
                    Task {
                        await viewModel.suspendSession()
                    }
                }
                Button("Resume") {
                    Task {
                        await viewModel.resumeSession()
                    }
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
            actions: {},
            message: {
                if let error = viewModel.state.error {
                    Text(error.localizedDescription)
                        .onAppear {
                            print(error)
                        }
                }
            }
        )
        .task {
            await viewModel.fetchAllItems()
        }
        .onAppear {
            print(DeviceActivityCenter().activities)
        }
    }
    
    init(viewModel: ShieldDebugViewModel) {
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
    ShieldDebugView(
        viewModel: .init(
            modelContainer: PreviewData.memoryOnlyModelContainer
        )
    )
}
