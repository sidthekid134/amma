// Modularizing RecipeIngredientsSection from RecipeDetailView.swift
import SwiftUI

struct RecipeIngredientsSection: View {
    let groupedIngredients: [(type: String, ingredients: [RecipeIngredient])]
    
    var body: some View {
        let columns = [GridItem(.adaptive(minimum: 130, maximum: 250), spacing: 4)]
        
        VStack(alignment: .leading, spacing: 16) {
            ForEach(groupedIngredients, id: \.type) { group in
                VStack(alignment: .leading, spacing: 8) {
                    Text(group.type.capitalized)
                        .font(.title3.bold())
                        .foregroundColor(.accentColor)
                    LazyVGrid(columns: columns, alignment: .leading, spacing: 4) {
                        ForEach(group.ingredients.indices, id: \.self) { index in
                            IngredientChipView(ingredient: group.ingredients[index])
                                .frame(maxWidth: .infinity)
                        }
                    }
                    
                }
                if group.type != groupedIngredients.last?.type {
                    Divider()
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }
}
