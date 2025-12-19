//
//  ThemeSettingsView.swift
//  SousChef
//
//  Created by Sid Moparthi on 6/12/25.
//

import SwiftUI

struct ThemeSettingsView: View {
    @Environment(\.themeManager) private var themeManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Appearance")) {
                    Picker("Theme", selection: $themeManager.currentTheme) {
                        Text("Light").tag(AppTheme.light)
                        Text("Dark").tag(AppTheme.dark)
                        Text("System").tag(AppTheme.system)
                    }
                    .pickerStyle(.inline)
                }
                
                Section {
                    HStack {
                        Text("Current Theme")
                        Spacer()
                        Text(themeManager.currentTheme.rawValue.capitalized)
                            .foregroundColor(.secondary)
                    }
                    
                    Button("Toggle Dark/Light") {
                        themeManager.toggleLightDarkTheme()
                    }
                }
                
                Section(footer: Text("Theme changes apply immediately across the entire app and persist between launches.")) {
                    Button("Close") {
                        dismiss()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Theme Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ThemeSettingsView()
}