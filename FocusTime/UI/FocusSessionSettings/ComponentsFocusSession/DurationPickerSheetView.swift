//
//  DurationPickerSheetView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 17.06.25.
//

import SwiftUI
import FocusTimeUI

struct DurationPickerSheetView: View {
    

    @Binding var hours: Int
    @Binding var minutes: Int
    

    
    var body: some View {
        VStack(spacing: 16) {

            Capsule()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 40, height: 5)
                .padding(.top, 8)
            

            Text("Session Length")
                .font(.headline)
                .foregroundStyle(Color.blue)
            
            Text("Choose how long you want to stay focused")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom)
            

            
            durationPicker
                .padding(.bottom)
            

            
            
        }
        .frame(maxWidth: .infinity)
        .background(Color(red: 0.1, green: 0.1, blue: 0.12))
        
        .foregroundColor(.white)
    }
    
    private var durationPicker: some View {
        HStack(spacing: 0) {
            Picker("Hours", selection: $hours) {
                ForEach(0..<24) { hour in
                    Text("\(hour)").tag(hour)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: 70)
            .clipped()
            
            Picker("Minutes", selection: $minutes) {
                ForEach(0..<60) { minute in
                    Text("\(minute)").tag(minute)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: 70)
            .clipped()
        }
    }
}
