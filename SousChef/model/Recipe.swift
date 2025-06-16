import Foundation
import SwiftData

@Model
public final class Recipe: Identifiable {
    public var id: String
    public var title: String
    public var servings: String
    public var totalTimeMinutes: Int
    public var activeTimeMinutes: Int
    public var passiveTimeMinutes: Int
    public var metadata: RecipeMetadata
    public var ingredients: [RecipeIngredient]
    public var steps: [RecipeStep]
    public var allEquipmentNeeded: [String]
    public var createdAt: Date
    
    public init(id: String, title: String, servings: String, totalTimeMinutes: Int, activeTimeMinutes: Int, passiveTimeMinutes: Int, metadata: RecipeMetadata, ingredients: [RecipeIngredient], steps: [RecipeStep], allEquipmentNeeded: [String], createdAt: Date = Date()) {
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

@Model
public final class RecipeMetadata {
    public var cuisine: String
    public var dishType: String
    public var difficultyLevel: String
    
    public init(cuisine: String, dishType: String, difficultyLevel: String) {
        self.cuisine = cuisine
        self.dishType = dishType
        self.difficultyLevel = difficultyLevel
    }
}

@Model
public final class RecipeIngredient {
    public var name: String
    public var quantity: String
    public var type: String
    
    public init(name: String, quantity: String, type: String) {
        self.name = name
        self.quantity = quantity
        self.type = type
    }
}

@Model
public final class RecipeStep {
    public var stepNumber: Int
    public var title: String
    public var equipmentNeeded: [String]
    public var instructions: String
    public var ingredientsUsed: [RecipeIngredient]
    public var estimatedTimeMinutes: Int
    public var definitionOfDone: String
    
    public init(stepNumber: Int, title: String, equipmentNeeded: [String], instructions: String, ingredientsUsed: [RecipeIngredient], estimatedTimeMinutes: Int, definitionOfDone: String) {
        self.stepNumber = stepNumber
        self.title = title
        self.equipmentNeeded = equipmentNeeded
        self.instructions = instructions
        self.ingredientsUsed = ingredientsUsed
        self.estimatedTimeMinutes = estimatedTimeMinutes
        self.definitionOfDone = definitionOfDone
    }
}

// MARK: - Mock Data for Previews & Testing

extension Recipe {
    static var mockRecipes: [Recipe] {
        [
            Recipe(
                id: "1",
                title: "Spinach Dhal",
                servings: "2",
                totalTimeMinutes: 30,
                activeTimeMinutes: 15,
                passiveTimeMinutes: 10,
                metadata: RecipeMetadata(
                    cuisine: "Italian",
                    dishType: "Pasta",
                    difficultyLevel: "Medium"
                ),
                ingredients: [
                    RecipeIngredient(name: "Spaghetti", quantity: "200g", type: "Pasta"),
                    RecipeIngredient(name: "Eggs", quantity: "2", type: "Dairy"),
                    RecipeIngredient(name: "Pancetta", quantity: "100g", type: "Meat"),
                    RecipeIngredient(name: "Parmesan Cheese", quantity: "50g", type: "Dairy"),
                    RecipeIngredient(name: "Black Pepper", quantity: "to taste", type: "Spice")
                ],
                steps: [
                    RecipeStep(
                        stepNumber: 1,
                        title: "Boil Pasta",
                        equipmentNeeded: ["Pot", "Strainer"],
                        instructions: "Cook spaghetti in salted boiling water until al dente.",
                        ingredientsUsed: [RecipeIngredient(name: "Spaghetti", quantity: "200g", type: "Pasta")],
                        estimatedTimeMinutes: 10,
                        definitionOfDone: "Pasta is al dente."
                    ),
                    RecipeStep(
                        stepNumber: 2,
                        title: "Prepare Sauce",
                        equipmentNeeded: ["Bowl", "Pan"],
                        instructions: "Mix eggs and cheese. Fry pancetta until crisp.",
                        ingredientsUsed: [
                            RecipeIngredient(name: "Eggs", quantity: "2", type: "Dairy"),
                            RecipeIngredient(name: "Parmesan Cheese", quantity: "50g", type: "Dairy"),
                            RecipeIngredient(name: "Pancetta", quantity: "100g", type: "Meat")
                        ],
                        estimatedTimeMinutes: 10,
                        definitionOfDone: "Sauce is creamy, pancetta is crisp."
                    )
                ],
                allEquipmentNeeded: ["Pot", "Strainer", "Bowl", "Pan"],
                createdAt: Date()
            ),
            Recipe(
                id: "2",
                title: "Classic Pancakes",
                servings: "4",
                totalTimeMinutes: 20,
                activeTimeMinutes: 15,
                passiveTimeMinutes: 5,
                metadata: RecipeMetadata(
                    cuisine: "American",
                    dishType: "Breakfast",
                    difficultyLevel: "Easy"
                ),
                ingredients: [
                    RecipeIngredient(name: "Flour", quantity: "200g", type: "Baking"),
                    RecipeIngredient(name: "Milk", quantity: "300ml", type: "Dairy"),
                    RecipeIngredient(name: "Eggs", quantity: "2", type: "Dairy"),
                    RecipeIngredient(name: "Sugar", quantity: "2 tbsp", type: "Baking"),
                    RecipeIngredient(name: "Butter", quantity: "for frying", type: "Dairy")
                ],
                steps: [
                    RecipeStep(
                        stepNumber: 1,
                        title: "Mix Ingredients",
                        equipmentNeeded: ["Bowl", "Whisk"],
                        instructions: "Mix flour, sugar, eggs, and milk to form batter.",
                        ingredientsUsed: [
                            RecipeIngredient(name: "Flour", quantity: "200g", type: "Baking"),
                            RecipeIngredient(name: "Milk", quantity: "300ml", type: "Dairy"),
                            RecipeIngredient(name: "Eggs", quantity: "2", type: "Dairy"),
                            RecipeIngredient(name: "Sugar", quantity: "2 tbsp", type: "Baking")
                        ],
                        estimatedTimeMinutes: 5,
                        definitionOfDone: "Batter is smooth."
                    ),
                    RecipeStep(
                        stepNumber: 2,
                        title: "Cook Pancakes",
                        equipmentNeeded: ["Frying Pan", "Spatula"],
                        instructions: "Fry pancakes in butter until golden on both sides.",
                        ingredientsUsed: [
                            RecipeIngredient(name: "Butter", quantity: "for frying", type: "Dairy")
                        ],
                        estimatedTimeMinutes: 10,
                        definitionOfDone: "Pancakes are golden and cooked through."
                    )
                ],
                allEquipmentNeeded: ["Bowl", "Whisk", "Frying Pan", "Spatula"],
                createdAt: Date()
            ),
            Recipe(
                id: "3",
                title: "Moroccan Tagine with Lamb and Apricots",
                servings: "6",
                totalTimeMinutes: 150,
                activeTimeMinutes: 40,
                passiveTimeMinutes: 90,
                metadata: RecipeMetadata(
                    cuisine: "Moroccan",
                    dishType: "Slow-cooked Stew",
                    difficultyLevel: "Hard"
                ),
                ingredients: [
                    RecipeIngredient(name: "Lamb shoulder", quantity: "1.5 kg", type: "Meat"),
                    RecipeIngredient(name: "Dried apricots", quantity: "200g", type: "Fruit"),
                    RecipeIngredient(name: "Onions", quantity: "2 large", type: "Vegetable"),
                    RecipeIngredient(name: "Garlic cloves", quantity: "4", type: "Vegetable"),
                    RecipeIngredient(name: "Ground ginger", quantity: "2 tsp", type: "Spice"),
                    RecipeIngredient(name: "Ground cumin", quantity: "2 tsp", type: "Spice"),
                    RecipeIngredient(name: "Cinnamon stick", quantity: "1", type: "Spice"),
                    RecipeIngredient(name: "Olive oil", quantity: "4 tbsp", type: "Oil"),
                    RecipeIngredient(name: "Honey", quantity: "3 tbsp", type: "Sweetener"),
                    RecipeIngredient(name: "Chicken stock", quantity: "500ml", type: "Liquid"),
                    RecipeIngredient(name: "Fresh coriander", quantity: "a handful", type: "Herb"),
                    RecipeIngredient(name: "Salt", quantity: "to taste", type: "Seasoning"),
                    RecipeIngredient(name: "Black pepper", quantity: "to taste", type: "Seasoning")
                ],
                steps: [
                    RecipeStep(
                        stepNumber: 1,
                        title: "Prepare Ingredients",
                        equipmentNeeded: ["Knife", "Cutting Board"],
                        instructions: "Chop onions and garlic. Cut lamb into chunks.",
                        ingredientsUsed: [
                            RecipeIngredient(name: "Onions", quantity: "2 large", type: "Vegetable"),
                            RecipeIngredient(name: "Garlic cloves", quantity: "4", type: "Vegetable"),
                            RecipeIngredient(name: "Lamb shoulder", quantity: "1.5 kg", type: "Meat")
                        ],
                        estimatedTimeMinutes: 15,
                        definitionOfDone: "All ingredients chopped and lamb cut."
                    ),
                    RecipeStep(
                        stepNumber: 2,
                        title: "Brown the Lamb",
                        equipmentNeeded: ["Tagine or Heavy Pot", "Stove"],
                        instructions: "Heat olive oil. Brown lamb pieces on all sides.",
                        ingredientsUsed: [
                            RecipeIngredient(name: "Lamb shoulder", quantity: "1.5 kg", type: "Meat"),
                            RecipeIngredient(name: "Olive oil", quantity: "4 tbsp", type: "Oil")
                        ],
                        estimatedTimeMinutes: 15,
                        definitionOfDone: "Lamb pieces are browned evenly."
                    ),
                    RecipeStep(
                        stepNumber: 3,
                        title: "Add Aromatics and Spices",
                        equipmentNeeded: ["Tagine or Heavy Pot"],
                        instructions: "Add onions, garlic, ginger, cumin, cinnamon stick, salt, and pepper. Cook until onions soften.",
                        ingredientsUsed: [
                            RecipeIngredient(name: "Onions", quantity: "2 large", type: "Vegetable"),
                            RecipeIngredient(name: "Garlic cloves", quantity: "4", type: "Vegetable"),
                            RecipeIngredient(name: "Ground ginger", quantity: "2 tsp", type: "Spice"),
                            RecipeIngredient(name: "Ground cumin", quantity: "2 tsp", type: "Spice"),
                            RecipeIngredient(name: "Cinnamon stick", quantity: "1", type: "Spice"),
                            RecipeIngredient(name: "Salt", quantity: "to taste", type: "Seasoning"),
                            RecipeIngredient(name: "Black pepper", quantity: "to taste", type: "Seasoning")
                        ],
                        estimatedTimeMinutes: 10,
                        definitionOfDone: "Onions softened and spices fragrant."
                    ),
                    RecipeStep(
                        stepNumber: 4,
                        title: "Simmer with Apricots and Stock",
                        equipmentNeeded: ["Tagine or Heavy Pot", "Lid", "Stove"],
                        instructions: "Add dried apricots, honey, and chicken stock. Cover and simmer gently for 1.5 hours until lamb is tender.",
                        ingredientsUsed: [
                            RecipeIngredient(name: "Dried apricots", quantity: "200g", type: "Fruit"),
                            RecipeIngredient(name: "Honey", quantity: "3 tbsp", type: "Sweetener"),
                            RecipeIngredient(name: "Chicken stock", quantity: "500ml", type: "Liquid")
                        ],
                        estimatedTimeMinutes: 90,
                        definitionOfDone: "Lamb is tender and sauce is thickened."
                    ),
                    RecipeStep(
                        stepNumber: 5,
                        title: "Garnish and Serve",
                        equipmentNeeded: ["Knife", "Serving Dish"],
                        instructions: "Chop fresh coriander and sprinkle over the dish before serving.",
                        ingredientsUsed: [
                            RecipeIngredient(name: "Fresh coriander", quantity: "a handful", type: "Herb")
                        ],
                        estimatedTimeMinutes: 5,
                        definitionOfDone: "Dish garnished and ready to serve."
                    )
                ],
                allEquipmentNeeded: ["Knife", "Cutting Board", "Tagine or Heavy Pot", "Stove", "Lid", "Serving Dish"],
                createdAt: Date()
            ),
            Recipe(
                id: "4",
                title: "Japanese Kaiseki Style Seasonal Bento",
                servings: "1",
                totalTimeMinutes: 90,
                activeTimeMinutes: 70,
                passiveTimeMinutes: 20,
                metadata: RecipeMetadata(
                    cuisine: "Japanese",
                    dishType: "Kaiseki multi-course Bento Box",
                    difficultyLevel: "Very Hard"
                ),
                ingredients: [
                    RecipeIngredient(name: "Sushi-grade salmon", quantity: "100g", type: "Seafood"),
                    RecipeIngredient(name: "Shiitake mushrooms", quantity: "50g", type: "Vegetable"),
                    RecipeIngredient(name: "Lotus root", quantity: "30g", type: "Vegetable"),
                    RecipeIngredient(name: "Edamame beans", quantity: "40g", type: "Vegetable"),
                    RecipeIngredient(name: "Pickled ginger", quantity: "10g", type: "Condiment"),
                    RecipeIngredient(name: "Rice vinegar", quantity: "2 tbsp", type: "Condiment"),
                    RecipeIngredient(name: "Japanese short grain rice", quantity: "150g", type: "Grain"),
                    RecipeIngredient(name: "Soy sauce", quantity: "to taste", type: "Condiment"),
                    RecipeIngredient(name: "Mirin", quantity: "1 tbsp", type: "Condiment"),
                    RecipeIngredient(name: "Dashi stock", quantity: "100ml", type: "Liquid"),
                    RecipeIngredient(name: "Wasabi paste", quantity: "to taste", type: "Condiment"),
                    RecipeIngredient(name: "Bamboo shoots", quantity: "30g", type: "Vegetable"),
                    RecipeIngredient(name: "Yuzu zest", quantity: "1 tsp", type: "Citrus"),
                    RecipeIngredient(name: "Konbu seaweed", quantity: "5g", type: "Seaweed")
                ],
                steps: [
                    RecipeStep(
                        stepNumber: 1,
                        title: "Prepare Sushi Rice",
                        equipmentNeeded: ["Rice Cooker", "Wooden Bowl"],
                        instructions: "Cook Japanese short grain rice with konbu seaweed. Once cooked, mix with rice vinegar, mirin, and let cool in a wooden bowl.",
                        ingredientsUsed: [
                            RecipeIngredient(name: "Japanese short grain rice", quantity: "150g", type: "Grain"),
                            RecipeIngredient(name: "Konbu seaweed", quantity: "5g", type: "Seaweed"),
                            RecipeIngredient(name: "Rice vinegar", quantity: "2 tbsp", type: "Condiment"),
                            RecipeIngredient(name: "Mirin", quantity: "1 tbsp", type: "Condiment")
                        ],
                        estimatedTimeMinutes: 40,
                        definitionOfDone: "Rice is cooked perfectly and cooled with seasoning."
                    ),
                    RecipeStep(
                        stepNumber: 2,
                        title: "Simmer Vegetables",
                        equipmentNeeded: ["Saucepan", "Strainer"],
                        instructions: "Simmer shiitake mushrooms, lotus root, bamboo shoots, and edamame briefly in dashi stock until tender but firm.",
                        ingredientsUsed: [
                            RecipeIngredient(name: "Shiitake mushrooms", quantity: "50g", type: "Vegetable"),
                            RecipeIngredient(name: "Lotus root", quantity: "30g", type: "Vegetable"),
                            RecipeIngredient(name: "Bamboo shoots", quantity: "30g", type: "Vegetable"),
                            RecipeIngredient(name: "Edamame beans", quantity: "40g", type: "Vegetable"),
                            RecipeIngredient(name: "Dashi stock", quantity: "100ml", type: "Liquid")
                        ],
                        estimatedTimeMinutes: 15,
                        definitionOfDone: "Vegetables are tender and drained."
                    ),
                    RecipeStep(
                        stepNumber: 3,
                        title: "Prepare Salmon",
                        equipmentNeeded: ["Sharp Knife", "Cutting Board"],
                        instructions: "Slice sushi-grade salmon thinly for sashimi presentation.",
                        ingredientsUsed: [
                            RecipeIngredient(name: "Sushi-grade salmon", quantity: "100g", type: "Seafood")
                        ],
                        estimatedTimeMinutes: 10,
                        definitionOfDone: "Salmon sliced thinly and uniformly."
                    ),
                    RecipeStep(
                        stepNumber: 4,
                        title: "Assemble Bento Box",
                        equipmentNeeded: ["Bento Box", "Small Bowls", "Chopsticks"],
                        instructions: "Arrange rice, salmon sashimi, simmered vegetables, pickled ginger, and a small dollop of wasabi in compartments. Garnish with yuzu zest and serve soy sauce on side.",
                        ingredientsUsed: [
                            RecipeIngredient(name: "Sushi-grade salmon", quantity: "100g", type: "Seafood"),
                            RecipeIngredient(name: "Pickled ginger", quantity: "10g", type: "Condiment"),
                            RecipeIngredient(name: "Wasabi paste", quantity: "to taste", type: "Condiment"),
                            RecipeIngredient(name: "Yuzu zest", quantity: "1 tsp", type: "Citrus")
                        ],
                        estimatedTimeMinutes: 20,
                        definitionOfDone: "Bento box is neatly arranged and visually balanced."
                    )
                ],
                allEquipmentNeeded: ["Rice Cooker", "Wooden Bowl", "Saucepan", "Strainer", "Sharp Knife", "Cutting Board", "Bento Box", "Small Bowls", "Chopsticks"],
                createdAt: Date()
            )
        ]
    }
}
