import Foundation

struct RecipeStorageSchema: Codable {
    let id: String
    let title: String
    let servings: String
    let totalTimeMinutes: Int
    let activeTimeMinutes: Int
    let passiveTimeMinutes: Int
    let metadata: RecipeMetadataSchema
    let ingredients: [IngredientSchema]
    let steps: [StepSchema]
    let allEquipmentNeeded: [String]
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, servings, totalTimeMinutes, activeTimeMinutes
        case passiveTimeMinutes, metadata, ingredients, steps
        case allEquipmentNeeded, createdAt
    }
}

struct RecipeMetadataSchema: Codable {
    let cuisine: String
    let dishType: String
    let difficultyLevel: String
}

struct IngredientSchema: Codable {
    let name: String
    let quantity: String
    let type: String
}

struct StepSchema: Codable {
    let stepNumber: Int
    let title: String
    let equipmentNeeded: [String]
    let instructions: String
    let ingredientsUsed: [IngredientSchema]
    let estimatedTimeMinutes: Int
    let definitionOfDone: String
}

struct CookSessionSchema: Codable {
    let id: String
    let recipeId: String
    let startTime: String
    let endTime: String?
    let currentStep: Int
    let notes: String
    let status: String
}

enum StorageValidationError: LocalizedError {
    case invalidRecipeData
    case invalidMetadata
    case invalidIngredient
    case invalidStep
    case invalidCookSession
    case decodingError(String)
    case encodingError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidRecipeData: return "Invalid recipe data"
        case .invalidMetadata: return "Invalid metadata"
        case .invalidIngredient: return "Invalid ingredient"
        case .invalidStep: return "Invalid step"
        case .invalidCookSession: return "Invalid cook session"
        case .decodingError(let msg): return "Decoding error: \(msg)"
        case .encodingError(let msg): return "Encoding error: \(msg)"
        }
    }
}
