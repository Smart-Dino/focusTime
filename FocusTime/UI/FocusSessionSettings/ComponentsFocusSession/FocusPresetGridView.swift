//
//  FocusPresetGridView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 18.06.25.
//

import SwiftUI

struct FocusPresetGridView: View {
    let presets: [FocusPreset]
    @Binding var selectedPreset: FocusPreset?
    
    var body: some View {
        VStack(alignment: .leading, spacing: FocusSessionView.Constants.PresetGrid.Layout.mainSpacing) {
            VStack(alignment: .leading) {
                Text(FocusSessionView.Constants.PresetGrid.Strings.title)
                    .font(.headline)
                Text(FocusSessionView.Constants.PresetGrid.Strings.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            .padding(.horizontal)
            
            LazyVGrid(columns: FocusSessionView.Constants.PresetGrid.Layout.gridColumns, spacing: FocusSessionView.Constants.PresetGrid.Layout.gridVSpacing) {
                ForEach(presets) { preset in
                    Button(action: {
                        if selectedPreset == preset {
                            selectedPreset = nil
                        } else {
                            selectedPreset = preset
                        }
                    }) {
                        PresetIconView(
                            preset: preset,
                            isSelected: selectedPreset == preset
                        )
                    }
                }
            }
        }
    }
}
