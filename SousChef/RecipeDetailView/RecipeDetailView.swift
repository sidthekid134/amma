import SwiftUI

import SwiftData


struct RecipeDetailView: View {

    let recipe: Recipe
    let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 16)
    ]
    let ingredientTypePriority = ["pasta", "meat", "dairy", "vegetable", "oil", "spice", "baking"]
    
    
    private var groupedIngredients: [(type: String, ingredients: [RecipeIngredient])] {
        let groups = Dictionary(grouping: recipe.ingredients) { $0.type.lowercased() }
        let sortedKeys = groups.keys.sorted { a, b in
            let aIndex = ingredientTypePriority.firstIndex(of: a)
            let bIndex = ingredientTypePriority.firstIndex(of: b)
            switch (aIndex, bIndex) {
            case let (a?, b?):
                return a < b
            case (.some, nil):
                return true
            case (nil, .some):
                return false
            case (nil, nil):
                return a < b
            }
        }
        return sortedKeys.map { (type: $0, ingredients: groups[$0] ?? []) }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                RecipeImageSection(concept: recipe.title)
                    .id(recipe.id)
                    .padding(.top, 8)
                    .padding(.bottom, 2)
                
                RecipeMetadataSection(recipe: recipe, createdAtFormatted: createdAtFormatted)
                
                RecipeTimelineSection(recipe: recipe)
                
                RecipeIngredientsSection(groupedIngredients: groupedIngredients)
                
                RecipeStepsSection(steps: recipe.steps)
                
                if !recipe.allEquipmentNeeded.isEmpty {
                    RecipeEquipmentSection(allEquipmentNeeded: recipe.allEquipmentNeeded, columns: columns)
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 8)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var createdAtFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: recipe.createdAt)
    }
}


struct RecipeDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        let mockRecipe = Recipe(
            id: "preview-1",
            title: "Spaghetti Bolognese",
            servings: "4",
            totalTimeMinutes: 90,
            activeTimeMinutes: 30,
            passiveTimeMinutes: 60,
            metadata: RecipeMetadata(
                cuisine: "Italian",
                dishType: "Pasta",
                difficultyLevel: "Medium"
            ),
            ingredients: [
                RecipeIngredient(name: "Spaghetti", quantity: "400g", type: "Pasta"),
                RecipeIngredient(name: "Olive Oil", quantity: "2 tbsp", type: "Oil"),
                RecipeIngredient(name: "Onion", quantity: "1, chopped", type: "Vegetable"),
                RecipeIngredient(name: "Garlic Cloves", quantity: "2, minced", type: "Vegetable"),
                RecipeIngredient(name: "Ground Beef", quantity: "400g", type: "Meat"),
                RecipeIngredient(name: "Canned Tomatoes", quantity: "800g", type: "Vegetable"),
                RecipeIngredient(name: "Salt and Pepper", quantity: "to taste", type: "Spice")
            ],
            steps: [
                RecipeStep(
                    stepNumber: 1,
                    title: "Cook pasta",
                    equipmentNeeded: ["Large pot"],
                    instructions: "Cook spaghetti according to package instructions.",
                    ingredientsUsed: [RecipeIngredient(name: "Spaghetti", quantity: "400g", type: "Pasta")],
                    estimatedTimeMinutes: 10,
                    definitionOfDone: "Pasta is cooked."
                ),
                RecipeStep(
                    stepNumber: 2,
                    title: "Sauté vegetables",
                    equipmentNeeded: ["Frying pan"],
                    instructions: "Heat olive oil in a pan and sauté onion and garlic until translucent.",
                    ingredientsUsed: [
                        RecipeIngredient(name: "Olive Oil", quantity: "2 tbsp", type: "Oil"),
                        RecipeIngredient(name: "Onion", quantity: "1, chopped", type: "Vegetable"),
                        RecipeIngredient(name: "Garlic Cloves", quantity: "2, minced", type: "Vegetable")
                    ],
                    estimatedTimeMinutes: 10,
                    definitionOfDone: "Vegetables are soft."
                )
            ],
            allEquipmentNeeded: [
                "Large pot",
                "Frying pan",
                "Wooden spoon",
                "Colander"
            ],
            createdAt: Date()
        )
        NavigationView {
            RecipeDetailView(recipe: mockRecipe)
        }
    }
}


#if DEBUG
#Preview("ImageCreatorPlaygroundExample") {
    if #available(iOS 26.0, *) {
      Text("Requires iOS 18 or macOS 15")
    } else {
        Text("Requires iOS 18 or macOS 15")
    }
}
#endif

