import SwiftUI
import Combine

/// Theme options available in the app
enum AppTheme: String, CaseIterable, Identifiable {
    case light = "Light"
    case dark = "Dark"
    case system = "System"
    
    var id: String { rawValue }
    
    /// Returns the UIUserInterfaceStyle based on the selected theme
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .system: return .unspecified
        }
    }
    
    /// Returns the system image name for the theme option
    var iconName: String {
        switch self {
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        case .system: return "circle.lefthalf.filled"
        }
    }
    
    /// Returns the description for the theme option for accessibility
    var accessibilityDescription: String {
        switch self {
        case .light: return "Light theme with bright background and dark text"
        case .dark: return "Dark theme with dark background and light text"
        case .system: return "Follow system appearance settings"
        }
    }
}

/// Manages app appearance theme settings
class ThemeManager: ObservableObject {
    /// Shared singleton instance
    static let shared = ThemeManager()
    
    /// The UserDefaults key for storing the theme preference
    private let themeKey = "AppThemePreference"
    
    /// Published property that notifies subscribers when theme changes
    @Published var selectedTheme: AppTheme {
        didSet {
            // Save to UserDefaults when theme changes
            UserDefaults.standard.set(selectedTheme.rawValue, forKey: themeKey)
            applyTheme()
        }
    }
    
    /// Private initializer for singleton
    private init() {
        // Load saved theme from UserDefaults or default to system
        if let savedTheme = UserDefaults.standard.string(forKey: themeKey),
           let theme = AppTheme(rawValue: savedTheme) {
            self.selectedTheme = theme
        } else {
            self.selectedTheme = .system
        }
        
        // Apply theme on initialization
        applyTheme()
    }
    
    /// Applies the selected theme to the app
    private func applyTheme() {
        let windows = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
        
        windows?.forEach({ window in
            window.overrideUserInterfaceStyle = selectedTheme.userInterfaceStyle
        })
    }
}