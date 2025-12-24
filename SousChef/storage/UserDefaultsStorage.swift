import Foundation

class UserDefaultsStorage {
    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private let recipeKey = "recipes_storage"
    private let cookSessionKey = "cook_sessions_storage"
    
    enum StorageKey {
        static let recipes = "recipes_storage"
        static let cookSessions = "cook_sessions_storage"
        static let schemaVersion = "schema_version"
    }
    
    init() {
        setupStorage()
    }
    
    private func setupStorage() {
        if defaults.object(forKey: StorageKey.schemaVersion) == nil {
            defaults.set(1, forKey: StorageKey.schemaVersion)
            defaults.synchronize()
        }
    }
    
    func saveRecipe(_ recipe: RecipeStorageSchema) throws {
        var recipes = try fetchAllRecipes()
        recipes.removeAll { $0.id == recipe.id }
        recipes.append(recipe)
        
        do {
            let data = try encoder.encode(recipes)
            defaults.set(data, forKey: StorageKey.recipes)
            defaults.synchronize()
        } catch {
            throw StorageValidationError.encodingError(error.localizedDescription)
        }
    }
    
    func fetchRecipe(id: String) throws -> RecipeStorageSchema? {
        let recipes = try fetchAllRecipes()
        return recipes.first { $0.id == id }
    }
    
    func fetchAllRecipes() throws -> [RecipeStorageSchema] {
        guard let data = defaults.data(forKey: StorageKey.recipes) else {
            return []
        }
        
        do {
            let recipes = try decoder.decode([RecipeStorageSchema].self, from: data)
            return recipes
        } catch {
            throw StorageValidationError.decodingError(error.localizedDescription)
        }
    }
    
    func deleteRecipe(id: String) throws {
        var recipes = try fetchAllRecipes()
        recipes.removeAll { $0.id == id }
        
        do {
            let data = try encoder.encode(recipes)
            defaults.set(data, forKey: StorageKey.recipes)
            defaults.synchronize()
        } catch {
            throw StorageValidationError.encodingError(error.localizedDescription)
        }
    }
    
    func updateRecipe(_ recipe: RecipeStorageSchema) throws {
        try saveRecipe(recipe)
    }
    
    func saveCookSession(_ session: CookSessionSchema) throws {
        var sessions = try fetchAllCookSessions()
        sessions.removeAll { $0.id == session.id }
        sessions.append(session)
        
        do {
            let data = try encoder.encode(sessions)
            defaults.set(data, forKey: StorageKey.cookSessions)
            defaults.synchronize()
        } catch {
            throw StorageValidationError.encodingError(error.localizedDescription)
        }
    }
    
    func fetchCookSession(id: String) throws -> CookSessionSchema? {
        let sessions = try fetchAllCookSessions()
        return sessions.first { $0.id == id }
    }
    
    func fetchAllCookSessions() throws -> [CookSessionSchema] {
        guard let data = defaults.data(forKey: StorageKey.cookSessions) else {
            return []
        }
        
        do {
            let sessions = try decoder.decode([CookSessionSchema].self, from: data)
            return sessions
        } catch {
            throw StorageValidationError.decodingError(error.localizedDescription)
        }
    }
    
    func deleteCookSession(id: String) throws {
        var sessions = try fetchAllCookSessions()
        sessions.removeAll { $0.id == id }
        
        do {
            let data = try encoder.encode(sessions)
            defaults.set(data, forKey: StorageKey.cookSessions)
            defaults.synchronize()
        } catch {
            throw StorageValidationError.encodingError(error.localizedDescription)
        }
    }
    
    func updateCookSession(_ session: CookSessionSchema) throws {
        try saveCookSession(session)
    }
    
    func clearAllData() throws {
        defaults.removeObject(forKey: StorageKey.recipes)
        defaults.removeObject(forKey: StorageKey.cookSessions)
        defaults.synchronize()
    }
    
    func getSchemaVersion() -> Int {
        defaults.integer(forKey: StorageKey.schemaVersion)
    }
}
