import Foundation

struct SeedData {
    static func loadAndPersistSeedRecipes(using storage: UserDefaultsStorage) throws {
        let seedRecipes = generateSeedRecipes()
        
        for recipe in seedRecipes {
            try storage.saveRecipe(recipe)
        }
    }
    
    private static func generateSeedRecipes() -> [RecipeStorageSchema] {
        let formatter = ISO8601DateFormatter()
        let now = formatter.string(from: Date())
        
        return [
            RecipeStorageSchema(
                id: "seed-1",
                title: "Classic Carbonara",
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
                    IngredientSchema(name: "Spaghetti", quantity: "400g", type: "Pasta"),
                    IngredientSchema(name: "Eggs", quantity: "3", type: "Dairy"),
                    IngredientSchema(name: "Pancetta", quantity: "150g", type: "Meat"),
                    IngredientSchema(name: "Parmesan", quantity: "100g", type: "Dairy"),
                    IngredientSchema(name: "Black Pepper", quantity: "to taste", type: "Spice")
                ],
                steps: [
                    StepSchema(
                        stepNumber: 1,
                        title: "Boil Water",
                        equipmentNeeded: ["Pot"],
                        instructions: "Bring salted water to boil.",
                        ingredientsUsed: [],
                        estimatedTimeMinutes: 5,
                        definitionOfDone: "Water is boiling"
                    ),
                    StepSchema(
                        stepNumber: 2,
                        title: "Cook Pasta",
                        equipmentNeeded: ["Pot", "Strainer"],
                        instructions: "Cook spaghetti until al dente.",
                        ingredientsUsed: [IngredientSchema(name: "Spaghetti", quantity: "400g", type: "Pasta")],
                        estimatedTimeMinutes: 10,
                        definitionOfDone: "Pasta is al dente"
                    ),
                    StepSchema(
                        stepNumber: 3,
                        title: "Make Sauce",
                        equipmentNeeded: ["Bowl", "Whisk"],
                        instructions: "Mix eggs, cheese, and pepper.",
                        ingredientsUsed: [
                            IngredientSchema(name: "Eggs", quantity: "3", type: "Dairy"),
                            IngredientSchema(name: "Parmesan", quantity: "100g", type: "Dairy"),
                            IngredientSchema(name: "Black Pepper", quantity: "to taste", type: "Spice")
                        ],
                        estimatedTimeMinutes: 5,
                        definitionOfDone: "Sauce is well combined"
                    ),
                    StepSchema(
                        stepNumber: 4,
                        title: "Fry Pancetta",
                        equipmentNeeded: ["Pan"],
                        instructions: "Cook pancetta until crispy.",
                        ingredientsUsed: [IngredientSchema(name: "Pancetta", quantity: "150g", type: "Meat")],
                        estimatedTimeMinutes: 5,
                        definitionOfDone: "Pancetta is crispy"
                    ),
                    StepSchema(
                        stepNumber: 5,
                        title: "Combine",
                        equipmentNeeded: ["Large Bowl"],
                        instructions: "Toss hot pasta with sauce and pancetta.",
                        ingredientsUsed: [],
                        estimatedTimeMinutes: 5,
                        definitionOfDone: "Sauce coats all pasta"
                    )
                ],
                allEquipmentNeeded: ["Pot", "Strainer", "Bowl", "Whisk", "Pan", "Large Bowl"],
                createdAt: now
            ),
            RecipeStorageSchema(
                id: "seed-2",
                title: "Margherita Pizza",
                servings: "4",
                totalTimeMinutes: 45,
                activeTimeMinutes: 30,
                passiveTimeMinutes: 15,
                metadata: RecipeMetadataSchema(
                    cuisine: "Italian",
                    dishType: "Pizza",
                    difficultyLevel: "Easy"
                ),
                ingredients: [
                    IngredientSchema(name: "Pizza Dough", quantity: "500g", type: "Dough"),
                    IngredientSchema(name: "Tomato Sauce", quantity: "200ml", type: "Sauce"),
                    IngredientSchema(name: "Mozzarella", quantity: "300g", type: "Cheese"),
                    IngredientSchema(name: "Fresh Basil", quantity: "10 leaves", type: "Herb"),
                    IngredientSchema(name: "Olive Oil", quantity: "3 tbsp", type: "Oil")
                ],
                steps: [
                    StepSchema(
                        stepNumber: 1,
                        title: "Prepare Dough",
                        equipmentNeeded: ["Work Surface"],
                        instructions: "Stretch pizza dough to desired size.",
                        ingredientsUsed: [IngredientSchema(name: "Pizza Dough", quantity: "500g", type: "Dough")],
                        estimatedTimeMinutes: 10,
                        definitionOfDone: "Dough is thin and evenly stretched"
                    ),
                    StepSchema(
                        stepNumber: 2,
                        title: "Add Sauce",
                        equipmentNeeded: ["Spoon"],
                        instructions: "Spread tomato sauce evenly.",
                        ingredientsUsed: [IngredientSchema(name: "Tomato Sauce", quantity: "200ml", type: "Sauce")],
                        estimatedTimeMinutes: 5,
                        definitionOfDone: "Sauce covers dough evenly"
                    ),
                    StepSchema(
                        stepNumber: 3,
                        title: "Add Cheese",
                        equipmentNeeded: [],
                        instructions: "Tear and add fresh mozzarella.",
                        ingredientsUsed: [IngredientSchema(name: "Mozzarella", quantity: "300g", type: "Cheese")],
                        estimatedTimeMinutes: 5,
                        definitionOfDone: "Cheese is distributed"
                    ),
                    StepSchema(
                        stepNumber: 4,
                        title: "Bake",
                        equipmentNeeded: ["Oven"],
                        instructions: "Bake at 250°C for 15 minutes.",
                        ingredientsUsed: [],
                        estimatedTimeMinutes: 15,
                        definitionOfDone: "Cheese is melted and crust is golden"
                    ),
                    StepSchema(
                        stepNumber: 5,
                        title: "Garnish",
                        equipmentNeeded: [],
                        instructions: "Add fresh basil and olive oil.",
                        ingredientsUsed: [
                            IngredientSchema(name: "Fresh Basil", quantity: "10 leaves", type: "Herb"),
                            IngredientSchema(name: "Olive Oil", quantity: "3 tbsp", type: "Oil")
                        ],
                        estimatedTimeMinutes: 5,
                        definitionOfDone: "Pizza is garnished"
                    )
                ],
                allEquipmentNeeded: ["Work Surface", "Spoon", "Oven"],
                createdAt: now
            )
        ]
    }
    
    static func generateSampleCookSession(recipeId: String) -> CookSessionSchema {
        let formatter = ISO8601DateFormatter()
        return CookSessionSchema(
            id: UUID().uuidString,
            recipeId: recipeId,
            startTime: formatter.string(from: Date()),
            endTime: nil,
            currentStep: 1,
            notes: "Started cooking",
            status: "in_progress"
        )
    }
}
