//
//  PresetIconView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 18.06.25.
//

import SwiftUI

struct PresetIconView: View {
    let preset: FocusPreset
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: FocusSessionView.Constants.PresetIcon.Layout.mainSpacing) {
            ZStack {
                Rectangle()
                    .fill(FocusSessionView.Constants.PresetIcon.Colors.background)
                    .frame(width: FocusSessionView.Constants.PresetIcon.Layout.size, height: FocusSessionView.Constants.PresetIcon.Layout.size)
                    .cornerRadius(FocusSessionView.Constants.PresetIcon.Layout.cornerRadius)
                
                if isSelected {
                    Rectangle()
                        .fill(FocusSessionView.Constants.PresetIcon.Colors.selectedBackground)
                        .frame(width: FocusSessionView.Constants.PresetIcon.Layout.size, height: FocusSessionView.Constants.PresetIcon.Layout.size)
                        .cornerRadius(FocusSessionView.Constants.PresetIcon.Layout.cornerRadius)
                        .overlay(
                            RoundedRectangle(cornerRadius: FocusSessionView.Constants.PresetIcon.Layout.cornerRadius)
                                .stroke(FocusSessionView.Constants.PresetIcon.Colors.selectedBorder, lineWidth: FocusSessionView.Constants.PresetIcon.Layout.selectedBorderWidth)
                        )
                }
                
                Text(preset.iconName)
                    .font(.title)
            }
            
            Text(preset.name)
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
    }
}


#Preview {
    PresetIconView(preset: FocusPreset(name: "Test", iconName: "Study"), isSelected: true)
}
