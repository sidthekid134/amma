import Foundation

class RecipeStorageManager {
    static let shared = RecipeStorageManager()
    
    private let storage: UserDefaultsStorage
    private let migration: StorageMigration
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private init() {
        self.storage = UserDefaultsStorage()
        self.migration = StorageMigration()
        
        do {
            try self.migration.migrateIfNeeded()
        } catch {
            print("Migration error: \(error.localizedDescription)")
        }
    }
    
    func initializeWithSeedData() async throws {
        try SeedData.loadAndPersistSeedRecipes(using: storage)
    }
    
    func createRecipe(from recipe: Recipe) throws -> RecipeStorageSchema {
        let formatter = ISO8601DateFormatter()
        
        let storageMetadata = RecipeMetadataSchema(
            cuisine: recipe.metadata.cuisine,
            dishType: recipe.metadata.dishType,
            difficultyLevel: recipe.metadata.difficultyLevel
        )
        
        let storageIngredients = recipe.ingredients.map { ingredient in
            IngredientSchema(
                name: ingredient.name,
                quantity: ingredient.quantity,
                type: ingredient.type
            )
        }
        
        let storageSteps = recipe.steps.map { step in
            StepSchema(
                stepNumber: step.stepNumber,
                title: step.title,
                equipmentNeeded: step.equipmentNeeded,
                instructions: step.instructions,
                ingredientsUsed: step.ingredientsUsed.map { ingredient in
                    IngredientSchema(
                        name: ingredient.name,
                        quantity: ingredient.quantity,
                        type: ingredient.type
                    )
                },
                estimatedTimeMinutes: step.estimatedTimeMinutes,
                definitionOfDone: step.definitionOfDone
            )
        }
        
        let storageRecipe = RecipeStorageSchema(
            id: recipe.id,
            title: recipe.title,
            servings: recipe.servings,
            totalTimeMinutes: recipe.totalTimeMinutes,
            activeTimeMinutes: recipe.activeTimeMinutes,
            passiveTimeMinutes: recipe.passiveTimeMinutes,
            metadata: storageMetadata,
            ingredients: storageIngredients,
            steps: storageSteps,
            allEquipmentNeeded: recipe.allEquipmentNeeded,
            createdAt: formatter.string(from: recipe.createdAt)
        )
        
        return storageRecipe
    }
    
    func saveRecipe(_ recipe: Recipe) throws {
        let storageRecipe = try createRecipe(from: recipe)
        try storage.saveRecipe(storageRecipe)
    }
    
    func getRecipe(id: String) throws -> RecipeStorageSchema? {
        return try storage.fetchRecipe(id: id)
    }
    
    func getAllRecipes() throws -> [RecipeStorageSchema] {
        return try storage.fetchAllRecipes()
    }
    
    func updateRecipe(_ recipe: Recipe) throws {
        let storageRecipe = try createRecipe(from: recipe)
        try storage.updateRecipe(storageRecipe)
    }
    
    func deleteRecipe(id: String) throws {
        try storage.deleteRecipe(id: id)
    }
    
    func saveCookSession(recipeId: String, currentStep: Int, notes: String) throws -> CookSessionSchema {
        let formatter = ISO8601DateFormatter()
        let session = CookSessionSchema(
            id: UUID().uuidString,
            recipeId: recipeId,
            startTime: formatter.string(from: Date()),
            endTime: nil,
            currentStep: currentStep,
            notes: notes,
            status: "in_progress"
        )
        try storage.saveCookSession(session)
        return session
    }
    
    func getCookSession(id: String) throws -> CookSessionSchema? {
        return try storage.fetchCookSession(id: id)
    }
    
    func getAllCookSessions() throws -> [CookSessionSchema] {
        return try storage.fetchAllCookSessions()
    }
    
    func updateCookSession(_ session: CookSessionSchema) throws {
        try storage.updateCookSession(session)
    }
    
    func completeCookSession(id: String) throws {
        guard var session = try getCookSession(id: id) else {
            throw StorageValidationError.invalidCookSession
        }
        
        let formatter = ISO8601DateFormatter()
        session.endTime = formatter.string(from: Date())
        try updateCookSession(session)
    }
    
    func deleteCookSession(id: String) throws {
        try storage.deleteCookSession(id: id)
    }
    
    func exportRecipeAsJSON(_ recipe: RecipeStorageSchema) throws -> String {
        let data = try encoder.encode(recipe)
        guard let jsonString = String(data: data, encoding: .utf8) else {
            throw StorageValidationError.encodingError("Failed to convert to string")
        }
        return jsonString
    }
    
    func importRecipeFromJSON(_ jsonString: String) throws -> RecipeStorageSchema {
        guard let data = jsonString.data(using: .utf8) else {
            throw StorageValidationError.decodingError("Invalid JSON string")
        }
        
        do {
            let recipe = try decoder.decode(RecipeStorageSchema.self, from: data)
            return recipe
        } catch {
            throw StorageValidationError.decodingError(error.localizedDescription)
        }
    }
    
    func createBackup() throws -> Data {
        return try migration.createBackup()
    }
    
    func restoreFromBackup(_ data: Data) throws {
        try migration.restoreFromBackup(data)
    }
    
    func clearAllData() throws {
        try storage.clearAllData()
    }
}
