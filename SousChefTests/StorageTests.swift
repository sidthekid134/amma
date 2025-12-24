import XCTest
@testable import SousChef

final class StorageTests: XCTestCase {
    var storage: UserDefaultsStorage!
    var manager: RecipeStorageManager!
    
    override func setUp() {
        super.setUp()
        storage = UserDefaultsStorage()
        manager = RecipeStorageManager.shared
        
        do {
            try storage.clearAllData()
        } catch {
            XCTFail("Failed to clear storage: \(error)")
        }
    }
    
    override func tearDown() {
        do {
            try storage.clearAllData()
        } catch {
            XCTFail("Failed to clear storage: \(error)")
        }
        super.tearDown()
    }
    
    func testSaveAndFetchRecipe() throws {
        let recipe = createMockRecipe()
        try storage.saveRecipe(recipe)
        
        let fetched = try storage.fetchRecipe(id: recipe.id)
        XCTAssertNotNil(fetched)
        XCTAssertEqual(fetched?.id, recipe.id)
        XCTAssertEqual(fetched?.title, recipe.title)
    }
    
    func testFetchAllRecipes() throws {
        let recipe1 = createMockRecipe(id: "1", title: "Recipe 1")
        let recipe2 = createMockRecipe(id: "2", title: "Recipe 2")
        
        try storage.saveRecipe(recipe1)
        try storage.saveRecipe(recipe2)
        
        let recipes = try storage.fetchAllRecipes()
        XCTAssertEqual(recipes.count, 2)
    }
    
    func testUpdateRecipe() throws {
        var recipe = createMockRecipe()
        try storage.saveRecipe(recipe)
        
        recipe.title = "Updated Title"
        try storage.updateRecipe(recipe)
        
        let updated = try storage.fetchRecipe(id: recipe.id)
        XCTAssertEqual(updated?.title, "Updated Title")
    }
    
    func testDeleteRecipe() throws {
        let recipe = createMockRecipe()
        try storage.saveRecipe(recipe)
        
        try storage.deleteRecipe(id: recipe.id)
        
        let fetched = try storage.fetchRecipe(id: recipe.id)
        XCTAssertNil(fetched)
    }
    
    func testSaveAndFetchCookSession() throws {
        let session = createMockCookSession()
        try storage.saveCookSession(session)
        
        let fetched = try storage.fetchCookSession(id: session.id)
        XCTAssertNotNil(fetched)
        XCTAssertEqual(fetched?.id, session.id)
        XCTAssertEqual(fetched?.recipeId, session.recipeId)
    }
    
    func testSerializationDeserialization() throws {
        let recipe = createMockRecipe()
        try storage.saveRecipe(recipe)
        
        let fetched = try storage.fetchRecipe(id: recipe.id)
        
        XCTAssertEqual(recipe.ingredients.count, fetched?.ingredients.count)
        XCTAssertEqual(recipe.steps.count, fetched?.steps.count)
        XCTAssertEqual(recipe.metadata.cuisine, fetched?.metadata.cuisine)
    }
    
    func testStorageValidation() throws {
        let recipe = createMockRecipe()
        XCTAssertFalse(recipe.id.isEmpty)
        XCTAssertFalse(recipe.title.isEmpty)
        XCTAssertGreater(recipe.steps.count, 0)
    }
    
    func testSeedDataLoading() throws {
        try SeedData.loadAndPersistSeedRecipes(using: storage)
        
        let recipes = try storage.fetchAllRecipes()
        XCTAssertGreater(recipes.count, 0)
        
        let firstRecipe = recipes.first
        XCTAssertNotNil(firstRecipe?.id)
        XCTAssertNotNil(firstRecipe?.title)
    }
    
    func testRecipeStorageManager() throws {
        let recipe = Recipe.mockRecipes[0]
        try manager.saveRecipe(recipe)
        
        let recipes = try manager.getAllRecipes()
        XCTAssertGreater(recipes.count, 0)
    }
    
    func testJSONSerialization() throws {
        let recipe = createMockRecipe()
        try storage.saveRecipe(recipe)
        
        let fetched = try storage.fetchRecipe(id: recipe.id)
        guard let fetched = fetched else {
            XCTFail("Failed to fetch recipe")
            return
        }
        
        let jsonString = try manager.exportRecipeAsJSON(fetched)
        XCTAssertFalse(jsonString.isEmpty)
        
        let importedRecipe = try manager.importRecipeFromJSON(jsonString)
        XCTAssertEqual(importedRecipe.id, recipe.id)
        XCTAssertEqual(importedRecipe.title, recipe.title)
    }
    
    func testBackupRestore() throws {
        let recipe = createMockRecipe()
        try storage.saveRecipe(recipe)
        
        let migration = StorageMigration()
        let backup = try migration.createBackup()
        
        try storage.clearAllData()
        
        try migration.restoreFromBackup(backup)
        
        let recipes = try storage.fetchAllRecipes()
        XCTAssertGreater(recipes.count, 0)
    }
    
    private func createMockRecipe(id: String = "test-1", title: String = "Test Recipe") -> RecipeStorageSchema {
        return RecipeStorageSchema(
            id: id,
            title: title,
            servings: "2",
            totalTimeMinutes: 30,
            activeTimeMinutes: 20,
            passiveTimeMinutes: 10,
            metadata: RecipeMetadataSchema(
                cuisine: "Italian",
                dishType: "Pasta",
                difficultyLevel: "Medium"
            ),
            ingredients: [
                IngredientSchema(name: "Pasta", quantity: "200g", type: "Grain"),
                IngredientSchema(name: "Tomato Sauce", quantity: "400ml", type: "Sauce")
            ],
            steps: [
                StepSchema(
                    stepNumber: 1,
                    title: "Boil Water",
                    equipmentNeeded: ["Pot"],
                    instructions: "Bring water to boil",
                    ingredientsUsed: [],
                    estimatedTimeMinutes: 10,
                    definitionOfDone: "Water is boiling"
                ),
                StepSchema(
                    stepNumber: 2,
                    title: "Cook Pasta",
                    equipmentNeeded: ["Pot"],
                    instructions: "Cook pasta",
                    ingredientsUsed: [IngredientSchema(name: "Pasta", quantity: "200g", type: "Grain")],
                    estimatedTimeMinutes: 10,
                    definitionOfDone: "Pasta is cooked"
                )
            ],
            allEquipmentNeeded: ["Pot"],
            createdAt: ISO8601DateFormatter().string(from: Date())
        )
    }
    
    private func createMockCookSession() -> CookSessionSchema {
        return CookSessionSchema(
            id: UUID().uuidString,
            recipeId: "test-recipe-1",
            startTime: ISO8601DateFormatter().string(from: Date()),
            endTime: nil,
            currentStep: 1,
            notes: "Test session",
            status: "in_progress"
        )
    }
}
