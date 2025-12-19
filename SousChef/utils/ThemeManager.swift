//
//  ThemeManager.swift
//  SousChef
//
//  Created by Sid Moparthi on 6/12/25.
//

import SwiftUI
import Combine

/// Represents the available themes for the app
public enum AppTheme: String, CaseIterable {
    /// Light theme
    case light
    /// Dark theme
    case dark
    /// Follow system appearance
    case system
    
    /// Returns the appropriate SwiftUI color scheme based on theme
    public var colorScheme: ColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil // nil means follow system
        }
    }
}

/// Manages the app-wide theme settings with UserDefaults persistence
public class ThemeManager: ObservableObject {
    // UserDefaults key
    private let themeKey = "com.souschef.userThemePreference"
    
    // Published property that will notify subscribers when changed
    @Published public var currentTheme: AppTheme {
        didSet {
            // Save to UserDefaults when changed
            UserDefaults.standard.set(currentTheme.rawValue, forKey: themeKey)
        }
    }
    
    // Singleton instance
    public static let shared = ThemeManager()
    
    // Private initializer to enforce singleton pattern
    private init() {
        // Retrieve saved theme from UserDefaults or default to system
        if let savedThemeRaw = UserDefaults.standard.string(forKey: themeKey),
           let savedTheme = AppTheme(rawValue: savedThemeRaw) {
            self.currentTheme = savedTheme
        } else {
            self.currentTheme = .system
        }
    }
    
    /// Sets the app theme and persists the choice
    /// - Parameter theme: The AppTheme to set
    public func setTheme(_ theme: AppTheme) {
        currentTheme = theme
    }
    
    /// Toggles between light and dark themes
    public func toggleLightDarkTheme() {
        switch currentTheme {
        case .light:
            setTheme(.dark)
        case .dark:
            setTheme(.light)
        case .system:
            // If system, check current device appearance and switch to the opposite
            let currentDeviceAppearance = UITraitCollection.current.userInterfaceStyle
            setTheme(currentDeviceAppearance == .dark ? .light : .dark)
        }
    }
}