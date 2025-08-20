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
            // This view causes DeviceActivityMonitorExtension unblock to fail on Simulator only.
            // Important: All bugs related to this view can only be replicated on a Simulator, so avoid using it
            // altogether!
#if targetEnvironment(simulator)
            Text(SharedConstants.Strings.simulatorUnavailability)
#else
            DeviceActivityReport(
                Constants.ActivityConfiguration.context,
                filter: Constants.ActivityConfiguration.filter
            )
#endif
            
            // MARK: - BlockItem list
            VStack {
                ScrollView(.vertical) {
                    ForEach(viewModel.state.blockItems) { blockItem in
                        makeCard(blockItem)
                    }
                }
            }
            
            Button(Constants.Strings.eraseAllData, role: .destructive) {
                viewModel.eraseAllData()
            }
            .buttonBorderShape(.capsule)
            .buttonStyle(.borderedProminent)
            
            // MARK: - Status
            sectionSeparator(sectionName: Constants.Strings.statusSection)
            VStack(alignment: .leading) {
                Text(Constants.Strings.appsChosen + "\(viewModel.state.selection.applicationTokens.count)")
                Text(Constants.Strings.categoriesChosen + "\(viewModel.state.selection.categoryTokens.count)")
            }
            
            // MARK: - Selection
            sectionSeparator(sectionName: Constants.Strings.selectionSection)
            
            Picker(Constants.Strings.blockTypePicker, selection: Binding(
                get: { viewModel.state.scheduleType },
                set: { newValue in
                    viewModel.setScheduleType(newValue)
                })
            ) {
                Text(Constants.Strings.scheduledType)
                    .tag(ShieldDebugViewModel.State.ScheduleType.scheduled)
                Text(Constants.Strings.durationType)
                    .tag(ShieldDebugViewModel.State.ScheduleType.duration)
            }
            .pickerStyle(.segmented)
            
            // MARK: - Time pickers
            switch viewModel.state.scheduleType {
            case .scheduled: scheduleTimePicker
            case .duration: durationTimePicker
            }
            
            Button(Constants.Strings.toggleSelectionSheet) {
                Task {
                    await viewModel.toggleSelectionSheet()
                }
            }
            
            Button(Constants.Strings.createSchedule) {
                viewModel.addScheduleToDB()
            }
            
            Button(viewModel.state.scheduleType.buttonTitle) {
                viewModel.blockSelectionDuringSchedule()
            }
            
            Button("Block for a minute") {
                viewModel.suspendFor()
            }
            
            HStack {
                Button(Constants.Strings.suspend) {
                    viewModel.suspendSession()
                }
                Button(Constants.Strings.resume) {
                    viewModel.resumeSession()
                }
            }
            
            // MARK: - Controls
            sectionSeparator(sectionName: Constants.Strings.controlsSection)
            VStack {
                Button(Constants.Strings.startBlock) {
                    Task {
                        await viewModel.blockSelection()
                    }
                }
                .buttonStyle(.borderedProminent)
                Button(Constants.Strings.endBlock, role: .destructive) {
                    Task {
                        await viewModel.unblockSelection()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity)
            .buttonBorderShape(.capsule)
        }
        .padding(.horizontal, Constants.Layout.horizontalPadding)
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
            SharedConstants.Strings.errorHeader,
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
        .onAppear {
            viewModel.reloadItems()
        }
    }
    
    var scheduleTimePicker: some View {
        HStack {
            DatePicker(
                Constants.Strings.selectStartTime,
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
                Constants.Strings.selectEndTime,
                selection:
                    Binding(get: {
                        viewModel.state.endTime
                    }, set: { date in
                        viewModel.setEndTime(date)
                    }),
                displayedComponents: [.hourAndMinute]
            )
        }
    }
    
    var durationTimePicker: some View {
        VStack(alignment: .leading) {
            Text(Constants.Strings.blockDuration)
            Stepper(value: Binding(
                get: { viewModel.state.duration },
                set: { newValue in
                    viewModel.setDuration(newValue)
                }
            ), in: 1...240) {
                Text("\(viewModel.state.duration) " + Constants.Strings.blockDurationSuffix)
            }
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
    
    func makeCard(_ blockItem: ProtectedBlockItem) -> some View {
        HStack(alignment: .top, spacing: 12) {
            // Emoji
            Text(blockItem.emoji)
                .font(.largeTitle)
                .frame(width: 44, height: 44)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 6) {
                // Title
                HStack {
                    Text(blockItem.name)
                        .font(.headline)
                    Spacer()
                    Text(blockItem.isActive ? "Active" : "Inactive")
                        .font(.caption)
                        .foregroundStyle(blockItem.isActive ? .green : .red)
                }
                
                // Details depending on type
                switch blockItem.type {
                case let .scheduled(startTime, endTime, isActive, isPaused, suspendedUntil):
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Start: \(startTime.description)")
                        Text("End: \(endTime.description)")
                        Text("Paused: \(isPaused.description)")
                        Text("Suspended until: \(suspendedUntil?.formatted() ?? "—")")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    
                case let .duration(duration, suspendedAt, suspendedUntil, endDate):
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Duration: \(duration.description)")
                        Text("Suspended at: \(suspendedAt?.formatted() ?? "—")")
                        Text("Suspended until: \(suspendedUntil?.formatted() ?? "—")")
                        Text("End date: \(endDate?.formatted() ?? "—")")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                
                // BlockItem ID
                Text(Constants.Strings.blockItemIdPrefix + blockItem.id.uuidString)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

}

#Preview {
    let centerManager = LiveDeviceActivityCenterManager()
    let factory = MockPersistenceStoreFactory()
    let manager = PreviewData.mockBlockItemPersistenceManager
    
    ShieldDebugView(
        viewModel: .init(blockItemPersistenceManager: manager)
    )
}

