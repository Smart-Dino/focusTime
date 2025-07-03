//
//  FocusPresetGridView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 18.06.25.
//

import SwiftUI

struct FocusPresetGridView: View {
    let presets: [FocusPreset]
    // MARK: - Refactored: Changed to @Binding for direct updates
    @Binding var selectedPresetID: UUID?
    
    var body: some View {
        VStack(alignment: .leading, spacing: FocusSessionView.Constants.PresetGrid.Layout.mainSpacing) {
            VStack(alignment: .leading) {
                Text(FocusSessionView.Constants.PresetGrid.Strings.title)
                    .font(.headline)
                Text(FocusSessionView.Constants.PresetGrid.Strings.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            
            LazyVGrid(columns: FocusSessionView.Constants.PresetGrid.Layout.gridColumns, spacing: FocusSessionView.Constants.PresetGrid.Layout.gridVSpacing) {
                ForEach(presets) { preset in
                    Button(action: {
                        // MARK: - Refactored: Directly modify the binding
                        if selectedPresetID == preset.id {
                            selectedPresetID = nil
                        } else {
                            selectedPresetID = preset.id
                        }
                    }) {
                        PresetIconView(
                            preset: preset,
                            isSelected: selectedPresetID == preset.id
                        )
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
