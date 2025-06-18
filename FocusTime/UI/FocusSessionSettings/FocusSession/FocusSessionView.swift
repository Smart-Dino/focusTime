//
//  FocusSessionView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 17.06.25.
//

import SwiftUI
import FocusTimeUI

/// A custom ViewModifier to apply the consistent style to each settings row.
/// This keeps styling consistent and reusable.
struct RowStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(height: 64)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(12)
            .tint(.white)
    }
}


/// The view for a single icon in the preset grid.
/// It's a small, reusable component.
struct PresetIconView: View {
    let preset: FocusPreset
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 60, height: 60)
                    .cornerRadius(20)
                
                if isSelected {
                    Rectangle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .cornerRadius(20)
                }
                
                Image(systemName: preset.iconName)
                    .foregroundColor(.white)
                    .font(.title2)
            }
            
            Text(preset.name)
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                //.lineLimit(2, reservesSpace: true)
        }
    }
}




struct FocusSessionView: View {
    
    @State private var viewModel = FocusSessionViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.07, green: 0.09, blue: 0.11)
                    .ignoresSafeArea()

                VStack {
                    ScrollView {
                        VStack(spacing: 40) {
                            configurationSection
                            presetGridSection
                        }
                        .padding(.vertical)
                    }
                    
                    Button("Start", systemImage: "hourglass") {
                        // Action for start button
                    }
                    .buttonStyle(FTPrimaryButtonStyle())
                    .padding([.horizontal, .bottom])
                    .disabled(!viewModel.isStartButtonEnabled)
                }
            }
            .navigationTitle("Focus Setup")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Focus Setup").foregroundColor(.white).bold()
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color(red: 0.07, green: 0.09, blue: 0.11), for: .navigationBar)

            
            
            .sheet(isPresented: $viewModel.isDurationPickerPresented) {

                DurationPickerSheetView(
                    hours: $viewModel.selectedHours,
                    minutes: $viewModel.selectedMinutes
                )

                .presentationDetents([.height(400)])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(25)
            }
        }
        .preferredColorScheme(.dark)
    }

    
    
    
    
    
    // MARK: - UI Subsections
    
    private var configurationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("List name")
                Spacer()
                TextField("Name", text: $viewModel.listName)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.white)
            }
            .modifier(RowStyle())

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Schedule for later")
                    Spacer()
                    Toggle("", isOn: $viewModel.scheduleForLater)
                        .tint(.blue)
                }
                .modifier(RowStyle())
                
                Text("Turn on to have this blocklist activate automatically based on your scheduled days and times.")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 4)
            }

           
            Button(action: viewModel.presentDurationPicker) {
                HStack {
                    Text("Duration")
                    Spacer()

                    
                    Text(viewModel.formattedDuration)
                        .foregroundColor(.white)
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            }
            .modifier(RowStyle())
            
            NavigationLink(destination: Text("App List Picker Screen")) {
                HStack {
                    Text("Apps Blocked")
                    Spacer()
                    Text("List")
                    Image(systemName: "chevron.right")
                }
            }
            .modifier(RowStyle())
        }
        .padding(.horizontal)
        .foregroundColor(.white)
    }
    
    private var presetGridSection: some View {

        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading) {
                Text("Choose Your Focus Preset").font(.headline)
                Text("Ready-made blocklists to help you stay focused. Choose a preset to quickly block distracting apps.").font(.subheadline).foregroundColor(.gray)
            }
            .padding(.horizontal)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 20) {
                ForEach(viewModel.presets) { preset in
                    Button(action: { viewModel.selectPreset(preset) }) {
                        PresetIconView(
                            preset: preset,
                            isSelected: viewModel.selectedPresetID == preset.id
                        )
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}


// MARK: - Preview
#Preview {
    FocusSessionView()
}
