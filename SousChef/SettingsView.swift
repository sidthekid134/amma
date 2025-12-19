import SwiftUI

struct SettingsView: View {
    @ObservedObject private var themeManager = ThemeManager.shared
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Form {
            Section(header: Text("Appearance")) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Theme")
                        .font(.headline)
                    
                    Picker("Theme Mode", selection: $themeManager.selectedTheme) {
                        ForEach(AppTheme.allCases) { theme in
                            HStack {
                                Image(systemName: theme.iconName)
                                    .foregroundColor(themeColor(for: theme))
                                Text(theme.rawValue)
                            }
                            .tag(theme)
                            .accessibilityLabel(theme.rawValue)
                            .accessibilityHint(theme.accessibilityDescription)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Text("Customize how SousChef appears on your device")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                }
                .padding(.vertical, 8)
            }
            
            Section {
                // App version info
                HStack {
                    Text("Version")
                    Spacer()
                    Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0")
                        .foregroundColor(.secondary)
                }
                
                // Build number
                HStack {
                    Text("Build")
                    Spacer()
                    Text(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1")
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Settings")
    }
    
    // Returns a color for the theme icon based on the theme and current color scheme
    private func themeColor(for theme: AppTheme) -> Color {
        switch theme {
        case .light:
            return .yellow
        case .dark:
            return .indigo
        case .system:
            // Dynamically change color based on current system appearance
            return colorScheme == .dark ? .purple : .blue
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}