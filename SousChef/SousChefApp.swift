//
//  SousChefApp.swift
//  SousChef
//
//  Created by Sid Moparthi on 6/12/25.
//

import SwiftData
import Foundation
import SwiftUI

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
    @ObservedObject private var themeManager = ThemeManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(dataContainer)
                .task {
                    await RecipeImageProvider.shared.configure(with: dataContainer.mainContext)
                }
                .applyTheme()
                .environment(\.themeManager, themeManager)
        }
    }
}
