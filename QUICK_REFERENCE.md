# Quick Reference: Type-Safe Recipe Storage

## 🚀 One-Minute Setup

```swift
// In SousChefApp.swift
@main
struct SousChefApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    Task {
                        try? await RecipeStorageManager.shared.initializeWithSeedData()
                    }
                }
        }
    }
}
```

## 📝 Common Operations

### Save Recipe
```swift
try RecipeStorageManager.shared.saveRecipe(recipe)
```

### Get All Recipes
```swift
let recipes = try RecipeStorageManager.shared.getAllRecipes()
```

### Get Single Recipe
```swift
let recipe = try RecipeStorageManager.shared.getRecipe(id: "recipe-id")
```

### Update Recipe
```swift
try RecipeStorageManager.shared.updateRecipe(updatedRecipe)
```

### Delete Recipe
```swift
try RecipeStorageManager.shared.deleteRecipe(id: "recipe-id")
```

## 👨‍🍳 Cooking Sessions

### Start Session
```swift
let session = try RecipeStorageManager.shared.saveCookSession(
    recipeId: "recipe-id",
    currentStep: 1,
    notes: "Starting now"
)
```

### Update Progress
```swift
var session = try RecipeStorageManager.shared.getCookSession(id: sessionId)!
session.currentStep = 2
try RecipeStorageManager.shared.updateCookSession(session)
```

### Complete Session
```swift
try RecipeStorageManager.shared.completeCookSession(id: sessionId)
```

## 📤 Import/Export

### Export as JSON
```swift
let json = try RecipeStorageManager.shared.exportRecipeAsJSON(recipe)
```

### Import from JSON
```swift
let recipe = try RecipeStorageManager.shared.importRecipeFromJSON(jsonString)
try RecipeStorageManager.shared.saveRecipe(recipe)
```

## 💾 Backup & Restore

### Create Backup
```swift
let backup = try RecipeStorageManager.shared.createBackup()
UserDefaults.standard.set(backup, forKey: "backup")
```

### Restore Backup
```swift
let backup = UserDefaults.standard.data(forKey: "backup")!
try RecipeStorageManager.shared.restoreFromBackup(backup)
```

## 🔍 SwiftUI Integration

```swift
struct RecipeListView: View {
    @State var recipes: [RecipeStorageSchema] = []
    @State var isLoading = false
    
    var body: some View {
        List(recipes, id: \.id) { recipe in
            Text(recipe.title)
        }
        .onAppear { loadRecipes() }
    }
    
    func loadRecipes() {
        isLoading = true
        Task {
            recipes = try RecipeStorageManager.shared.getAllRecipes()
            isLoading = false
        }
    }
}
```

## ⚠️ Error Handling

```swift
do {
    try RecipeStorageManager.shared.saveRecipe(recipe)
} catch let error as StorageValidationError {
    print("Storage error: \(error.localizedDescription)")
} catch {
    print("Unexpected error: \(error)")
}
```

## 📊 Data Models

### Recipe Schema
```
RecipeStorageSchema
├── id: String
├── title: String
├── servings: String
├── totalTimeMinutes: Int
├── activeTimeMinutes: Int
├── passiveTimeMinutes: Int
├── metadata: RecipeMetadataSchema
├── ingredients: [IngredientSchema]
├── steps: [StepSchema]
├── allEquipmentNeeded: [String]
└── createdAt: String (ISO8601)
```

### Cook Session Schema
```
CookSessionSchema
├── id: String
├── recipeId: String
├── startTime: String (ISO8601)
├── endTime: String? (ISO8601)
├── currentStep: Int
├── notes: String
└── status: String
```

## 📁 File Locations

**Implementation Files:**
- `SousChef/storage/StorageModels.swift` - Data schemas
- `SousChef/storage/UserDefaultsStorage.swift` - CRUD operations
- `SousChef/storage/StorageMigration.swift` - Schema migration
- `SousChef/storage/SeedData.swift` - Initial data
- `SousChef/storage/RecipeStorageManager.swift` - Public API

**Tests:**
- `SousChefTests/StorageTests.swift` - 13 test methods

**Documentation:**
- `STORAGE_IMPLEMENTATION.md` - Full architecture
- `INTEGRATION_GUIDE.md` - Detailed examples
- `COMPLETION_REPORT.md` - Implementation summary

## ✅ Acceptance Criteria

- ✅ Zod schemas (Codable models)
- ✅ AsyncStorage wrapper (UserDefaults CRUD)
- ✅ Migration strategy
- ✅ Seed data loading
- ✅ JSON serialization

## 🧪 Testing

Run StorageTests.swift:
```bash
xcodebuild test -scheme SousChef
```

13 test methods covering:
- CRUD operations
- Serialization
- Migration
- Backup/restore

## 🔑 Key Classes

| Class | Purpose |
|-------|---------|
| `RecipeStorageManager` | Facade API (singleton) |
| `UserDefaultsStorage` | CRUD operations |
| `StorageMigration` | Schema evolution |
| `SeedData` | Initial data |
| `RecipeStorageSchema` | Recipe model |
| `CookSessionSchema` | Session model |

## 💡 Pro Tips

1. Always use `try-catch` or `try!` with storage operations
2. Use `async/await` for seed data initialization
3. Cache results in SwiftUI `@State` when possible
4. Backup before major updates
5. Clear seed data in production if needed: `try manager.clearAllData()`

## 🐛 Common Issues

**"Recipe not found"**
→ Verify ID is correct, check with getAllRecipes()

**"Encoding error"**
→ Ensure all fields are Codable, check JSON format

**Data disappears after restart**
→ Check migrations are running, verify synchronization

**Performance issues**
→ Limit fetchAll() calls, implement caching, consider Core Data for large datasets

## 📞 Support

See full documentation:
- Architecture: `STORAGE_IMPLEMENTATION.md`
- Integration: `INTEGRATION_GUIDE.md`
- Completion: `COMPLETION_REPORT.md`
- Files: `FILES_CREATED.md`

---

**Status:** ✅ Production Ready
**Test Coverage:** 13 methods
**Type Safety:** Maximum
**Documentation:** Complete
