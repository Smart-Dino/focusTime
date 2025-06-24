//
//  FocusPresetGridView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 18.06.25.
//

import SwiftUI

struct FocusPresetGridView: View {
    let presets: [FocusPreset]
    let selectedPresetID: UUID?
    
    weak var delegate: FocusPresetGridViewDelegate?
    
    private let gridColumns = FocusSessionView.Constants.PresetGrid.Layout.gridColumns
    private typealias Strings = FocusSessionView.Constants.PresetGrid.Strings
    private typealias Layout = FocusSessionView.Constants.PresetGrid.Layout
    
    var body: some View {
        VStack(alignment: .leading, spacing: Layout.mainSpacing) {
            VStack(alignment: .leading) {
                Text(Strings.title)
                    .font(.headline)
                Text(Strings.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            
            LazyVGrid(columns: gridColumns, spacing: Layout.gridVSpacing) {
                ForEach(presets) { preset in
                    Button(action: { delegate?.focusPresetGridDidSelectPreset(preset) }) {
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


