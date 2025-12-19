//
//  ThemeEnvironment.swift
//  SousChef
//
//  Created by Sid Moparthi on 6/12/25.
//

import SwiftUI

// Define the environment key for the theme manager
private struct ThemeManagerKey: EnvironmentKey {
    static let defaultValue = ThemeManager.shared
}

// Extend the Environment values to include our theme manager
extension EnvironmentValues {
    var themeManager: ThemeManager {
        get { self[ThemeManagerKey.self] }
        set { self[ThemeManagerKey.self] = newValue }
    }
}

// Extension to provide easy access to the theme manager from Views
extension View {
    /// Apply the current theme to this view
    /// - Returns: A view with the applied theme preference
    func applyTheme() -> some View {
        self.modifier(ThemeModifier())
    }
}

// A modifier that applies the theme preference
struct ThemeModifier: ViewModifier {
    @ObservedObject private var themeManager = ThemeManager.shared
    
    func body(content: Content) -> some View {
        content
            .preferredColorScheme(themeManager.currentTheme.colorScheme)
    }
}