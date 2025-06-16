import Foundation
import FoundationModels

/// Represents a full recipe with metadata, ingredients, and steps
@Generable
public struct RecipeEntityLLM: Identifiable {
    @Guide(description: "Unique identifier for the recipe")
    public var id: String
    
    @Guide(description: "Title of the recipe")
    public var title: String
    
    @Guide(description: "Number of servings, e.g., '4 servings'")
    public var servings: String
    
    @Guide(description: "Total time required (in minutes)")
    public var totalTimeMinutes: Int
    
    @Guide(description: "Active time required (in minutes)")
    public var activeTimeMinutes: Int
    
    @Guide(description: "Passive time required (in minutes)")
    public var passiveTimeMinutes: Int
    
    @Guide(description: "Metadata including cuisine, dish type, and difficulty level")
    public var metadata: RecipeMetadataEntityLLM
    
    @Guide(description: "List of ingredients required for the recipe")
    public var ingredients: [RecipeIngredientEntityLLM]
    
    @Guide(description: "Ordered list of preparation steps")
    public var steps: [RecipeStepEntityLLM]
    
    @Guide(description: "All equipment needed to prepare the recipe")
    public var allEquipmentNeeded: [String]
    
    @Guide(description: "Date the recipe was created (ISO 8601 string)")
    public var createdAt: String
    
    public init(
        id: String,
        title: String,
        servings: String,
        totalTimeMinutes: Int,
        activeTimeMinutes: Int,
        passiveTimeMinutes: Int,
        metadata: RecipeMetadataEntityLLM,
        ingredients: [RecipeIngredientEntityLLM],
        steps: [RecipeStepEntityLLM],
        allEquipmentNeeded: [String],
        createdAt: String = ISO8601DateFormatter().string(from: Date())
    ) {
        self.id = id
        self.title = title
        self.servings = servings
        self.totalTimeMinutes = totalTimeMinutes
        self.activeTimeMinutes = activeTimeMinutes
        self.passiveTimeMinutes = passiveTimeMinutes
        self.metadata = metadata
        self.ingredients = ingredients
        self.steps = steps
        self.allEquipmentNeeded = allEquipmentNeeded
        self.createdAt = createdAt
    }
}

/// Metadata for a recipe
@Generable
public struct RecipeMetadataEntityLLM: Identifiable {
    @Guide(description: "Unique identifier for the recipe metadata")
    public var id: String

    @Guide(description: "Cuisine type, e.g., 'Italian', 'Mexican'")
    public var cuisine: String
    
    @Guide(description: "Dish category, e.g., 'Main Course', 'Dessert'")
    public var dishType: String
    
    @Guide(description: "Difficulty level, e.g., 'Easy', 'Intermediate', 'Hard'")
    public var difficultyLevel: String
    
    public init(id: String, cuisine: String, dishType: String, difficultyLevel: String) {
        self.id = id
        self.cuisine = cuisine
        self.dishType = dishType
        self.difficultyLevel = difficultyLevel
    }
}

/// Represents a single ingredient in a recipe
@Generable
public struct RecipeIngredientEntityLLM: Identifiable {
    @Guide(description: "Unique identifier for the ingredient")
    public var id: String

    @Guide(description: "Name of the ingredient, e.g., 'Chicken Breast'")
    public var name: String
    
    @Guide(description: "Quantity and unit, e.g., '2 cups', '1 tbsp'")
    public var quantity: String
    
    @Guide(description: "Ingredient type, e.g., 'Main', 'Seasoning'")
    public var type: String
    
    public init(id: String, name: String, quantity: String, type: String) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.type = type
    }
}

/// A single preparation step in a recipe
@Generable
public struct RecipeStepEntityLLM: Identifiable {
    @Guide(description: "Unique identifier for the recipe step")
    public var id: String

    @Guide(description: "Sequential step number in the recipe")
    public var stepNumber: Int
    
    @Guide(description: "Short title for this step")
    public var title: String
    
    @Guide(description: "Equipment needed for this step")
    public var equipmentNeeded: [String]
    
    @Guide(description: "Detailed instructions for this step")
    public var instructions: String
    
    @Guide(description: "Ingredients used in this step")
    public var ingredientsUsed: [RecipeIngredientEntityLLM]
    
    @Guide(description: "Estimated time to complete this step (in minutes)")
    public var estimatedTimeMinutes: Int
    
    @Guide(description: "Definition of done for this step, e.g., 'Dough is smooth'")
    public var definitionOfDone: String
    
    public init(
        id: String,
        stepNumber: Int,
        title: String,
        equipmentNeeded: [String],
        instructions: String,
        ingredientsUsed: [RecipeIngredientEntityLLM],
        estimatedTimeMinutes: Int,
        definitionOfDone: String
    ) {
        self.id = id
        self.stepNumber = stepNumber
        self.title = title
        self.equipmentNeeded = equipmentNeeded
        self.instructions = instructions
        self.ingredientsUsed = ingredientsUsed
        self.estimatedTimeMinutes = estimatedTimeMinutes
        self.definitionOfDone = definitionOfDone
    }
}

// MARK: - Conversion to SwiftData Models

extension RecipeEntityLLM {
    public func toModel() -> Recipe {
        let formatter = ISO8601DateFormatter()
        let date = formatter.date(from: createdAt) ?? Date()
        return Recipe(
            id: id,
            title: title,
            servings: servings,
            totalTimeMinutes: totalTimeMinutes,
            activeTimeMinutes: activeTimeMinutes,
            passiveTimeMinutes: passiveTimeMinutes,
            metadata: metadata.toModel(),
            ingredients: ingredients.map { $0.toModel() },
            steps: steps.map { $0.toModel() },
            allEquipmentNeeded: allEquipmentNeeded,
            createdAt: date
        )
    }
}

extension RecipeMetadataEntityLLM {
    public func toModel() -> RecipeMetadata {
        RecipeMetadata(
            cuisine: cuisine,
            dishType: dishType,
            difficultyLevel: difficultyLevel
        )
    }
}

extension RecipeIngredientEntityLLM {
    public func toModel() -> RecipeIngredient {
        RecipeIngredient(
            name: name,
            quantity: quantity,
            type: type
        )
    }
}

extension RecipeStepEntityLLM {
    public func toModel() -> RecipeStep {
        RecipeStep(
            stepNumber: stepNumber,
            title: title,
            equipmentNeeded: equipmentNeeded,
            instructions: instructions,
            ingredientsUsed: ingredientsUsed.map { $0.toModel() },
            estimatedTimeMinutes: estimatedTimeMinutes,
            definitionOfDone: definitionOfDone
        )
    }
}
