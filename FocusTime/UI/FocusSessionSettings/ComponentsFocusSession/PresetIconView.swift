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
            Text(preset.iconName) 
                .font(.largeTitle)
                .frame(width: FocusSessionView.Constants.PresetIcon.Layout.size, height: FocusSessionView.Constants.PresetIcon.Layout.size)
                .background(isSelected ? FocusSessionView.Constants.PresetIcon.Colors.selectedBackground : FocusSessionView.Constants.PresetIcon.Colors.background)
                .cornerRadius(FocusSessionView.Constants.PresetIcon.Layout.cornerRadius)
            
            Text(preset.name)
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
        }
    }
}



#Preview {
    PresetIconView(preset: .morningRoutine, isSelected: true)
}
