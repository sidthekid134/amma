//
//  SousChefApp.swift
//  SousChef
//
//  Created by Sid Moparthi on 6/12/25.
//

import SwiftData
import Foundation
import SwiftUI
import Combine

// Shared for both app and preview context
extension ModelContainer {
    static func appContainer(inMemory: Bool = false) -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: inMemory)
        return try! ModelContainer(
            for: SavedImageRecord.self, Recipe.self,
            configurations: config
        )
    }
}

@main
struct SousChefApp: App {
    let dataContainer: ModelContainer = ModelContainer.appContainer()
    
    // Environment object for theme management
    @StateObject private var themeManager = ThemeManager.shared
    
    init() {
        // ThemeManager initialization is handled by the singleton
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(dataContainer)
                .environmentObject(themeManager)
                .task {
                    await RecipeImageProvider.shared.configure(with: dataContainer.mainContext)
                }
                .onReceive(NotificationCenter.default.publisher(for: .themeChanged)) { notification in
                    if let theme = notification.object as? AppTheme {
                        print("App theme changed to: \(theme.displayName)")
                    }
                }
        }
    }
}
