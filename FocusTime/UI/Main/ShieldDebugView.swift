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
            // MARK: - Status
            VStack(alignment: .leading) {
                Text("Is blocked: \(viewModel.shieldManager.isShieldActive)")
                Text("Apps chosen: \(viewModel.state.selection.applicationTokens.count)")
                Text("Categories chosen: \(viewModel.state.selection.categoryTokens.count)")
            }
            
            // MARK: - Controls
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
                Button("Toggle selection sheet") {
                    Task {
                        await viewModel.toggleSelectionSheet()
                    }
                }
                .buttonStyle(.bordered)
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
    }
    
    init(viewModel: ShieldDebugViewModel = ShieldDebugViewModel()) {
        self.viewModel = viewModel
    }
}

#Preview {
    ShieldDebugView()
}
