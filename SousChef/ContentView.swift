//
//  ContentView.swift
//  SousChef
//
//  Created by Sid Moparthi on 6/12/25.
//

import SwiftUI
import SwiftData
import os

struct ContentView: View {
    
    enum RecipeFilter: Hashable {
        case all
        case favorites
    }
    
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var themeManager: ThemeManager
    @Query private var recipes: [Recipe]
    
    @State private var selectedFilter: RecipeFilter = .all
    @State private var showingAddRecipe = false
    @State private var selectedRecipe: Recipe?
    @State private var sortAscending = true
    @State private var splitViewVisibility: NavigationSplitViewVisibility = .doubleColumn
    @State private var didLoadMockData = false
    @State private var showingSettings = false
    
    var filteredRecipes: [Recipe] {
        print("recipes - \(recipes.count)")
        let recipeSource = recipes
        let filtered: [Recipe]
        switch selectedFilter {
        case .all:
            filtered = recipeSource
        case .favorites:
            // Uncomment the following line if 'isFavorite' exists on Recipe:
            // filtered = recipeSource.filter { $0.isFavorite }
            filtered = []
        }
        return filtered.sorted { sortAscending ? $0.title < $1.title : $0.title > $1.title }
    }
    
    var body: some View {
        NavigationSplitView(columnVisibility: $splitViewVisibility) {
            List() {
                Label("All Recipes", systemImage: "tray.and.arrow.down.fill")
                    .tag(RecipeFilter.all)
                Label("Favorites", systemImage: "star.fill")
                    .tag(RecipeFilter.favorites)
            }
            .listStyle(SidebarListStyle())
        } content: {
            VStack {
                List(filteredRecipes, id: \.id) { recipe in
                    Button(action: { selectedRecipe = recipe }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(selectedRecipe?.id == recipe.id ? Color.accentColor.opacity(0.15) : Color.clear)
                            HStack {
                                Text(recipe.title)
                                    .foregroundColor(selectedRecipe?.id == recipe.id ? .accentColor : .primary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 4)
                        }
                    }
                    .buttonStyle(.plain)
                }
                .toolbar {
                    ToolbarItemGroup {
                        Menu {
                            Button(action: { selectedFilter = .all }) {
                                Label("All Recipes", systemImage: "tray.and.arrow.down.fill")
                            }
                            Button(action: { selectedFilter = .favorites }) {
                                Label("Favorites", systemImage: "star.fill")
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                        }
                        Menu {
                            Button(action: { sortAscending = true }) {
                                Label("Title Ascending", systemImage: "arrow.up")
                            }
                            Button(action: { sortAscending = false }) {
                                Label("Title Descending", systemImage: "arrow.down")
                            }
                        } label: {
                            Image(systemName: "arrow.up.arrow.down.circle")
                        }
                        Button {
                            showingSettings = true
                        } label: {
                            Image(systemName: "gearshape.fill")
                        }
                    }
                    ToolbarSpacer(.fixed)
                    ToolbarItem {
                        Button {
                            showingAddRecipe = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        } detail: {
            if let recipe = selectedRecipe {
                RecipeDetailView(
                    selectedRecipe: $selectedRecipe,
                    recipe: recipe
                )
            } else {
                Text("Select a recipe to see details")
                    .foregroundColor(.secondary)
            }
        }
        .sheet(isPresented: $showingAddRecipe) {
            AddRecipeView()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .task {
            if !didLoadMockData && recipes.isEmpty {
                for mock in Recipe.mockRecipes {
                    let newRecipe = Recipe(
                        id: UUID().uuidString,
                        title: mock.title,
                        servings: mock.servings,
                        totalTimeMinutes: mock.totalTimeMinutes,
                        activeTimeMinutes: mock.activeTimeMinutes,
                        passiveTimeMinutes: mock.passiveTimeMinutes,
                        metadata: RecipeMetadata(
                            cuisine: mock.metadata.cuisine,
                            dishType: mock.metadata.dishType,
                            difficultyLevel: mock.metadata.difficultyLevel
                        ),
                        ingredients: mock.ingredients.map { RecipeIngredient(name: $0.name, quantity: $0.quantity, type: $0.type) },
                        steps: mock.steps.map { step in
                            RecipeStep(
                                stepNumber: step.stepNumber,
                                title: step.title,
                                equipmentNeeded: step.equipmentNeeded,
                                instructions: step.instructions,
                                ingredientsUsed: step.ingredientsUsed.map {
                                    RecipeIngredient(name: $0.name, quantity: $0.quantity, type: $0.type)
                                },
                                estimatedTimeMinutes: step.estimatedTimeMinutes,
                                definitionOfDone: step.definitionOfDone
                            )
                        },
                        allEquipmentNeeded: mock.allEquipmentNeeded,
                        createdAt: mock.createdAt
                    )
                    modelContext.insert(newRecipe)
                }
                didLoadMockData = true
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(ModelContainer.appContainer(inMemory: false))
        .environmentObject(ThemeManager.shared)
}
