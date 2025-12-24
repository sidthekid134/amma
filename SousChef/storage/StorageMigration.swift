import Foundation

class StorageMigration {
    private let defaults = UserDefaults.standard
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    enum MigrationVersion: Int {
        case v1 = 1
        case v2 = 2
        
        var nextVersion: MigrationVersion? {
            switch self {
            case .v1: return .v2
            case .v2: return nil
            }
        }
    }
    
    func migrateIfNeeded() throws {
        let currentVersion = defaults.integer(forKey: "schema_version")
        let latestVersion = MigrationVersion.v2.rawValue
        
        guard currentVersion < latestVersion else { return }
        
        var version = MigrationVersion(rawValue: currentVersion) ?? .v1
        
        while let nextVersion = version.nextVersion {
            try performMigration(from: version, to: nextVersion)
            version = nextVersion
        }
        
        defaults.set(latestVersion, forKey: "schema_version")
        defaults.synchronize()
    }
    
    private func performMigration(from: MigrationVersion, to: MigrationVersion) throws {
        switch (from, to) {
        case (.v1, .v2):
            try migrateV1ToV2()
        default:
            break
        }
    }
    
    private func migrateV1ToV2() throws {
        guard let data = defaults.data(forKey: "recipes_storage") else { return }
        
        do {
            var recipes = try decoder.decode([RecipeStorageSchema].self, from: data)
            
            for i in 0..<recipes.count {
                let dateFormatter = ISO8601DateFormatter()
                if recipes[i].createdAt.isEmpty || recipes[i].createdAt == "" {
                    recipes[i].createdAt = dateFormatter.string(from: Date())
                }
            }
            
            let updatedData = try encoder.encode(recipes)
            defaults.set(updatedData, forKey: "recipes_storage")
            defaults.synchronize()
        } catch {
            throw StorageValidationError.decodingError(error.localizedDescription)
        }
    }
    
    func createBackup() throws -> Data {
        var backup: [String: Any] = [:]
        
        if let recipesData = defaults.data(forKey: "recipes_storage") {
            backup["recipes"] = recipesData
        }
        
        if let sessionsData = defaults.data(forKey: "cook_sessions_storage") {
            backup["sessions"] = sessionsData
        }
        
        let jsonData = try JSONSerialization.data(withJSONObject: backup)
        return jsonData
    }
    
    func restoreFromBackup(_ data: Data) throws {
        guard let backup = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw StorageValidationError.decodingError("Invalid backup format")
        }
        
        if let recipesData = backup["recipes"] as? Data {
            defaults.set(recipesData, forKey: "recipes_storage")
        }
        
        if let sessionsData = backup["sessions"] as? Data {
            defaults.set(sessionsData, forKey: "cook_sessions_storage")
        }
        
        defaults.synchronize()
    }
}
