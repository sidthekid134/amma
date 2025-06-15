//
//  SousChefApp.swift
//  SousChef
//
//  Created by Sid Moparthi on 6/12/25.
//

import SwiftData
import Foundation
import SwiftUI

@main
struct SousChefApp: App {
    let dataContainer: ModelContainer = {
        try! ModelContainer(
            for: SavedImageRecord.self,
            configurations: ModelConfiguration()
        )
    }()
    


    var body: some Scene {
        WindowGroup {
            ContentView().modelContainer(dataContainer).task {
                await RecipeImageProvider.shared.configure(with: dataContainer.mainContext)
            }
        }
        
    }
}
