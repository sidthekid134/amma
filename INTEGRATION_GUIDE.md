# Integration Guide: Recipe Storage System

## Quick Integration Steps

### Step 1: Import the Storage Module
```swift
import Foundation
// Already available in SousChef project
```

### Step 2: Access the Shared Manager
```swift
let storageManager = RecipeStorageManager.shared
```

### Step 3: Initialize App Storage
In `SousChefApp.swift`:

```swift
import SwiftUI

@main
struct SousChefApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    initializeStorage()
                }
        }
    }
    
    private func initializeStorage() {
        Task {
            do {
                try await RecipeStorageManager.shared.initializeWithSeedData()
                print("✅ Storage initialized with seed data")
            } catch {
                print("❌ Failed to initialize storage: \(error)")
            }
        }
    }
}
```

## Common Operations

### Save a Recipe
```swift
let recipe = Recipe(
    id: UUID().uuidString,
    title: "My Recipe",
    servings: "4",
    totalTimeMinutes: 60,
    activeTimeMinutes: 40,
    passiveTimeMinutes: 20,
    metadata: RecipeMetadata(
        cuisine: "Italian",
        dishType: "Pasta",
        difficultyLevel: "Medium"
    ),
    ingredients: [...],
    steps: [...],
    allEquipmentNeeded: [...],
    createdAt: Date()
)

do {
    try RecipeStorageManager.shared.saveRecipe(recipe)
    print("✅ Recipe saved")
} catch {
    print("❌ Failed to save recipe: \(error)")
}
```

### Retrieve All Recipes
```swift
do {
    let recipes = try RecipeStorageManager.shared.getAllRecipes()
    print("✅ Loaded \(recipes.count) recipes")
    for recipe in recipes {
        print("- \(recipe.title)")
    }
} catch {
    print("❌ Failed to load recipes: \(error)")
}
```

### Get Single Recipe
```swift
do {
    if let recipe = try RecipeStorageManager.shared.getRecipe(id: "recipe-id") {
        print("✅ Found recipe: \(recipe.title)")
    } else {
        print("⚠️ Recipe not found")
    }
} catch {
    print("❌ Error loading recipe: \(error)")
}
```

### Update Recipe
```swift
do {
    if var recipe = try RecipeStorageManager.shared.getRecipe(id: "recipe-id") {
        recipe.title = "Updated Title"
        try RecipeStorageManager.shared.updateRecipe(recipe)
        print("✅ Recipe updated")
    }
} catch {
    print("❌ Failed to update recipe: \(error)")
}
```

### Delete Recipe
```swift
do {
    try RecipeStorageManager.shared.deleteRecipe(id: "recipe-id")
    print("✅ Recipe deleted")
} catch {
    print("❌ Failed to delete recipe: \(error)")
}
```

## Cooking Session Management

### Start a Cooking Session
```swift
do {
    let session = try RecipeStorageManager.shared.saveCookSession(
        recipeId: "recipe-id",
        currentStep: 1,
        notes: "Starting to cook"
    )
    print("✅ Session started: \(session.id)")
    sessionId = session.id
} catch {
    print("❌ Failed to start session: \(error)")
}
```

### Update Progress
```swift
do {
    if var session = try RecipeStorageManager.shared.getCookSession(id: sessionId) {
        session.currentStep = 2
        session.notes = "Currently on step 2"
        try RecipeStorageManager.shared.updateCookSession(session)
        print("✅ Progress updated to step 2")
    }
} catch {
    print("❌ Failed to update session: \(error)")
}
```

### Complete Session
```swift
do {
    try RecipeStorageManager.shared.completeCookSession(id: sessionId)
    print("✅ Session completed")
} catch {
    print("❌ Failed to complete session: \(error)")
}
```

### Get Session History
```swift
do {
    let sessions = try RecipeStorageManager.shared.getAllCookSessions()
    for session in sessions {
        print("- Recipe: \(session.recipeId), Status: \(session.status)")
    }
} catch {
    print("❌ Failed to load sessions: \(error)")
}
```

## Data Import/Export

### Export Recipe to JSON
```swift
do {
    if let recipe = try RecipeStorageManager.shared.getRecipe(id: "recipe-id") {
        let jsonString = try RecipeStorageManager.shared.exportRecipeAsJSON(recipe)
        // Save to file or send to server
        print("✅ Recipe exported as JSON")
        print(jsonString)
    }
} catch {
    print("❌ Failed to export recipe: \(error)")
}
```

### Import Recipe from JSON
```swift
let jsonString = """
{
  "id": "imported-1",
  "title": "Imported Recipe",
  "servings": "4",
  ...
}
"""

do {
    let recipe = try RecipeStorageManager.shared.importRecipeFromJSON(jsonString)
    try RecipeStorageManager.shared.saveRecipe(recipe)
    print("✅ Recipe imported successfully")
} catch {
    print("❌ Failed to import recipe: \(error)")
}
```

## Backup and Restore

### Create Backup
```swift
do {
    let backupData = try RecipeStorageManager.shared.createBackup()
    // Save backupData to file or send to cloud
    UserDefaults.standard.set(backupData, forKey: "recipe_backup")
    print("✅ Backup created")
} catch {
    print("❌ Failed to create backup: \(error)")
}
```

### Restore from Backup
```swift
do {
    if let backupData = UserDefaults.standard.data(forKey: "recipe_backup") {
        try RecipeStorageManager.shared.restoreFromBackup(backupData)
        print("✅ Data restored from backup")
    }
} catch {
    print("❌ Failed to restore from backup: \(error)")
}
```

## Error Handling

### Handle Storage Errors
```swift
do {
    try RecipeStorageManager.shared.saveRecipe(recipe)
} catch let error as StorageValidationError {
    switch error {
    case .invalidRecipeData:
        print("Invalid recipe data provided")
    case .decodingError(let msg):
        print("Failed to decode: \(msg)")
    case .encodingError(let msg):
        print("Failed to encode: \(msg)")
    default:
        print("Storage error: \(error.localizedDescription)")
    }
} catch {
    print("Unexpected error: \(error)")
}
```

## SwiftUI Integration Example

```swift
struct RecipeListView: View {
    @State private var recipes: [RecipeStorageSchema] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView()
                } else if let errorMessage = errorMessage {
                    VStack {
                        Text("Error: \(errorMessage)")
                        Button("Retry") { loadRecipes() }
                    }
                } else {
                    List(recipes, id: \.id) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                            VStack(alignment: .leading) {
                                Text(recipe.title)
                                    .font(.headline)
                                Text("\(recipe.servings) servings • \(recipe.totalTimeMinutes) min")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .navigationTitle("Recipes")
                    .toolbar {
                        Button(action: { addRecipe() }) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .onAppear { loadRecipes() }
        }
    }
    
    private func loadRecipes() {
        isLoading = true
        Task {
            do {
                recipes = try RecipeStorageManager.shared.getAllRecipes()
                errorMessage = nil
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
    
    private func addRecipe() {
        // Navigation to add recipe view
    }
}
```

## Best Practices

### 1. Always Use Try-Catch
```swift
do {
    // Storage operation
} catch {
    // Handle error appropriately
}
```

### 2. Use Async/Await for Large Operations
```swift
Task {
    do {
        try await RecipeStorageManager.shared.initializeWithSeedData()
    } catch {
        print("Error: \(error)")
    }
}
```

### 3. Validate Data Before Saving
```swift
func validateRecipe(_ recipe: Recipe) -> Bool {
    return !recipe.id.isEmpty &&
           !recipe.title.isEmpty &&
           !recipe.steps.isEmpty
}
```

### 4. Cache Results When Appropriate
```swift
@State private var cachedRecipes: [RecipeStorageSchema]?

func getRecipes() async throws -> [RecipeStorageSchema] {
    if let cached = cachedRecipes {
        return cached
    }
    let recipes = try RecipeStorageManager.shared.getAllRecipes()
    cachedRecipes = recipes
    return recipes
}
```

### 5. Handle Threading Properly
```swift
DispatchQueue.main.async {
    self.recipes = loadedRecipes
}
```

## Testing Your Integration

```swift
class RecipeStorageIntegrationTests: XCTestCase {
    func testFullWorkflow() throws {
        let manager = RecipeStorageManager.shared
        
        // 1. Create
        let recipe = createMockRecipe()
        try manager.saveRecipe(recipe)
        
        // 2. Read
        let fetched = try manager.getRecipe(id: recipe.id)
        XCTAssertEqual(fetched?.title, recipe.title)
        
        // 3. Update
        var updated = fetched!
        updated.title = "Updated"
        // Create new recipe with updated title
        
        // 4. Delete
        try manager.deleteRecipe(id: recipe.id)
        let deleted = try manager.getRecipe(id: recipe.id)
        XCTAssertNil(deleted)
    }
}
```

## Troubleshooting

### Issue: "Recipe not found"
- Ensure recipe ID is correct
- Check if data was persisted (verify with getAllRecipes)
- Clear storage and reload: `try RecipeStorageManager.shared.clearAllData()`

### Issue: "Encoding/Decoding error"
- Verify all model properties are Codable
- Check JSON format if importing
- Look at error message for specific field causing issue

### Issue: Data loss after app restart
- Ensure migrations are up to date
- Check UserDefaults synchronization
- Create backup before making schema changes

### Issue: Large memory usage
- Limit fetchAll() calls for large datasets
- Implement pagination for recipe lists
- Cache results in views

## Migration to Core Data (Future)

When ready to migrate to Core Data:

1. Existing `RecipeStorageSchema` can become Core Data entities
2. Keep `RecipeStorageManager` interface same for backward compatibility
3. Implement Core Data stack alongside UserDefaults
4. Gradually migrate data

---

**Version:** 1.0
**Last Updated:** December 24, 2025
**Status:** Production Ready
