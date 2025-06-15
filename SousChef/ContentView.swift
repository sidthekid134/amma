//
//  ContentView.swift
//  SousChef
//
//  Created by Sid Moparthi on 6/12/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    enum RecipeFilter: Hashable {
        case all
        case favorites
    }
    
    @State private var recipes: [Recipe] = Recipe.mockRecipes
    @State private var selectedFilter: RecipeFilter = .all
    @State private var showingAddRecipe = false
    @State private var selectedRecipe: Recipe?
    @State private var sortAscending = true
    @State private var splitViewVisibility: NavigationSplitViewVisibility = .doubleColumn
    
    var filteredRecipes: [Recipe] {
        let filtered: [Recipe]
        switch selectedFilter {
        case .all:
            filtered = recipes
        case .favorites:
            // Uncomment the following line if 'isFavorite' exists on Recipe:
            // filtered = recipes.filter { $0.isFavorite }
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
                    ToolbarItem(placement: .navigationBarTrailing) {
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
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
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
                    }
                }
            }
        } detail: {
            if let recipe = selectedRecipe {
                RecipeDetailView(recipe: recipe)
            } else {
                Text("Select a recipe to see details")
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    ContentView()
}
