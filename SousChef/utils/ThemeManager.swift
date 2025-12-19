//
//  ThemeManager.swift
//  SousChef
//
//  Created by Sid Moparthi on 6/12/25.
//

import SwiftUI
import Combine

/// Enum representing the available theme options
public enum AppTheme: Int, CaseIterable {
    case system = 0
    case light = 1
    case dark = 2
    
    /// Convert theme to UIUserInterfaceStyle
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .system:
            return .unspecified
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
    
    /// Display name for the theme
    var displayName: String {
        switch self {
        case .system:
            return "System"
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }
    
    /// System image name for the theme
    var iconName: String {
        switch self {
        case .system:
            return "gear"
        case .light:
            return "sun.max.fill"
        case .dark:
            return "moon.fill"
        }
    }
}

/// Singleton class to manage app theme
public class ThemeManager: ObservableObject {
    // MARK: - Properties
    
    /// Singleton instance
    public static let shared = ThemeManager()
    
    /// Published property for current theme
    @Published public private(set) var currentTheme: AppTheme
    
    /// UserDefaults key for theme storage
    private let themeKey = "com.souschef.userTheme"
    
    // MARK: - Initialization
    
    private init() {
        // Load saved theme from UserDefaults or use system default
        let savedThemeRawValue = UserDefaults.standard.integer(forKey: themeKey)
        
        if let savedTheme = AppTheme(rawValue: savedThemeRawValue) {
            self.currentTheme = savedTheme
        } else {
            self.currentTheme = .system // Default to system theme
        }
        
        // Apply the theme immediately on initialization
        applyTheme(currentTheme)
    }
    
    // MARK: - Public Methods
    
    /// Set a new theme and persist it to UserDefaults
    /// - Parameter theme: The theme to apply
    public func setTheme(_ theme: AppTheme) {
        currentTheme = theme
        
        // Save to UserDefaults
        UserDefaults.standard.set(theme.rawValue, forKey: themeKey)
        
        // Apply the theme
        applyTheme(theme)
    }
    
    /// Apply the specified theme to the app
    /// - Parameter theme: The theme to apply
    private func applyTheme(_ theme: AppTheme) {
        // Set app-wide appearance
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = theme.userInterfaceStyle
            }
        }
        
        // Post notification for theme change
        NotificationCenter.default.post(name: .themeChanged, object: theme)
    }
}

// MARK: - Notification Name Extension
extension Notification.Name {
    /// Notification sent when the app theme changes
    static let themeChanged = Notification.Name("com.souschef.themeChanged")
}