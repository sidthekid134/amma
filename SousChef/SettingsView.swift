//
//  SettingsView.swift
//  SousChef
//
//  Created by Sid Moparthi on 6/12/25.
//

import SwiftUI

struct SettingsView: View {
    // MARK: - Properties
    
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTheme: AppTheme
    
    // MARK: - Initialization
    
    init() {
        _selectedTheme = State(initialValue: ThemeManager.shared.currentTheme)
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Appearance")) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Theme")
                            .font(.body)
                            .foregroundColor(.primary)
                        
                        Picker("Theme", selection: $selectedTheme) {
                            ForEach(AppTheme.allCases, id: \.self) { theme in
                                HStack {
                                    Image(systemName: theme.iconName)
                                    Text(theme.displayName)
                                }
                                .tag(theme)
                                .accessibilityLabel("\(theme.displayName) theme")
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: selectedTheme) { newValue in
                            themeManager.setTheme(newValue)
                            
                            // Haptic feedback when theme changes
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()
                        }
                        .accessibilityLabel("Theme selection")
                        .accessibilityHint("Choose between system, light, or dark theme")
                        
                        // Preview of the selected theme
                        HStack(spacing: 12) {
                            ThemePreviewCard(theme: .light, isSelected: selectedTheme == .light)
                                .accessibilityHidden(true)
                            ThemePreviewCard(theme: .dark, isSelected: selectedTheme == .dark)
                                .accessibilityHidden(true)
                        }
                        .padding(.top, 8)
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.vertical, 8)
                }
                .listRowBackground(Color(UIColor.secondarySystemGroupedBackground))
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
                .listRowBackground(Color(UIColor.secondarySystemGroupedBackground))
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        }
    }
}

// MARK: - Theme Preview Card

struct ThemePreviewCard: View {
    let theme: AppTheme
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 8)
                .fill(theme == .light ? Color.white : Color.black)
                .frame(width: 80, height: 48)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? Color.accentColor : Color.gray.opacity(0.3), lineWidth: isSelected ? 2 : 1)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
            
            Text(theme.displayName)
                .font(.caption)
                .foregroundColor(isSelected ? .accentColor : .secondary)
        }
    }
}

// MARK: - Preview

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(ThemeManager.shared)
    }
}